import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FukuroDialog extends StatelessWidget {
  //static dialog type
  static int SUCCESS = 0;
  static int ERROR = 1;
  static int WARNING = 2;
  static int INFO = 3;
  static int QUESTION = 4;
  final TextEditingController _txtCont = TextEditingController();

  String getInputText() {
    return _txtCont.text;
  }

  final String title;
  String message;
  final int mode;
  bool NoBtn;
  String CancelBtnText;
  String BtnText;
  bool textInput;
  String inputHint;
  bool okpressed = false;
  final Function? okAction;
  FukuroDialog(
      {super.key,
      required this.title,
      required this.mode,
      this.message = "",
      this.okAction,
      this.NoBtn = false,
      this.textInput = false,
      this.inputHint = "",
      this.CancelBtnText = "Cancel",
      this.BtnText = "Ok"});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withOpacity(0.2),
      child: CupertinoAlertDialog(
        title: Column(
          children: [
            if (mode == FukuroDialog.SUCCESS)
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 70,
              ),
            if (mode == FukuroDialog.WARNING)
              const Icon(
                Icons.error_outline_rounded,
                color: Colors.orange,
                size: 70,
              ),
            if (mode == FukuroDialog.ERROR)
              const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
                size: 70,
              ),
            if (mode == FukuroDialog.INFO)
              const Icon(
                Icons.info_outline,
                color: Colors.grey,
                size: 70,
              ),
            if (mode == FukuroDialog.QUESTION)
              const Icon(
                CupertinoIcons.question_circle,
                color: Colors.grey,
                size: 70,
              ),
            Text(title)
          ],
        ),
        content: Column(
          children: [
            Text(message),
            if (textInput)
              TextFormField(
                controller: _txtCont,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: inputHint,
                ),
              )
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    BtnText,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  okpressed = true;
                  extraOkAction();
                }),
          ),
          if (NoBtn)
            CupertinoDialogAction(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      CancelBtnText,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
        ],
      ),
    );
  }

  static warning(context, title, message) {
    showDialog(
        context: context,
        builder: (_) => FukuroDialog(
              title: title,
              message: message,
              mode: FukuroDialog.WARNING,
            ));
  }

  static error(context, title, message) {
    showDialog(
        context: context,
        builder: (_) => FukuroDialog(
              title: title,
              message: message,
              mode: FukuroDialog.ERROR,
            ));
  }

  static info(context, title, message) {
    showDialog(
        context: context,
        builder: (_) => FukuroDialog(
              title: title,
              message: message,
              mode: FukuroDialog.INFO,
            ));
  }
  
  static success(context, title, message) {
    showDialog(
        context: context,
        builder: (_) => FukuroDialog(
              title: title,
              message: message,
              mode: FukuroDialog.SUCCESS,
            ));
  }

  extraOkAction() {
    if (okAction != null) {
      okAction!();
    }
  }
}
