import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Misc/metric_select.dart';
import 'package:fukuro_mobile/View/Component/Node/realtime/cpu_realtime.dart';
import 'package:sizer/sizer.dart';

class NodeRealtimeScreen extends StatefulWidget {
  const NodeRealtimeScreen({Key? key, required this.node}) : super(key: key);
  final Node node;
  @override
  NodeRealtimeScreenState createState() => NodeRealtimeScreenState();
}

class NodeRealtimeScreenState extends State<NodeRealtimeScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> charts = [];
  TextEditingController _textEditingController = TextEditingController();
  final double _minHeight = 50.0;
  final double _maxHeight = 150.0;

  bool isTerminalVisible = false;
  double terminalHeight = 150.0;
  bool isCommand = true;
  List<Map<String, dynamic>>? metricSelection;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          // Your main content goes here
          Expanded(
              child: ListView(
            children: charts.map((report) {
              return Container(
                margin:
                    const EdgeInsets.only(bottom: 15.0), // Set the margin here
                child: report,
              );
            }).toList(),
          )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: isTerminalVisible ? terminalHeight : 0,
            child: Container(
              child: Column(
                children: [
                  // Handle for resizing
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      setState(() {
                        terminalHeight -= details.delta.dy;
                        terminalHeight = terminalHeight.clamp(
                            50.0, 70.h); // Limit height if desired
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                        color: Colors.blue,
                      ),
                      width: double.infinity,
                      child: Row(children: [
                        Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              child: IconButton(
                                icon: Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                            )),
                        Flexible(
                            flex: 8,
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Icon(
                                  Icons.unfold_more_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              child: IconButton(
                                icon: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isTerminalVisible = false;
                                  });
                                },
                              ),
                            ))
                      ]),
                    ),
                  ),

                  // Terminal content
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    color: Colors.grey.shade800,
                    child: ListView(
                      shrinkWrap: true,
                      children: [],
                    ),
                  )),
                  Row(
                    children: [
                      Flexible(
                          flex: 9,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            color: Colors.white,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              controller: _textEditingController,
                              maxLines: 3,
                              minLines: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Command',
                              ),
                            ),
                          )), // Add some space between the TextField and the button
                      Flexible(
                          flex: 1,
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.white,
                              child: Center(
                                child: GestureDetector(
                                  onLongPress: () {
                                    setState(() {
                                      isCommand = !isCommand;
                                      Fluttertoast.showToast(
                                          msg: "Changed mode to " +
                                              ((isCommand == true)
                                                  ? "Execute command"
                                                  : "Execute tools"),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          fontSize: 16.0);
                                    });
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .lightBlue, // Background color
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2.5),
                                      child: IconButton(
                                        icon: () {
                                          if (isCommand) {
                                            return const Icon(
                                              Icons.send,
                                              color: Colors.white,
                                            );
                                          } else {
                                            return const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            );
                                          }
                                        }(),
                                        onPressed: () {
                                          print("tap");
                                        },
                                      )),
                                ),
                              )))
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isTerminalVisible
          ? Container()
          : ExpandableFab(
              icon: const Icon(Icons.ads_click),
              distance: 60,
              children: [
                ActionButton(
                  onPressed: () {
                    setState(() {
                      isTerminalVisible = true;
                    });
                  },
                  icon: const Icon(Icons.code_rounded),
                ),
                ActionButton(
                  onPressed: () {
                    _selectMetric();
                  },
                  icon: const Icon(Icons.display_settings_rounded),
                ),
              ],
            ),
    );
  }

  _selectMetric() {
    MetricSelect msc = MetricSelect(
      selectMetric: _addChart,
      buttonsData: metricSelection,
      toggleMode: true,
    );
    metricSelection = msc.data();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return msc;
      },
    );
  }

  _removeChart(Metrics target) {
    print("removing $target");
    charts.removeWhere((chart) {
      return target == Metrics.cpu && chart is CPURealtime;
    });
  }

  _addChart(Metrics added) {
    Navigator.of(context).pop();
    print(added);
    for (var i in metricSelection!) {
      if (i["value"] == added) {
        i["toggle"] = !i["toggle"];
        if (i["toggle"] == true) {
          if (i["value"] == Metrics.cpu) {
            charts.add(CPURealtime(node: widget.node));
          }
        } else {
          _removeChart(added);
        }
        if (mounted) {
          setState(() {});
        }
      }
    }
  }
}
