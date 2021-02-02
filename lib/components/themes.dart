import 'package:flutter/material.dart';
import 'package:shoppingapp/constants.dart';
Color primary = Colors.white;
Color divider = Colors.grey.shade400;
Color active = Colors.blueAccent;
Color selected = Colors.lightBlueAccent;
final TextStyle subStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w300);
final TextStyle subStyle1 = TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: kPrimaryColor);
final TextStyle headStyle = TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white);
final TextStyle headStyle1 = TextStyle(fontSize: 22,fontWeight: FontWeight.bold);
final TextStyle style1 = TextStyle(fontSize: 14,fontWeight: FontWeight.w300,color: Colors.white);
final TextStyle style2 = TextStyle(fontSize: 16,fontWeight: FontWeight.bold);
final TextStyle style3 = TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white);
AppBar appBar = AppBar(
  title: Text(
    'Magenta',
    style: headStyle,
  ),
);
AppBar appBar1(BuildContext context){
  return AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      iconSize: 25,
      onPressed: (){
        Navigator.pop(context);
      },
    ),
    title: Text(
      'Magenta',
      style: headStyle,
    ),
    elevation: 0,
  );
}