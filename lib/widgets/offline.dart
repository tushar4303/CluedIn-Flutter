import 'package:flutter/material.dart';

Widget errmsg(String text, bool show) {
  //error message widget.
  if (show == true) {
    //if error is true then show error message box
    return Container(
      padding: EdgeInsets.all(10.00),
      margin: EdgeInsets.only(bottom: 10.00),
      color: Color.fromARGB(255, 1, 1, 1),
      child: Row(children: [
        Container(
          margin: EdgeInsets.only(right: 6.00),
          child: Icon(Icons.info, color: Colors.white),
        ), // icon for error message

        Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        //show error message text
      ]),
    );
  } else {
    return Container();
    //if error is false, return empty container.
  }
}
