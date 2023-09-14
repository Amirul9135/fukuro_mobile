import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_request.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/activity_log.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class NodeLog extends StatefulWidget {
  const NodeLog({Key? key, required this.node}) : super(key: key);
  final Node node;
  @override
  NodeLogState createState() => NodeLogState();
}

class NodeLogState extends State<NodeLog> {
  // Define your state variables here
  final Map<String, Map<dynamic, dynamic>> dtStart = {};
  final Map<String, Map<dynamic, dynamic>> dtEnd = {}; 
  bool isLoading = false;
  final List<ActivityLog> data = [];

  @override
  void initState() {
    super.initState();
    DateFormat dt = DateFormat('yyyy-MM-dd HH:mm'); 
    String today = dt.format(DateTime.now().toLocal());
    String yesterday = dt.format(DateTime.now().toLocal().subtract(const Duration(days: 1)));
    
    dtStart['dtStart'] = FukuroFormFieldBuilder(
      fieldName: 'FROM',
      type: FukuroForm.inputDateTime,
      value: yesterday,
    ).build();
    dtStart['dtStart']!['refresh'] = true;
    dtEnd['dtEnd'] = FukuroFormFieldBuilder(
      fieldName: 'UNTIL',
      type: FukuroForm.inputDateTime,
      value: today,
    ).build();
    dtEnd['dtEnd']!['refresh'] = true;
     
  }

  @override
  Widget build(BuildContext context) {
    
    if (isLoading) {
      return Center(
        
        child: Container(
          margin:const EdgeInsets.all(10),
          child: const Stack(
          
          alignment: Alignment.center,
          children: [
             CircularProgressIndicator(),
            Text(
              'Loading node logs ...',
              style:  TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),)
      );
    }
     
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(.2), // Border color
            width: 2.0, // Border width
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.fromLTRB(1.w, 2.h, 1.w, 2.h),
        padding: EdgeInsets.fromLTRB(1.w, 2.h, 1.w, 2.h),
        child: Column(
          children: [
            Expanded(
                child: 
                ListView(
                  shrinkWrap: true,
              children: [

                PaginatedDataTable(
                  rowsPerPage: 50,
                      columns: const [
                        DataColumn(label: Text('Date Time')),
                        DataColumn(label: Text('User')),
                        DataColumn(label: Text('Log')), 
                      ],
                      source: _DataSource(
                          data: data)
                      ),
              ],
            )),
            const Divider(),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: FukuroForm(fields: dtStart),
                  ),
                ),
                Flexible(
                    flex: 2,
                    child: Center(
                      child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue, // Background color
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 2.5),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () { 
                          _loadData();
                        },
                      )),
                    )),
                Flexible(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    child: FukuroForm(fields: dtEnd),
                  ),
                ),
              ],
            )
          ],
        ));
  }
  _loadData()async{
    
    isLoading = true;
    setState(() {
      
    });
    String dateStart = dtStart['dtStart']?['controller'].text;
    String dateEnd = dtEnd['dtEnd']?['controller'].text;
    print(dateStart);
    FukuroResponse res = await NodeController.getLogs(widget.node.getNodeId(), dateStart, dateEnd);
    print(res.body());
    data.clear();
    isLoading = false;
    if(res.ok()){
      for(var item in res.body()){
        data.add(ActivityLog.fromJson(item));
      }
    }
    else{
      if(mounted){
        FukuroDialog.error(context, "Error", "Unable to load log data");
      }
    }
    if(mounted){
      setState(() {
        
      });
    }
  }
}


class _DataSource extends DataTableSource {
  final List<ActivityLog> data;
  double? threshold;

  _DataSource({required this.data});
  DateFormat dt = DateFormat('dd/MM/yyyy  hh:mm:ss aa');
  @override
  DataRow getRow(int index) {
    final item = data[index];
    return DataRow(cells: [
      DataCell(Text(dt.format(item.dateTime.toLocal()))),
      DataCell(Text(item.user)),
      DataCell(Text(item.log)), 
    ]);
  }

  @override
  int get rowCount => data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
