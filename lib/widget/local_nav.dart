import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/web_view.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({Key key, @required this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (localNavList == null) {
      return null;
    } else {
      List<Widget> items = [];
      localNavList.forEach((model) {
        items.add(_item(context, model));
      });
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items,
      );
    }
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.jumpTo(
            context,
            WebView(
              url: model.url,
              hideAppBar: model.hideAppBar,
              statusBarColor: model.statusBarColor,
            ));
      },
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: model.icon,
            width: 32,
            height: 32,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
