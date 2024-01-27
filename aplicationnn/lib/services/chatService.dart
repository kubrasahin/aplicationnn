import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../id.dart';

class ChatServices {

//Kullanıcıya Özel Gönderilen Mesajları Çekme
  static Future<Map<String, dynamic>> getSenderReciverChat(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id  + "/rest/user-getChat/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer' + tokenn!,
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    ).then((response) {
      return json.decode(utf8.decode(response.bodyBytes));
    });
  }

  //Kullanıcıya Özel Gönderilen Mesajları Çekme
  static Future<Map<String, dynamic>> getreciverChat(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id  + "/rest/user-receiver/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer' + tokenn!,
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    ).then((response) {
      return json.decode(utf8.decode(response.bodyBytes));
    });
  }

  // Tüm sohbetleri Çeken Path
  static Future getChatAll() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id  + "/rest/chats"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer' + tokenn!,
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    ).then((response) {
      return json.decode(utf8.decode(response.bodyBytes));
    });
  }

  //Tüm Bidirimleri Çekme
  static Future<Map<String, dynamic>> getNotifications() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id  + "/rest/notifications"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer' + tokenn!,
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    ).then((response) {
      return json.decode(utf8.decode(response.bodyBytes));
    });
  }

  //Bildirim Detay Çekme
  static Future getNotificationDetay(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id  + "/rest/notification-detail/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer' + tokenn!,
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    ).then((response) {
      return json.decode(utf8.decode(response.bodyBytes));
    });
  }
}
