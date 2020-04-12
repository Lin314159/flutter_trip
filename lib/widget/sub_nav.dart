import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/util/image_util.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/web_view.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }


  _items(BuildContext context) {
    if (subNavList == null) {
      return null;
    } else {
      List<Widget> items = [];
      subNavList.forEach((model) {
        items.add(_item(context, model));
      });
      int separate = (subNavList.length / 2).toInt();
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(0, separate),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: items.sublist(separate, items.length),
            ),
          ),
        ],
      );
    }
  }
    Widget _item(BuildContext context, CommonModel model) {
      return Expanded(
        child:  GestureDetector(
          onTap: () {
            NavigatorUtil.jumpTo(context, WebView(
              url: model.url,
              hideAppBar: model.hideAppBar,
              statusBarColor: model.statusBarColor,

            ));
          },
          child: Column(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl:model.icon,width: 18,height: 18 ,
              ),
              Padding(
                padding: const EdgeInsets.only(top :3.0),
                child: Text(
                  model.title,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
