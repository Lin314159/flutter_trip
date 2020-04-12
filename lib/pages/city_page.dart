import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpinyin/lpinyin.dart';

class CityList extends StatefulWidget {
  @override
  _CityListState createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  List<CityInfo> _cityList = List();

  //List<CityInfo> _hotCityList = List();

  int _suspensionHeight = 40;
  int _itemHeight = 50;
  String _suspensionTag = "A";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    //加载城市列表
    try {
      var value = await rootBundle.loadString('assets/data/cities.json');
      List list = json.decode(value);
      list.forEach((value) {
        _cityList.add(CityInfo(name: value['name']));
      });
      _handleList(_cityList);
      setState(() {
        _cityList = _cityList;
      });
    } catch (e) {
      print(e);
    }
  }

  void _handleList(List<CityInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = "#";
      }
    }
    //根据A-Z排序
    SuspensionUtil.sortListBySuspensionTag(_cityList);
  }

  //tag更改
  void _onSusTagChanged(String tag) {
    setState(() {
      _suspensionTag = tag;
    });
  }

  //自定义tag
  Widget _buildSusWidget(String susTag) {
    return Container(
      height: _suspensionHeight.toDouble(),
      padding: const EdgeInsets.only(left: 15.0),
      color: Color(0xfff3f4f5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$susTag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.red,
        ),
      ),
    );
  }

  //自定义item
  Widget _buildListItem(CityInfo model) {
    String susTag = model.getSuspensionTag();
    return Column(
      children: <Widget>[
        Offstage(
          offstage: model.isShowSuspension != true,
          child: _buildSusWidget(susTag),
        ),
        SizedBox(
          height: _itemHeight.toDouble(),
          child: ListTile(
            title: Text(model.name),
            onTap: () {
              print("OnItemClick: $model");
              Navigator.pop(context, model.name);
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('选择城市'),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 15.0),
              height: 50.0,
              child: Text("当前城市: 成都市"),
            ),
            Expanded(
                flex: 1,
                child: AzListView(
                  data: _cityList,
                  itemBuilder: (context, model) => _buildListItem(model),
                  suspensionWidget: _buildSusWidget(_suspensionTag),
                  isUseRealIndex: true,
                  itemHeight: _itemHeight,
                  suspensionHeight: _suspensionHeight,
                  onSusTagChanged: _onSusTagChanged,
                  //showIndexHint: true,
                )),
          ],
        ),
      ),
    );
  }
}

class CityInfo extends ISuspensionBean {
  String name;
  String tagIndex;
  String namePinyin;

  CityInfo({
    this.name,
    this.tagIndex,
    this.namePinyin,
  });

  CityInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] == null ? "" : json['name'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'tagIndex': tagIndex,
        'namePinyin': namePinyin,
        'isShowSuspension': isShowSuspension
      };

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() => "CityBean {" + " \"name\":\"" + name + "\"" + '}';
}
