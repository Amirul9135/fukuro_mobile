import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Model/dsik_drive.dart';
import 'package:fukuro_mobile/Model/node.dart';

class DiskList extends StatelessWidget {
  DiskList(
      {super.key, required this.node, this.fnSelect, this.showMonitorStat,this.title});
  final Node node;
  final Function(DiskDrive)? fnSelect;
  final bool? showMonitorStat;
  final String? title;

  late final Future<List<DiskDrive>> disks =
      NodeController.getDiskList(node.getNodeId()); // node id later
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: disks,
      builder: (BuildContext context, AsyncSnapshot<List<DiskDrive>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    (snapshot.data!.isEmpty)? "No Disk Available" :( title?? "Disk List"),
                    textAlign: TextAlign.center,
                    style:const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if(node.access == 1){

                            fnSelect?.call(snapshot.data![index]);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: () {
                              if (showMonitorStat == true) {
                                if (snapshot.data![index].monitored == true) {
                                  return Colors.lightBlue.withOpacity(.3);
                                }
                              }
                            }(),
                            border: Border.all(
                              color: Colors.blue, // Border color
                              width: 2.0, // Border width
                            ),
                          ),
                          child: ListView(shrinkWrap: true, children: [
                            Row(
                              children: [
                                Text(
                                  snapshot.data![index].name,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                (showMonitorStat == true &&
                                        snapshot.data![index].monitored == true)
                                    ? const Tooltip(
                                        message:
                                            "Monitoring is turned on for this disk",
                                        child: Icon(
                                          Icons.monitor_heart_outlined,
                                          color: Colors.blue,
                                        ))
                                    : Container()
                              ],
                            ),
                            Row(
                              children: [
                                Text(snapshot.data![index].strUsed),
                                const Text(" / "),
                                Text(snapshot.data![index].strSize),
                                Text(" (" +
                                    snapshot.data![index].usedPercent
                                        .toStringAsPrecision(2) +
                                    "%)")
                              ],
                            ),
                            LinearProgressIndicator(
                              minHeight: 20,
                              value:
                                  1 * snapshot.data![index].usedPercent / 100,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                          ]),
                        ),
                      );
                    },
                  )
                ],
              ));
        }
      },
    );
  }
}
