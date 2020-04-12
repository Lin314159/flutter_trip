import 'dart:convert';

import 'package:flutter_trip/model/travel_model.dart';
import 'package:flutter_trip/model/travel_tab_model.dart';
import 'package:http/http.dart' as http;

const TRAVEL_TAB_URL =
    'http://www.devio.org/io/flutter_app/json/travel_page.json';

///旅拍类别接口
class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(TRAVEL_TAB_URL);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('Failed to load TravelTabDao.json');
    }
  }
}

// ignore: non_constant_identifier_names
var Params = {
  "districtId": -1,
  "groupChannelCode": "RX-OMF",
  "type": null,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {'cid': "09031014111431397988"},
  "contentType": "json"
};

///旅拍页接口
class TravelDao {
  static Future<TravelModel> fetch(
      String url, String groupChannelCode, int pageIndex, int pageSize) async {
    Map paramsMap = Params['pagePara'];
    paramsMap['pageIndex'] = pageIndex;
    paramsMap['pageSize'] = pageSize;
    Params['groupChannelCode'] = groupChannelCode;

    final response = await http.post(url, body: jsonEncode(Params));
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelModel.fromJson(result);
    } else {
      throw Exception('Failed to load TravelDao.json');
    }
  }
}
