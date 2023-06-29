import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:fukuro_mobile/Controller/fukuro_editor_controller.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:fukuro_mobile/Model/fukuro_ref.dart';
import 'package:fukuro_mobile/View/Component/fukuro_form.dart';
import 'package:sizer/sizer.dart';

class NodeResourceConfig extends StatefulWidget {
  NodeResourceConfig({Key? key, required this.values}) : super(key: key);
  final Map<String, dynamic> values;
  @override
  NodeResourceConfigState createState() => NodeResourceConfigState();
}

class NodeResourceConfigState extends State<NodeResourceConfig> {
  final GlobalKey<ExpansionTileCustomState> keyCardNode = GlobalKey();
  final GlobalKey<ExpansionTileCustomState> keyCardLocal = GlobalKey();

  final GlobalKey<FukuroFormState> keyLocalForm = GlobalKey();

  final FukuroEditorController RTPeriod = FukuroEditorController();
  final FukuroEditorController HTPeriod = FukuroEditorController();
  final FukuroEditorController HTInterval = FukuroEditorController();
  final FukuroEditorController HTThreshold = FukuroEditorController();
  final FukuroEditorController HTExtractInterval = FukuroEditorController();

  final ByRef RTPeriodUnit = ByRef();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        keyCardLocal.currentState?.expand();
        keyCardNode.currentState?.expand();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    FukuroForm localSettingsForm = FukuroForm(key: keyLocalForm, fields: {
      'RTPeriod': FukuroFormFieldBuilder(
        fieldName: "Realtime Chart Period",
        controller: RTPeriod,
        type: FukuroForm.inputNumerical,
        icon: const Icon(Icons.short_text_outlined),
        prefix: "Realtime Chart Period",
        rightAllign: true,
        value: widget.values["RTPeriod"].toString(),
        isTimeUnit: true,
      ).build(),
      'HTPeriod': FukuroFormFieldBuilder(
              fieldName: "Historical Chart Period",
              controller: HTPeriod,
              type: FukuroForm.inputNumerical,
              icon: const Icon(Icons.short_text_outlined),
              prefix: "Historical Chart Period",
              rightAllign: true,
              isTimeUnit: true)
          .build(),
      'HTInterval': FukuroFormFieldBuilder(
              fieldName: "Historical Chart Data Intervals",
              controller: HTInterval,
              type: FukuroForm.inputNumerical,
              icon: const Icon(Icons.open_in_full_outlined),
              prefix: "Historical Chart Data Intervals",
              rightAllign: true,
              isTimeUnit: true)
          .build(),
      'HTThreshold': FukuroFormFieldBuilder(
        fieldName: "Historical Chart Threshold",
        controller: HTThreshold,
        type: FukuroForm.inputNumerical,
        numMin: 10,
        numMax: 100,
        icon: const Icon(Icons.data_thresholding_outlined),
        prefix: "Historical Chart Threshold",
        rightAllign: true,
      ).build(),
    });
    FukuroForm nodeSettingForm = FukuroForm(fields: {
      "HTExtractInterval": FukuroFormFieldBuilder(
              fieldName: "CPU Extract Interval",
              controller: HTExtractInterval,
              type: FukuroForm.inputNumerical,
              icon: const Icon(Icons.refresh_outlined),
              prefix: 'CPU Extract Interval',
              rightAllign: true,
              isTimeUnit: true)
          .build()
    });

    RTPeriod.text = widget.values["RTPeriod"].toString();
    HTPeriod.text = widget.values["HTPeriod"].toString();
    HTInterval.text = widget.values["HTInterval"].toString();
    HTThreshold.text = widget.values["HTThreshold"].toString();
    print(widget.values);
    HTExtractInterval.text = widget.values["HTExtractInterval"].toString();
    return Container(
      padding: EdgeInsets.fromLTRB(5.w, 1.h, 5.w, 5.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTileBorderItem(
              expansionKey: keyCardLocal,
              title: const Row(
                children: [
                  Icon(Icons.app_settings_alt_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Local Setting",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              children: [
                const Divider(
                  color: Colors.grey,
                  thickness: 1.0,
                  height: 0,
                ),
                verticalGap(1.h),
                localSettingsForm
              ],
            ),
            verticalGap(2.h),
            ExpansionTileBorderItem(
              expansionKey: keyCardNode,
              title: const Row(
                children: [
                  Icon(Icons.display_settings_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Node Setting",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              children: [nodeSettingForm],
            ),
          ],
        ),
      ),
    );
  }

  bool validate(){ 
    print('validate');
    print(keyLocalForm.currentState?.validateForm());
    return keyLocalForm.currentState?.validateForm()?? false; 
  }

  Map<String, dynamic> saveSetting() {
    print('test');
    Map<String, dynamic> fieldVals = {};
    fieldVals["RTPeriod"] = convertVal(int.tryParse(RTPeriod.text) ?? 0,
        RTPeriod.timeUnit ?? TimeUnit.second, TimeUnit.second);

    fieldVals["HTPeriod"] = convertVal(int.tryParse(HTPeriod.text) ?? 0,
        HTPeriod.timeUnit ?? TimeUnit.second, TimeUnit.second);

    fieldVals["HTInterval"] = convertVal(int.tryParse(HTInterval.text) ?? 0,
        HTInterval.timeUnit ?? TimeUnit.second, TimeUnit.second);

    fieldVals["HTThreshold"] = convertVal(int.tryParse(HTThreshold.text) ?? 0,
        HTThreshold.timeUnit ?? TimeUnit.second, TimeUnit.second);

    fieldVals["HTExtractInterval"] = convertVal(
        int.tryParse(HTExtractInterval.text) ?? 0,
        HTExtractInterval.timeUnit ?? TimeUnit.second,
        TimeUnit.second);

    return fieldVals;
  }
}

 
