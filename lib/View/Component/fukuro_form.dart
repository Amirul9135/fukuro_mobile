 
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

  final Map<String, Map<dynamic, dynamic>> fields;

  const FukuroForm({Key? key, required this.fields}) : super(key: key);

  @override
  FukuroFormState createState() => FukuroFormState();
}

class FukuroFormState extends State<FukuroForm> {
  final _formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    // Initialize your state here
    super.initState();
  }
  @override
  Widget build(BuildContext context) { 
    return Form(
      key: _formKey,
      child: Column(
        children: widget.fields.entries.map((entry) {

          // final String key = entry.key;
          final fieldConfig = entry.value;
          final displayName = fieldConfig['fieldName'] ?? '';
          final error = fieldConfig['error'] ?? 'Invalid $displayName';
          if( fieldConfig['controller'] == null ){
             fieldConfig['controller'] = FukuroEditorController();
          }     
          // final value = fieldConfig['value'];         

          if ((fieldConfig['isTimeUnit'] ?? false)  && fieldConfig['controller'].timeUnit == null) {
            fieldConfig['controller'].timeUnit = TimeUnit.second;
          } 
          if(fieldConfig['refresh'] != null){ 
            
           fieldConfig['controller'].text = (fieldConfig['value']??'').toString();
           fieldConfig['refresh'] = null;

          }
          if(fieldConfig['focus'] == null){
            fieldConfig['focus'] = FocusNode();
            fieldConfig['focus'].addListener((){
              if(mounted){
                setState(() {
                  
                });

              }
            });
          }

          final isDate = ((fieldConfig['type']??0 )== FukuroForm.inputDate ||
              (fieldConfig['type']??0)  == FukuroForm.inputDateTime);
        
          String dtFormat = isDate ? "yyyy-MM-dd HH:mm" : "HH:mm";
          dtFormat = fieldConfig['dtFormat'] ?? dtFormat;

          DateTime? dtInit = fieldConfig['dtInit'];
          DateTime? dtMin = fieldConfig['dtMin'];
          return    Container(
            padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
            child: TextFormField( 
            focusNode: fieldConfig['focus'] ,
            readOnly:( fieldConfig['readOnly']  ?? false),
            controller: fieldConfig['controller'],
            onChanged: (evt) {
              setState(() {});
            },
            textAlign: (fieldConfig['rightAllign'] ?? false) ? TextAlign.right : TextAlign.left,
            keyboardType: _getInputType(fieldConfig['type']?? 0),
            inputFormatters: _genFormatter(fieldConfig),
            decoration: InputDecoration(
              labelText: ((){ 
                if((fieldConfig['prefix']??'').isNotEmpty && fieldConfig['controller'].text.isNotEmpty){
                  return '';
                }
                else if((fieldConfig['prefix']??'').isNotEmpty && fieldConfig['focus'].hasFocus){
                   return '';
                }
                return fieldConfig['fieldName']?? '';
              })(), 
              labelStyle: const TextStyle(fontSize: 18),
              hintText: fieldConfig['hint']??'',
              helperText:  fieldConfig['help'],
              prefixIcon: fieldConfig['icon'],
              suffix: (fieldConfig['isTimeUnit'] ?? false)
                  ? _timeUnitButton(fieldConfig)
                  : ((fieldConfig['suffix'] ??'').isNotEmpty)
                      ? Text(
                          (fieldConfig['suffix'] ?? ''),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 102, 150)),
                        )
                      : null,
              prefix: Container(
                padding: EdgeInsets.only(right: 1.w),
                child: Text(
                  ( fieldConfig['prefix']??''),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 102, 150)),
                ),
              ),
              border: const OutlineInputBorder(),
            ),
            onTap: isDate
                ? () => _selectDate(
                    context, (fieldConfig['type']??0), fieldConfig['controller'], dtFormat, dtInit, dtMin)
                : ((fieldConfig['type']??0 )== FukuroForm.inputTime)
                    ? () => _selectTime(context, fieldConfig['controller'], dtFormat)
                    : null,
            validator: (value) {
              if (fieldConfig['validator'] != null) {
                if (value != null && RegExp(fieldConfig['validator']).hasMatch(value)) {
                  return null;
                }
              }
              if ((fieldConfig['type']??0) == FukuroForm.inputNumerical) {
                int val = int.tryParse(value ?? '0') ?? 0;
                if (fieldConfig['numMax'] != null && fieldConfig['numMin'] != null) {
                  if (val <= fieldConfig['numMax'] && val >= fieldConfig['numMin']) {
                    return null;
                  }
                } else {
                  if (fieldConfig['numMax'] != null && val <= fieldConfig['numMax']) {
                    return null;
                  } else if (fieldConfig['numMin'] != null && val >= fieldConfig['numMin']) {
                    return null;
                  }
                  if (fieldConfig['numMax'] == null && fieldConfig['numMin'] == null) {
                    return null;
                  }
                }
              } 
              else {
                int val = value?.length ?? 0;
                if (fieldConfig['lengthMax'] != null || fieldConfig['lengthMin'] != null) {
                  if (val <= fieldConfig['lengthMax'] && val >= fieldConfig['lengthMin']) {
                    return null;
                  } else if (fieldConfig['lengthMax'] != null && val <= fieldConfig['lengthMax']) {
                    return null;
                  } else if (fieldConfig['lengthMin'] != null && val >= fieldConfig['lengthMin']) {
                    return null;
                  }
                } else {
                  return null;
                }
              }

              return error + '  ';
            },
          ),);
        }).toList(),
      ),
    );
  }

  void toggleLockAll(lock) {
    widget.fields.forEach((key, value) {
      value['readOnly'] = lock;
    });
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

  _timeUnitButton(fieldConfig) {
    return PopupMenuButton<TimeUnit>(
      initialValue: fieldConfig['controller'].timeUnit ?? TimeUnit.second,
      child: Text(
        timeUnitNAme(fieldConfig['controller'].timeUnit ?? TimeUnit.second),
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 102, 150)),
      ),
      onSelected: (unit) {
        //always save in second  
        int tmpval = convertVal(int.tryParse(fieldConfig['controller'].text)?? 0,
                  fieldConfig['controller'].timeUnit ?? TimeUnit.second, unit);
        if (tmpval != 0 ){ 
          //display selected unit
          fieldConfig['controller'].text =  tmpval.toString();
          print('dlm fffor');
          print(fieldConfig);
          fieldConfig['value'] = convertVal(tmpval,unit,TimeUnit.second);
        } 
        fieldConfig['controller'].timeUnit = unit; 

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
  final TextEditingController? controller;
  final int type;
  final String? validator;
  final Icon? icon;
  final String? help;
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
  final bool? readOnly;
  final String? suffix;

  FukuroFormFieldBuilder(
      {required this.fieldName,
      this.controller,
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
      this.rightAllign,
      this.readOnly,
      this.help,
      this.suffix});

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
      'rightAllign': rightAllign,
      'readOnly': readOnly,
      'help': help,
      'suffix': suffix
    };
  }
}
