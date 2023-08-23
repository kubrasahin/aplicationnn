import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static String url = "http://185.88.175.96:";
// Kullanıcı detayı
  static Future<Map<String, dynamic>> getUserDetay() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/user-detail"),
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

  //İd göre Kullanıcı Detayı
  static Future<Map<String, dynamic>> getIdUserDetay(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/user-detail/$id"),
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

  //Kullanıcı Kayıtı
  static Future signin(body) async {
    return http
        .post(Uri.parse(url + "/registration/user-create"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: json.encode(body))
        .then((response) {
      return json.decode(response.body);
    });
  }

// sifre Güncelleme
  static Future<Map<String, dynamic>> getSifreUpdatee() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/product-list"),
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

  // Kullanıcı Bilgileri Güncelleme
  static Future<Map<String, dynamic>> getUserUpdate() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/product-list"),
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

  // Cep Telefonu Güncelleme
  static Future<Map<String, dynamic>> getIphoneUpdate() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/product-list"),
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

  //Takipçi
  static Future<Map<String, dynamic>> getFollowerss() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/user-followers"),
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

  //TakipEdilen
  static Future<Map<String, dynamic>> getFollowinggs() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/user-followings"),
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

// Takip Etme
  static Future addFollowing(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.put(
      Uri.parse(url + "/rest/user-follow/$id"),
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

  // Takipten Çıkma
  static Future deleteFollowing(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.put(
      Uri.parse(url + "/rest/user-follow/$id"),
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

  // Takip Edilip edilmediğini
  static Future following(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/user-isFollowing/$id"),
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

  // Kayıtlı olan Statusu false olan kullanıcılar
  static Future getStatusFalseUser() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/user-listStatusFalse"),
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
