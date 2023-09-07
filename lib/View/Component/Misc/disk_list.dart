import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/node_controller.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/dsik_drive.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/big_button.dart';
import 'package:sizer/sizer.dart';

class DiskList extends StatelessWidget {
  DiskList({
    super.key,
    this.selectDisk,
    required this.node,
  });
  final Node node;

  final Function(Metrics)? selectDisk;

  late final Future<List<DiskDrive>> disks = NodeController.getDiskList(1);
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
              padding: const EdgeInsets.all(2),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 4,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.blue, // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    child: ListView(shrinkWrap: true, children: [
                      Text(
                        snapshot.data![index].name,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(snapshot.data![index].strUsed),
                          const Text(" / "),
                          Text(snapshot.data![index].strSize)
                        ],
                      ),
                      LinearProgressIndicator(
                        minHeight: 10,
                        value: 1 * snapshot.data![index].usedPercent / 100,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ]),
                  );
                },
              ));
        }
      },
    );
  }
}
