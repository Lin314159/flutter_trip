import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_trip/dao/travel_dao.dart';
import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trip/util/image_util.dart';
import 'package:flutter_trip/util/navigator_util.dart';
import 'package:flutter_trip/widget/loading_container.dart';
import 'package:flutter_trip/widget/web_view.dart';

const PAGE_SIZ = 20;
const TRAVEL_URL =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

class TravelTabPage extends StatefulWidget {
  final String travleUrl;
  final String groupChannelCode;

  const TravelTabPage({Key key, this.groupChannelCode, this.travleUrl})
      : super(key: key);

  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage>
    with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = true;
  ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoadingContainer(
        isLoading: _loading,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: StaggeredGridView.countBuilder(
            controller: _scrollController,
            crossAxisCount: 2,
            itemCount: travelItems?.length ?? 0,
            itemBuilder: (BuildContext context, int index) => _TravelItem(
              index: index,
              item: travelItems[index],
            ),
            staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          ),
        ),
      ),
    );
  }

  _loadData({bool loadMore = false}) {
    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    TravelDao.fetch(widget.travleUrl ?? TRAVEL_URL, widget.groupChannelCode,
            pageIndex, PAGE_SIZ)
        .then((TravelModel model) {
      List<TravelItem> items = _filterItems(model.resultList);
      setState(() {
        _loading = false;
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
      });
      print('TravelTabPage' + e.toString());
    });
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) {
      return [];
    }
    List<TravelItem> filterItems = [];
    resultList.forEach((item) {
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  Future<Null> _handleRefresh() async {
    travelItems.clear();
    _loadData();
    return null;
  }
}

class _TravelItem extends StatelessWidget {
  final int index;
  final TravelItem item;

  const _TravelItem({Key key, this.index, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onTap: () {
        if (item.article.urls != null && item.article.urls.length > 0) {
          NavigatorUtil.jumpTo(
              context,
              WebView(
                url: item.article.urls[0].h5Url,
                title: '详情',
              ));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
              _infoText(),
            ],
          ),
        ),
      ),
    ));
  }

  _itemImage() {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          imageUrl: item.article.images[0]?.dynamicUrl,
        ),
        Positioned(
            left: 10,
            bottom: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
                  LimitedBox(
                    maxWidth: 130,
                    child: Text(
                      _poiName(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ))
      ],
    );
  }

  String _poiName() {
    return item.article.pois == null || item.article.pois.length == 0
        ? '未知'
        : item.article.pois[0]?.poiName ?? '未知';
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.article.author?.coverImage?.dynamicUrl,
                  width: 24,
                  height: 24,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                color: Colors.grey,
                size: 13,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Text(
                  item.article.likeCount.toString(),
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
