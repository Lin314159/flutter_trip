import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trip/pages/serch_page.dart';
import 'package:flutter_trip/plugin/asr_manager.dart';
import 'package:flutter_trip/util/navigator_util.dart';

class SpeakPage extends StatefulWidget {
  @override
  _SpeakPageState createState() => _SpeakPageState();
}

class _SpeakPageState extends State<SpeakPage>
    with SingleTickerProviderStateMixin {
  String speakTips = "长按说话";
  String speakResult = "";
  Animation animation;
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          controller.reverse();
        } else if (state == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _topItem(),
                _bottomItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _bottomItem() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (e) {
              _speakStar();
            },
            onTapUp: (e) {
              _speakStop();
            },
            onTapCancel: () {
              _speakStop();
            },
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      speakTips,
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Container(
                        height: MIC_SIZE,
                        width: MIC_SIZE,
                      ),
                      Center(
                        child: AnimatedMic(
                          animation: animation,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: () {
                NavigatorUtil.pop(context);
              },
              child: Icon(
                Icons.close,
                size: 30,
                color: Colors.grey,
              ),
            ),
            right: 10,
            bottom: 30,
          ),
        ],
      ),
    );
  }

  _speakStar() {
    controller.forward();
    setState(() {
      speakTips = '- 识别中 -';
    });
    AsrManager.start().then((text) {
      if (text != null && text.length > 0) {
        setState(() {
          speakResult = text;
        });
        print('_speakStar:' + speakResult);
        NavigatorUtil.pop(context);
        NavigatorUtil.jumpTo(
            context,
            SearchPage(
              keyWord: speakResult,
            ));
      }
    }).catchError((e) {
      print("_speakStar:" + e.toString());
    });
  }

  _speakStop() {
    setState(() {
      controller.reset();
      controller.stop();
      speakTips = '长按说话';
    });
    AsrManager.stop();
  }

  _topItem() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Text(
            '你可以这样说',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        Text(
          '故宫门票\n北京一日游\n迪士尼乐园',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black26,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            speakResult,
            style: TextStyle(fontSize: 16, color: Colors.blue),
          ),
        )
      ],
    );
  }
}

const double MIC_SIZE = 100;

class AnimatedMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween = Tween<double>(begin: MIC_SIZE, end: MIC_SIZE - 20);

  AnimatedMic({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    // TODO: implement build
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      child: Container(
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(MIC_SIZE / 2)),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
