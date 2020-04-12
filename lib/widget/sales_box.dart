import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/web_view.dart';

class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBoxModel;

  const SalesBox({Key key, @required this.salesBoxModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _items(context),
    );
  }

  _items(BuildContext context) {
    if (salesBoxModel == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(
        context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, true, false));
    items.add(_doubleItem(context, salesBoxModel.smallCard1,
        salesBoxModel.smallCard2, false, false));
    items.add(_doubleItem(context, salesBoxModel.smallCard3,
        salesBoxModel.smallCard4, false, true));

    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CachedNetworkImage(
                  imageUrl: salesBoxModel.icon, height: 15, fit: BoxFit.fill),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [
                          Color(0xffff4e63),
                          Color(0xffff6cc9),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: GestureDetector(
                  onTap: () {
                    NavigatorUtil.jumpTo(
                        context,
                        WebView(
                          url: salesBoxModel.moreUrl,
                        ));
                  },
                  child: Text(
                    '获取更多福利 >',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0, 1),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1, 2),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2, 3),
        )
      ],
    );
  }

  Widget _doubleItem(BuildContext context, CommonModel leftCard,
      CommonModel rightCard, bool big, bool last) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _item(context, leftCard, last, true, big),
        _item(context, rightCard, last, false, big)
      ],
    );
  }

  Widget _item(
      BuildContext context, CommonModel model, bool last, bool left, bool big) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Color(0xfff2f2f2));
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
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              right: left ? borderSide : BorderSide.none,
              bottom: last ? BorderSide.none : borderSide),
        ),
        child: CachedNetworkImage(
          imageUrl: model.icon,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width / 2 - 10,
          height: big ? 129 : 80,
        ),
      ),
    );
  }
}
