import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SearchBarType { home, homeLight, normal }

class SearchBar extends StatefulWidget {
  final bool enabled; //是否禁止搜索
  final bool hideLeft; //是否隐藏左边按钮
  final SearchBarType searchBarType;
  final String hint; //默认提示文案
  final String defaultText;
  final void Function() leftButtonClick; //左边按钮点击回调
  final void Function() rightButtonClick; //右边按钮点击回调
  final void Function() speakClick; //语音按钮点击回调
  final void Function() inputBoxClick; //输入框点击回调
  final ValueChanged<String> onChanged; //内容变化回调

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;
  TextEditingController _controller = TextEditingController();
  double topPadding;

  @override
  void initState() {
    setState(() {
      if (widget.defaultText != null) {
        _controller.text = widget.defaultText;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   topPadding = MediaQuery.of(context).padding.top;
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  _genNormalSearch() {
    return Container(
      padding: EdgeInsets.only(top: topPadding+1,bottom: 5),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _warpTap(
              Container(
                margin: EdgeInsets.only(left: 5,right: 5),
                child: widget.hideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 25,
                      ),
              ),
              widget.leftButtonClick),
          Expanded(
            child: _inputBox(),
            flex: 1,
          ),
          _warpTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Text(
                  '搜索',
                  style: TextStyle(color: Colors.blue, fontSize: 17),
                ),
              ),
              widget.rightButtonClick),
        ],
      ),
    );
  }

  _genHomeSearch() {
    return Container(
      //color: widget.searchBarType==SearchBarType.home? Colors.transparent:Colors.white,
      padding: EdgeInsets.only(top: topPadding+1,bottom: 5),
      child: Row(children: <Widget>[
        _warpTap(
            Container(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      '上海',
                      style: TextStyle(color: _homeFontColor(), fontSize: 14),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: _homeFontColor(),
                      size: 22,
                    )
                  ],
                )),
            widget.leftButtonClick),
        Expanded(
          flex: 1,
          child: _inputBox(),
        ),
        _warpTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Icon(
                Icons.comment,
                color: _homeFontColor(),
                size: 25,
              ),
            ),
            widget.rightButtonClick)
      ]),
    );
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
  _warpTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }

    return Container(
      height: 30,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 10 : 15)),
      child: Container(

        child: Row(
          children: <Widget>[
            Icon(
              Icons.search,
              size: 20,
              color: widget.searchBarType == SearchBarType.normal
                  ? Color(0xffA9A9A9)
                  : Colors.blue,
            ),
            Expanded(
              flex: 1,
              child: widget.searchBarType == SearchBarType.normal
                  ? Container(
                    child: TextField(
                        controller: _controller,
                        onChanged: _onChanged,
                        autofocus: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,

                        ),
                        decoration: InputDecoration(
                            contentPadding:
                            //flutter sdk >= v1.12.1 输入框样式适配
                            EdgeInsets.only(left: 5, bottom: 11, right: 5),
                            border: InputBorder.none,
                            hintText: widget.hint ?? '',
                            hintStyle: TextStyle(fontSize: 12)),
                      ),
                  )
                  : _warpTap(
                      Container(
                        child: Text(
                          widget.defaultText,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      widget.inputBoxClick),
            ),
            !showClear
                ? _warpTap(
                    Icon(
                      Icons.mic,
                      size: 22,
                      color: widget.searchBarType == SearchBarType.normal
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    widget.speakClick)
                : _warpTap(
                    Icon(
                      Icons.clear,
                      size: 22,
                      color: widget.searchBarType == SearchBarType.normal
                          ? Colors.blue
                          : Colors.grey,
                    ), () {
                    setState(() {
                      _controller.clear();
                    });
                    _onChanged('');
                  }),
          ],
        ),
      ),
    );
  }

  _onChanged(String text) {
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }
}
