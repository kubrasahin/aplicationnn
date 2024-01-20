import 'dart:convert';

import 'package:aplicationnn/id.dart';
import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/screens/product/productAprovalDelete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/productService.dart';

class ApprovalProduct extends StatefulWidget {
  const ApprovalProduct({super.key});

  @override
  State<ApprovalProduct> createState() => _ApprovalProductState();
}

class _ApprovalProductState extends State<ApprovalProduct> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  TabController? tabcontroller;
  String? valueChoose, valueChoosee;
  int selectedIndex = 0, currentIndex = 0;
  bool isCategoryLoading = false, isProductList = false;
  List? productList;
  static var UserDetail;

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  getProducts() async {
    await ProductService.getOnayProducts().then((onValue) {
      if (mounted) {
        setState(() {
          productList = onValue['content'];
          print(productList);
          isProductList = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProductList = false;
        });
      }
    });
  }

  addProduct(id) async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.put(
      Uri.parse(Id + "/rest/product-updateStatus/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + tokenn!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showMessageInScaffoldTwo("Ürünü Askıladınız");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeeScreen(
                    currentIndex: 3,
                  )));
    } else {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.error);
    }
  }

  deleteProduct(id) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.delete(
      Uri.parse(Id + "/rest/product-delete/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + tokenn!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.deleteProduct);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeeScreen(
                    currentIndex: 3,
                  )));
    } else {
      showMessageInScaffoldTwo(
          AppLocalizations.of(context)!.theProductCouldNotBeDeleted);
    }
  }

  void showMessageInScaffoldTwo(messagee) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 6.0,
      backgroundColor: Color(0xffef6328),
      behavior: SnackBarBehavior.floating,
      content: Text(
        messagee,
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
          textColor: Color(0xffffffff),
          label: AppLocalizations.of(context)!.close,
          onPressed: () {}),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return productList != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 10,
              color: Color(0xff030116),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xff030116), width: 1),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: productList!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductApprovalDelete(
                                productId: productList![index]['id'],
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  productList![index]["imageUrl"] == null
                                      ? Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      "assets/askida.png"))),
                                        )
                                      : Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      productList![index]
                                                          ["imageUrl"]))),
                                        ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage: productList![index]
                                                      ["companyImageUrl"] ==
                                                  null
                                              ? NetworkImage("")
                                              : NetworkImage(productList![index]
                                                  ["companyImageUrl"]),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  addProduct(productList![index]
                                                      ['id']);
                                                },
                                                child: Text(
                                                  "Onayla",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  deleteProduct(
                                                      productList![index]
                                                          ['id']);
                                                },
                                                child: Text(
                                                  "Reddet",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      );
                    }),
              ),
            ),
          )
        : Container(
            child: Center(child: Text("Onay Bekleyen  Ürün Bulunmamaktadır")),
          );
  }
}
