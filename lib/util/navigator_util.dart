
import 'package:flutter/material.dart';

class NavigatorUtil{

  static jumpTo(BuildContext context,Widget page){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
  }

  static pop(BuildContext context){
    Navigator.pop(context);
  }
}