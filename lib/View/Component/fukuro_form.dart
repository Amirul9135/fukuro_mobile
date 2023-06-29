import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fukuro_mobile/Controller/fukuro_editor_controller.dart';
import 'package:fukuro_mobile/Controller/input_max_num_formatter.dart';
import 'package:fukuro_mobile/Controller/utilities.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';

/* --CUSTOM DYNAMIC FORM CLASS FOR FUKURO--
this is for reference, it is recommended to use the builder class
the widget build forms based on provided hashmap of the fields
example of hashmap

Map<String, Map<String, dynamic>> formFields = {
  'field1name': {                             // the key part is currently unused in the form, only for accessing later
    'fieldName': 'Username',                  // this name will be used in display
    'controller': TextEditingController(),    // the controller object to trigger validation and access values
    'type': 'text',   use statics             // type currently either 'text' or 'number' determines the keyboard
    'validator':'test',                       // the regex to be used in validation
    'icon': Icon(Icons.percent),              // icon displayed in the prefix
    'value': '',                              // default value to be set on initializing the field
    'format': '',                             // regex for formatter
    'numMin' : 0,                             // the minimum value (only for input type number)
    'numMax' : 1,                             // the max value (only for input type number) ALSO used for formatter
    'lengthMin' : 0,                          // minimum length for non numerical input
    'lengthMax' : 1                           // max length for non numerical input ALSO used for formatter
    'dtFormat' : ''                           // use statics
    'dtInit': datetimeobject                  // selected date when picker is opened
    'dtMin':datetime object                   // minimum selectible date
    'prefix':text                             // displayed left of the field
    'isTimeUnit: bool                         // add button to change second minute day hour
  },
}
*/

class FukuroForm extends StatefulWidget {
  //static attributes
  static int inputText = 0;
  static int inputNumerical = 1;
  static int inputDateTime = 2;
  static int inputDate = 3;
  static int inputTime = 4;
  static String dfDMYDash = "dd-MM-yyyy";
  static String dfDMYSlash = "dd/MM/yyyy";
  static String tf24H = "HH:mm";
  static String tf12H = "hh:mm aa";

  final Map<String, Map<String, dynamic>> fields;

  const FukuroForm({Key? key, required this.fields}) : super(key: key);

  @override
  FukuroFormState createState() => FukuroFormState();
}

class FukuroFormState extends State<FukuroForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: widget.fields.entries.map((entry) {
          // final String key = entry.key;
          final fieldConfig = entry.value;
          final displayName = fieldConfig['fieldName'] ?? '';
          final FukuroEditorController controller =
              fieldConfig['controller'] ?? FukuroEditorController();
          final hintText = fieldConfig['hint'] ?? ' ';
          final help = fieldConfig['help'] ?? '';
          final type = fieldConfig['type'] ?? 0;
          final validator = fieldConfig['validator'];
          final icon = fieldConfig['icon'];
          // final value = fieldConfig['value'];
          final numMin = fieldConfig['numMin'];
          final numMax = fieldConfig['numMax'];
          final lengthMin = fieldConfig['lengthMin'];
          final lengthMax = fieldConfig['lengthMax'];
          final error = fieldConfig['error'] ?? 'Invalid $displayName';
          final String prefix = fieldConfig['prefix'] ?? '';
          final bool isTimeUnit = fieldConfig['isTimeUnit'] ?? false;
          final bool right = fieldConfig['rightAllign'] ?? false;
          if (isTimeUnit && controller.timeUnit == null) {
            controller.timeUnit = TimeUnit.second;
          }

          final isDate = (type == FukuroForm.inputDate ||
              type == FukuroForm.inputDateTime);
          String dtFormat = isDate ? "yyyy-MM-dd HH:mm" : "HH:mm";
          dtFormat = fieldConfig['dtFormat'] ?? dtFormat;
          DateTime? dtInit = fieldConfig['dtInit'];
          DateTime? dtMin = fieldConfig['dtMin'];

          return TextFormField(
            controller: controller,
            onChanged: (evt) {
              setState(() {});
            },
            textAlign: (right) ? TextAlign.right : TextAlign.left,
            keyboardType: _getInputType(type),
            inputFormatters: _genFormatter(fieldConfig),
            decoration: InputDecoration(
              labelText: (prefix.isNotEmpty && controller.text.isNotEmpty)
                  ? ''
                  : displayName,
              labelStyle: const TextStyle(fontSize: 18),
              hintText: hintText,
              helperText: help,
              prefixIcon: icon,
              suffix: (isTimeUnit)
                  ? _timeUnitButton(controller, fieldConfig)
                  : null,
              prefix: Container(
                padding: EdgeInsets.only(right: 1.w),
                child: Text(
                  prefix,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 102, 150)),
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            onTap: isDate
                ? () => _selectDate(
                    context, type, controller, dtFormat, dtInit, dtMin)
                : (type == FukuroForm.inputTime)
                    ? () => _selectTime(context, controller, dtFormat)
                    : null,
            validator: (value) {
              if (validator != null) {
                if (value != null && RegExp(validator).hasMatch(value)) {
                  return null;
                }
              }
              if (type == FukuroForm.inputNumerical) {
                int val = int.tryParse(value ?? '0') ?? 0;
                if (numMax != null && numMin != null) {
                  if (val <= numMax && val >= numMin) {
                    return null;
                  }
                } else {
                  if (numMax != null && val <= numMax) {
                    return null;
                  } else if (numMin != null && val >= numMin) {
                    return null;
                  }
                  if (numMax == null && numMin == null) {
                    return null;
                  }
                }
              } else {
                int val = value?.length ?? 0;
                if (lengthMax != null && lengthMin != null) {
                  if (val <= lengthMax && val >= lengthMin) {
                    return null;
                  } else if (lengthMax != null && val <= lengthMax) {
                    return null;
                  } else if (lengthMin != null && val >= lengthMin) {
                    return null;
                  }
                }
              }

              return error + '  ';
            },
          );
        }).toList(),
      ),
    );
  }

  bool validateForm() {
    print('dalam form');
    return _formKey.currentState?.validate() ?? false;
  }

  _getInputType(int type) {
    if (type == FukuroForm.inputText) {
      return TextInputType.text;
    }
    if (type == FukuroForm.inputNumerical) {
      return TextInputType.number;
    }
    if (type == FukuroForm.inputDateTime ||
        type == FukuroForm.inputDate ||
        type == FukuroForm.inputTime) {
      return TextInputType.none;
    }
  }

  _genFormatter(field) {
    List<TextInputFormatter> formats = [];
    if (field["lengthMax"] != null) {
      formats.add(LengthLimitingTextInputFormatter(field["lengthMax"]));
    }
    if (field["type"] == FukuroForm.inputNumerical && field["numMax"] != null) {
      formats.add(MaxNumValueTextInputFormatter(field["numMax"]));
    }
    if (field["format"] != null) {
      formats.add(FilteringTextInputFormatter.allow(RegExp(field["format"])));
    }
    return formats;
  }

  _selectTime(context, TextEditingController controller, format) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    FocusScope.of(context).requestFocus(FocusNode());

    if (selectedTime != null) {
      setState(() {
        controller.text = _formatTime(selectedTime, format);
      });
    }
  }

  _formatTime(time, format) {
    final now = DateTime.now();
    final tmpDt =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat(format).format(tmpDt);
  }

  _selectDate(context, int type, TextEditingController controller, dformat,
      DateTime? init, DateTime? first) async {
    final DateTime? picked = (type == FukuroForm.inputDate)
        ? await showDatePicker(
            context: context,
            firstDate: first ?? DateTime(2000),
            initialDate: init ?? DateTime.now(),
            lastDate: DateTime(2100))
        : await showOmniDateTimePicker(
            context: context,
            firstDate: first,
            initialDate: init ?? DateTime.now());

    FocusScope.of(context).requestFocus(FocusNode());

    if (picked != null) {
      setState(() {
        controller.text = DateFormat(dformat).format(picked);
      });
    }
  }

  _timeUnitButton(FukuroEditorController controller, fieldConfig) {
    return PopupMenuButton<TimeUnit>(
      initialValue: controller.timeUnit ?? TimeUnit.second,
      child: Text(
        timeUnitNAme(controller.timeUnit ?? TimeUnit.second),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 102, 150)),
      ),
      onSelected: (unit) {
        controller.text = convertVal(int.tryParse(controller.text) ?? 0,
                controller.timeUnit ?? TimeUnit.second, unit)
            .toString();
        controller.timeUnit = unit;

        setState(() {});
      },
      itemBuilder: (BuildContext context) {
        return const [
          PopupMenuItem(
            value: TimeUnit.second,
            child: Text('Seconds'),
          ),
          PopupMenuItem(
            value: TimeUnit.minute,
            child: Text('Minutes'),
          ),
          PopupMenuItem(
            value: TimeUnit.hour,
            child: Text('Hours'),
          ),
          PopupMenuItem(
            value: TimeUnit.day,
            child: Text('Days'),
          ),
        ];
      },
    );
  }
}

class FukuroFormFieldBuilder {
  final String fieldName;
  final TextEditingController controller;
  final int type;
  final String? validator;
  final Icon? icon;
  final String? prefix;
  final String? value;
  final String? format;
  final double? numMin;
  final double? numMax;
  final int? lengthMin;
  final int? lengthMax;
  final String? dtFormat;
  final DateTime? dtInit;
  final DateTime? dtMin;
  final bool? isTimeUnit;
  final bool? rightAllign;

  FukuroFormFieldBuilder(
      {required this.fieldName,
      required this.controller,
      required this.type,
      this.prefix,
      this.validator,
      this.icon,
      this.value,
      this.format,
      this.numMin,
      this.numMax,
      this.lengthMin,
      this.lengthMax,
      this.dtFormat,
      this.dtInit,
      this.dtMin,
      this.isTimeUnit,
      this.rightAllign});

  Map<String, dynamic> build() {
    return {
      'fieldName': fieldName,
      'controller': controller,
      'type': type,
      'prefix': prefix,
      'validator': validator,
      'icon': icon,
      'value': value,
      'format': format,
      'numMin': numMin,
      'numMax': numMax,
      'lengthMin': lengthMin,
      'lengthMax': lengthMax,
      'dtFormat': dtFormat,
      'isTimeUnit': isTimeUnit,
      'rightAllign': rightAllign
    };
  }
}
