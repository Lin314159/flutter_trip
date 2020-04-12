import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:flutter_trip/widget/travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel tabModel;
  double topPadding = 0;

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    _loadTravelTab();
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body:  MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Column(
          children: <Widget>[
            _tab(),
            _tabBarView(),
          ],
        ),
      ),
    );
  }

  /// 获取旅拍类别
  _loadTravelTab() {
    TravelTabDao.fetch().then((TravelTabModel model) {
      _controller = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        tabModel = model;
      });
    }).catchError((e) {
      print('_loadTravelTab:' + e.toString());
    });
  }

  /// 创建顶部tab
  _tab() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: TabBar(
            controller: _controller,
            isScrollable: true,
            labelColor: Colors.black,
            labelPadding: EdgeInsets.fromLTRB(10, 0,10, 0),
            indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
                insets: EdgeInsets.only(bottom: 5,top: 0)),
            tabs: tabs.map<Tab>((TravelTab tab) {
              return Tab(text: tab.labelName);
            }).toList()),
      ),
    );
  }

  _tabBarView() {
    return Flexible(
      child: TabBarView(
        controller: _controller,
        children: tabs.map((TravelTab tab){
          return TravelTabPage(travleUrl: tabModel.url,groupChannelCode: tab.groupChannelCode,);
        }).toList(),
      ),
    );
  }
}
