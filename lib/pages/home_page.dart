import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/city_page.dart';
import 'package:flutter_trip/pages/serch_page.dart';
import 'package:flutter_trip/pages/speak_page.dart';
import 'package:flutter_trip/util/image_util.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/grid_nav.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/local_nav.dart';
import 'package:flutter_trip/widget/sales_box.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/sub_nav.dart';
import 'package:flutter_trip/widget/web_view.dart';

const int APPBAR_SCROLL_OFFSET = 100;
const String SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

///首页
class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List<CommonModel> bannerList = [];
  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  GridNavModel gridNav;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBoxModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        bannerList = model.bannerList;
        gridNav = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        _loading = false;
        //showLoad = json.encode(homeModel);
      });
    } catch (e) {
      print('${e.toString()}');
      _loading = false;
    }
    return null;
  }

  _onScroll(double pixels) {
    double alpha = pixels / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    }
    if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    //print(appBarAlpha);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
            isLoading: _loading,
            child: Stack(
              children: <Widget>[
                MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: RefreshIndicator(
                        child: NotificationListener(
                          // ignore: missing_return
                          onNotification: (scrollNotification) {
                            if (scrollNotification
                                    is ScrollUpdateNotification &&
                                scrollNotification.depth == 0) {
                              _onScroll(scrollNotification.metrics.pixels);
                            }
                          },
                          child: _listView,
                        ),
                        onRefresh: _handleRefresh)),
                _appBar
              ],
            )));
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.only(left: 7, right: 7, top: 4, bottom: 4),
          child: LocalNav(localNavList: localNavList),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: GridNav(
            gridNavModel: gridNav,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7, top: 4, bottom: 4),
          child: SubNav(
            subNavList: subNavList,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 7, right: 7),
          child: SalesBox(salesBoxModel: salesBoxModel),
        ),
      ],
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
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            decoration: BoxDecoration(
              color: Color.fromARGB((appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {
                _jumpToCity();
              },
            ),
          ),
        ),
        Container(
            height: appBarAlpha > 0.2 ? 0.5 : 0,
            decoration: BoxDecoration(
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]))
      ],
    );
  }

  Widget get _banner {
    return Container(
      height: 180,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              CommonModel model = bannerList[index];
              NavigatorUtil.jumpTo(
                  context,
                  WebView(
                    url: model.url,
                    title: model.title,
                    hideAppBar: model.hideAppBar,
                  ));
            },
            child:
            CachedNetworkImage(
              imageUrl: bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  _jumpToSearch() {
    NavigatorUtil.jumpTo(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
        ));
  }

  _jumpToSpeak() {
    NavigatorUtil.jumpTo(context, SpeakPage());
  }

  @override
  bool get wantKeepAlive => true;

  _jumpToCity() {
    NavigatorUtil.jumpTo(context, CityList());
  }
}
