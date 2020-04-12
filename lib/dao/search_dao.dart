import 'dart:convert';

import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;


const URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

///搜索接口
class SearchDao {
  static Future<SearchModel> fetch(String keyword) async {
    String url=URL+keyword;
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); // fix 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      //只有当当前输入的内容和服务端返回的内容一致时才渲染
      SearchModel model=SearchModel.fromJson(result);
      model.keyWord=keyword;
      return model;
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}