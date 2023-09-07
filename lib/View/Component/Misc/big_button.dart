
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function? action;
  final dynamic value;

 const  BigButton({super.key, required this.icon, required this.label,this.action,this.value});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { 
        action?.call(value);
      },
      child: Container(
      decoration: BoxDecoration(
        color: Colors.blue, // Button background color
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FittedBox(
              fit: BoxFit.fill,
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
             label,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          )
        ],
      ),
    ),)  ;
  }
}
