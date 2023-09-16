import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fukuro_mobile/Controller/WebSocketClient.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/dsik_drive.dart';
import 'package:fukuro_mobile/Model/node.dart';
import 'package:fukuro_mobile/View/Component/Misc/disk_list.dart';
import 'package:fukuro_mobile/View/Component/Misc/expandable_fab.dart';
import 'package:fukuro_mobile/View/Component/Misc/fukuro_dialog.dart';
import 'package:fukuro_mobile/View/Component/Misc/metric_select.dart';
import 'package:fukuro_mobile/View/Component/Node/realtime/cpu_realtime.dart';
import 'package:fukuro_mobile/View/Component/Node/realtime/disk_realtime.dart';
import 'package:fukuro_mobile/View/Component/Node/realtime/mem_realtime.dart';
import 'package:fukuro_mobile/View/Component/Node/realtime/net_realtime.dart';
import 'package:intl/intl.dart';
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
  final TextEditingController _txtCommand = TextEditingController();
  final ScrollController _cmdScroller = ScrollController();

  final WebSocketClient wsc = WebSocketClient();

  bool isTerminalVisible = false;
  double terminalHeight = 150.0;
  bool isCommand = true;
  List<Map<String, dynamic>>? metricSelection;
  bool isConnected = false;
  String emptyText =
      "Click the button at the bottom right of the screen to perform action";

  List<Command> commands = [];

  @override
  void initState() {
    super.initState();
    try {
      wsc.addListener("error", _websocket_error);
      wsc.addListener("connected", _websocket_connected);
      wsc.addListener("command/result", _addCommand);
      wsc.connect(widget.node);
    } catch (e) {
      print("mende error ni $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
                height: 16), // Adjust the space between the indicator and text
            Text('Connecting...'),
          ],
        ),
      );
    }
    // TODO: implement build
    return Scaffold(
      body: Stack(
        children: [
          // Your main content goes here
          Expanded(
              child: (charts.isNotEmpty)
                  ? ListView(
                      children: charts.map((report) {
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: 15.0), // Set the margin here
                          child: report,
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text(emptyText)]),
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
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _clearCommand();
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
                                icon: const Icon(
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
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    color: Colors.grey.shade800,
                    child: ListView(
                      controller: _cmdScroller,
                      shrinkWrap: true,
                      children: commands.map((cmd) {
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: 15.0), // Set the margin here
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Text(
                                    cmd.dtString() + " : ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'RobotoMono',
                                    ),
                                  ),
                                  Text(cmd.text,
                                      style: TextStyle(
                                        color: (cmd.input == true)
                                            ? Colors.blue
                                            : Colors.yellow, 
                                        fontFamily: 'RobotoMono',
                                        
                                      ))
                                ],
                              )),
                        );
                      }).toList(),
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
                              controller: _txtCommand,
                              maxLines: 3,
                              minLines: 1,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    (isCommand == true) ? 'Command' : 'Tool',
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
                                          _sendCommand();
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
      floatingActionButton: (widget.node.access == 3)
          ? FloatingActionButton(
              onPressed: () {
                _selectMetric();
              },

              hoverColor: Colors.blue, // Optional: Change the hover color
              hoverElevation: 10, // Optional: Adjust the elevation on hover
              child: const Icon(Icons.display_settings_rounded),
            )
          : isTerminalVisible
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
      return (target == Metrics.cpu && chart is CPURealtime) ||
          (target == Metrics.memory && chart is MEMRealtime) ||
          (target == Metrics.network && chart is NETRealtime);
    });
  }

  _addDiskChart(DiskDrive d) {
    Navigator.of(context).pop();
    if (d.monitored == false) {
      FukuroDialog.error(context, "Invalid Disk Selected",
          "Selected disk is not being monitored by the agent, please enable in configuration screen first");
      return;
    }
    print(d);
    int found = -1;
    for (var i = 0; i < charts.length; i++) {
      if (charts[i] is DiskRealtime) {
        if ((charts[i] as DiskRealtime).diskName == d.name) {
          found = i;
        }
      }
    }
    if (found == -1) {
      charts.add(DiskRealtime(
        node: widget.node,
        websocket: wsc,
        diskName: d.name,
      ));
    } else {
      charts.removeAt(found);
    }

    int diskcount = 0;
    for (var c in charts) {
      if (c is DiskRealtime) {
        diskcount++;
      }
    }

    for (var ms in metricSelection!) {
      if (ms["value"] == Metrics.disk) {
        ms["toggle"] = (diskcount != 0);
      }
    }
    setState(() {});
  }

  _addChart(Metrics added) {
    Navigator.of(context).pop();
    if (added == Metrics.disk) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
              padding: const EdgeInsets.all(50),
              alignment: Alignment.center,
              child: DiskList(
                node: widget.node,
                fnSelect: _addDiskChart,
                title: "Select Disk",
                showMonitorStat: true,
              ));
        },
      );
      return;
    }
    print(added);
    for (var i in metricSelection!) {
      if (i["value"] == added) {
        i["toggle"] = !i["toggle"];
        if (i["toggle"] == true) {
          if (i["value"] == Metrics.cpu) {
            charts.add(CPURealtime(
              node: widget.node,
              websocket: wsc,
            ));
          }
          if (i["value"] == Metrics.memory) {
            charts.add(MEMRealtime(
              node: widget.node,
              websocket: wsc,
            ));
          }
          if (i["value"] == Metrics.network) {
            charts.add(NETRealtime(
              node: widget.node,
              websocket: wsc,
            ));
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

  //websockets
  _websocket_error(msg) async {
    print('ws errrr ');
    if (mounted) {
      await FukuroDialog.error(
          context, "Websocket Error", msg['data']?.toString() ?? "");

      Navigator.pop(context);
      Navigator.pushNamed(context, '/node', arguments: widget.node);
    }
  }

  _websocket_connected() {
    isConnected = true;
    if (mounted) {
      FukuroDialog.success(
          context, "Connected", "Success fully connected to agent");
      setState(() {});
    }
  }

  _sendCommand() async {
    String input = _txtCommand.text;
    commands.add(Command(text: input, input: true));
    wsc.sendMessage({"path": "command", "data": input});
    _txtCommand.text = "";
    setState(() {});

    Timer(Duration(milliseconds: 1), () {
      _cmdScroller.jumpTo(_cmdScroller.position.maxScrollExtent);
    });
  }

  _addCommand(data) async {
    print("adding $data");
    String newcmd = "";
    if (data["dir"] != null) {
      newcmd += "current directory: " + data["dir"].toString() + "\n";
    }
    newcmd += data["data"].toString();
    commands.add(Command(text: newcmd, input: false));
    setState(() {});

    Timer(Duration(milliseconds: 500), () {
      _cmdScroller.jumpTo(_cmdScroller.position.maxScrollExtent);
    });
  }

  _clearCommand() {
    if (commands.isEmpty) {
      return;
    }
    FukuroDialog msg = FukuroDialog(
      title: "Clear Commands?",
      message: " ",
      mode: FukuroDialog.INFO,
      NoBtn: true,
      BtnText: "Yes",
    );

    showDialog(context: context, builder: (_) => msg).then((value) async {
      if (msg.okpressed) {
        commands.clear();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    wsc.close();
    super.dispose();
  }
}

class Command {
  DateTime dateTime = DateTime.now();
  String text = "";
  bool? input;
  Command({required this.text, this.input});
  String dtString() {
    DateFormat dt = DateFormat('hh:mm:ss aa');
    return dt.format(dateTime.toLocal());
  }
}
