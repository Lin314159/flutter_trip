import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/serch_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

const String SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

///导航
class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _avtiveColor = Colors.blue;
  int _currentIndex = 0;
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          SearchPage(
            hideLeft: true,
            hint: SEARCH_BAR_DEFAULT_TEXT,
          ),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            _bottomItem(Icons.home, '首页',0),
            _bottomItem(Icons.search, '搜索',1),
            _bottomItem(Icons.camera_alt, '旅拍',2),
            _bottomItem(Icons.account_circle, '我的',3),
          ]),
    );
  }

  _bottomItem(IconData icon, String title,int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _avtiveColor,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: _currentIndex == index ? _avtiveColor : _defaultColor),
        ));
  }
}
