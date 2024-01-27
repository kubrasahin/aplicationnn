import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../id.dart';

class ProductService {
// bütün ürünleri listeleme
  static Future<Map<String, dynamic>> getProducts() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-list"),
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

// alt kategorileri sıralama
  static Future<Map<String, dynamic>> getSubCategory() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/category-list"),
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

// ürün ıdsine göre detay
  static Future<Map<String, dynamic>> getProductDetails(productId) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-detail/$productId"),
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

// tüm ürünleri listeleme
  static Future<Map<String, dynamic>> getSubCatgoriesProducts(
      categotId, subCategoryId) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id +
          "/rest/product-filter?categoryId=$categotId&subCategoryId=$subCategoryId"),
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

// Categori ıd göre ürün listeleme
  static Future<Map<String, dynamic>> getCategoriProducts(categoryId) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(
          Id + "/rest/product-filter?categoryId=$categoryId&subCategoryId="),
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

// ürün kaydetme
  static Future saveProduct(body) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.post(
      Uri.parse(Id + "/rest/product-create"),
      body: json.encode(body),
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

  // tüm ürüleri status
  static Future<Map<String, dynamic>> getCompanyIdProduct() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-getCompany"),
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

  // id göre ürüleri listeeme
  static Future<Map<String, dynamic>> getCompanyProduct(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-getCompany/$id"),
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

  //Statusu True olan ürünleri
  static Future<Map<String, dynamic>> getCompanyIdStatusProduct() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-companyStatusTrue"),
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

  // ürünü silme
  static Future deleteProduct(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.delete(
      Uri.parse(Id + "/rest/product-delete/$id"),
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

  // ürünü onaylama
  static Future approvalProduct(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.put(
      Uri.parse(Id + "/rest/product-updateStatus/$id"),
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

  // arama bölümü
  static Future<Map<String, dynamic>> searchProduct(text) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-search?keyWords=$text"),
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

  // Takip edilen kullanıcıların ürünleri
  static Future<Map<String, dynamic>> getFollowingProduct() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-getFollowCompany"),
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

  // ürün alma
  static Future<Map<String, dynamic>> addProductBuy(body) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.post(
      Uri.parse(Id + "/rest/order-create"),
      body: json.encode(body),
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

  // aldığım ürünlerin Listesi
  static Future<Map<String, dynamic>> getTake() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/order-userList"),
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

  // bagısladığım ürünlerin Listesi
  static Future<Map<String, dynamic>> getHelp() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/order-companyList"),
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

  // bagısladığım ürünlerin Listesi
  static Future<Map<String, dynamic>> getMyTalkHelpDetay(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/order-detail/$id"),
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

  // kurumsala gelen oonay listesi
  static Future<Map<String, dynamic>> getOnayProducts() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/product-companyStatusFalse"),
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
  // Sipariş Detay
  static Future<Map<String, dynamic>> getOrderDetay(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    return await http.get(
      Uri.parse(Id + "/rest/order-detail/$id"),
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
