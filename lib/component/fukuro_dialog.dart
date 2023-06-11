import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class FukuroDialog extends StatelessWidget {
  //static dialog type
  static int SUCCESS = 0;
  static int ERROR = 1;
  static int WARNING = 2;
  static int INFO = 3;
  static int QUESTION = 4;

  final String title;
  final String message;
  final int mode;
  final Function? okAction;
  const FukuroDialog(
      {super.key,
      required this.title,
      required this.message,
      required this.mode,
      this.okAction});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Column(
        
        children: [
          if(mode == FukuroDialog.SUCCESS)
          const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 70,
          ),
          if(mode == FukuroDialog.WARNING)
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.orange,
            size: 70,
          ),
          if(mode == FukuroDialog.ERROR)
          const Icon(
            Icons.cancel_outlined,
            color: Colors.red,
            size: 70,
          ),
          if(mode == FukuroDialog.INFO)
          const Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 70,
          ),
          if(mode == FukuroDialog.QUESTION)
          const Icon(
            CupertinoIcons.question_circle,
            color: Colors.grey,
            size: 70,
          ),
          
          Text(title)
        ],
      ),
      content: Text(message),
      actions: <Widget>[
        CupertinoDialogAction(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'OK',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () {
                 Navigator.pop(context); 
                 extraOkAction();
              }), 
        ),
      ],
    );
  }

  extraOkAction(){
    if(okAction != null){
      okAction!();
    }
  }
}
