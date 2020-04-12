import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class WebView extends StatefulWidget {
  final String title;
  String url;
  final String statusBarColor;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {this.title='',
      this.url,
      this.statusBarColor,
      this.hideAppBar,
      this.backForbid = false}) {
    if (url != null && url.contains('ctrip.com')) {
      //fix 携程H5 http://无法打开问题
      url = url.replaceAll("http://", 'https://');
    }
  }

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {});
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          // TODO: Handle this case.
          break;
        case WebViewState.startLoad:
          // TODO: Handle this case.
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid) {
              flutterWebviewPlugin.launch(widget.url);
            } else {
              NavigatorUtil.pop(context);
              exiting = true;
            }
          }
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });
    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      print(error.toString());
    });
  }

  _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    super.dispose();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
              child: WebviewScaffold(
            url: widget.url,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(
                child: Text('Waiting....'),
              ),
            ),
          )),
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    double topPadding = MediaQuery.of(context).padding.top;
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: topPadding,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, 10),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: (){
                NavigatorUtil.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                  widget.title ?? '标题',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
