import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trip/navigator/tab_navigator.dart';
import 'package:fluttertoast/fluttertoast.dart';

//void main() => runApp(MyApp());
void main() {
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _lastPressedAt; //上次点击时间
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'trip',
      home: WillPopScope(onWillPop: _onWillPop, child: TabNavigator()),
    );
  }

  ///两次返回推出APP
  Future<bool> _onWillPop() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
      Fluttertoast.showToast(
        fontSize: 12.0,
        msg: "再按一次退出程序",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
        textColor: Colors.black87,
        gravity: ToastGravity.CENTER,
      );
      //两次点击间隔超过1秒则重新计时
      _lastPressedAt = DateTime.now();
      return false;
    }
    return true;
  }
}
