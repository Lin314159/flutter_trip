import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/search_bar.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
const String SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';
///搜索
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String hint;
  final String keyWord;

  const SearchPage(
      {Key key,
      this.hideLeft = false,
      this.searchUrl,
      this.keyWord,
      this.hint=SEARCH_BAR_DEFAULT_TEXT})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  void initState() {
    if (widget.keyWord != null) {
      _onTextChang(widget.keyWord);
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        context: context,
        child: Column(
          children: <Widget>[
            _appBar,
            MediaQuery.removePadding(
              context: context,
              child: Expanded(
                child: ListView.builder(
                    itemCount: searchModel?.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int position) {
                      return _item(position);
                    }),
                flex: 1,
              ),
              removeTop: true,
            )
          ],
        ),
      ),
    );
  }

  Widget get _appBar {

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              //AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: keyword,
              hint: widget.hint,
              speakClick: _jumpToSpeak,
              leftButtonClick: () {
                NavigatorUtil.pop(context);
              },
              onChanged: _onTextChang,
            ),
          ),
        ),
        Container(
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }

  _jumpToSpeak() {
    NavigatorUtil.jumpTo(context, SpeakPage());
  }

  _onTextChang(String text) {
    keyword = text;
    if (keyword.length < 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    SearchDao.fetch(keyword).then((SearchModel model) {
      if (model.keyWord == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print('_onTextChang:' + e.toString() + "--keyword:$keyword");
    });
  }

  Widget _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 3, right: 5),
                  child: Image.asset(
                    _typeImage(item.type),
                    width: 26,
                    height: 26,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft, child: _title(item)),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 5),
                      child: _subTitle(item)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _typeImage(String type) {
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'assets/images/type_$path.png';
  }

  _title(SearchItem item) {
    if (item == null) return null;
    return Row(
      children: <Widget>[
        LimitedBox(
          maxWidth: 200,
          child: RichText(
            maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  text: item.word,
                  style: TextStyle(color: Colors.black87, fontSize: 16,),
                  children: <TextSpan>[
                TextSpan(
                    text: keyword,
                    style: TextStyle(fontSize: 16, color: Colors.amber)),
              ])),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(
            item.districtname ?? '',
            style: TextStyle(color: Colors.black26, fontSize: 15),
          ),
        ),
        Text(
          item.zonename ?? '',
          style: TextStyle(color: Colors.black26, fontSize: 15),
        )
      ],
    );
  }

  _subTitle(SearchItem item) {
    if (item == null) return null;
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Text(
            item.price ?? '',
            style: TextStyle(color: Colors.amber, fontSize: 16),
          ),
        ),
        Text(
          item.type ?? '',
          style: TextStyle(color: Colors.black26, fontSize: 15),
        ),
      ],
    );
  }
}
