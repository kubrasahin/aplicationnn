import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  static String url = "http://185.88.175.96:";
  static Future getCategory() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    print(token);
    return await http.get(
      Uri.parse(url + "/rest/category-list"),
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

//kategori Detay
  static Future getCategoryDetay(categoryId) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/category-detail/$categoryId"),
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

// tüm kategoriler statusu true false olan
  static Future<Map<String, dynamic>> getAllCategori() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/category-listAll"),
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

// Tüm alt Kategorileri Çekme
  static Future<Map<String, dynamic>> getAllSubCategori() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/subcategory-listAll"),
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

// alt Kategori detay
  static Future getSubCategoryDetay(subCategoryId) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/subcategory-detail/$subCategoryId"),
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

  static Future getCategoryIdSubCategory(categoryId) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(url + "/rest/subcategory-listByCategoryId/$categoryId"),
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
