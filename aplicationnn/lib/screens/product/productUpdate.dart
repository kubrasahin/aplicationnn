import 'dart:convert';
import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/screens/product/updatePhotoProduct.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../services/categoryService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../tab/myaskim.dart';

class ProductUpdate extends StatefulWidget {
  final String productId;
  const ProductUpdate({Key? key, required this.productId});

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  final _formKey = GlobalKey<FormState>();
  String? title, description, size, category, subcategory, stock;
  int? valcategory, selectedIndex;
  bool isProductLoading = false, isCategoryLoading = false;
  static var productDetail;
  List? categoryList, subCategoryList;
  int _selectedIndex = 0;
  String url = "http://185.88.175.96";

  get id => widget.productId;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
    getProductDetail();
  }

  getCategoryIdSubCategoryList() async {
    await CategoryService.getCategoryIdSubCategory(valcategory == 0
            ? categoryList![0]["id"]
            : categoryList![valcategory!]["id"])
        .then((onValue) {
      if (mounted) {
        setState(() {
          subCategoryList = onValue;
          print("SUBCATEGORY");
          print(subCategoryList);
        });
      }
    }).catchError((error) {
      print("HATAAAAA");
    });
  }

  getCategoryData() async {
    await CategoryService.getCategory().then((onValue) {
      if (mounted) {
        setState(() {
          categoryList = onValue['content'];
          print(categoryList);

          isCategoryLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCategoryLoading = false;
        });
      }
    });
  }

  getProductDetail() async {
    await ProductService.getProductDetails(widget.productId).then((value) {
      if (mounted) {
        setState(() {
          productDetail = value;
          print("productDetay");
          print(productDetail);
          isProductLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProductLoading = false;
        });
      }
    });
  }

  updateProduct() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "categoryId": categoryList![valcategory!]["id"].toString(),
        "subCategoryId": subCategoryList![_selectedIndex]["id"].toString(),
        "imageUrl": subCategoryList![_selectedIndex]["imageUrl"],
        "categoryName": categoryList![valcategory!]["title"],
        "subCategoryName": subCategoryList![_selectedIndex]["title"],
      };
      SharedPreferences basicAuth = await SharedPreferences.getInstance();
      String? basic = basicAuth.getString('basic');
      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var res = await http.put(Uri.parse(url + "/rest/product-update/$id"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept",
            'Authorization': 'Bearer' + tokenn!,
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      if (res.statusCode == 200) {
        showSnackbar(AppLocalizations.of(context)!.theProductHasBeenUpdated);
      } else {
        showSnackbar(AppLocalizations.of(context)!.errorOccurredOnUpdate);
      }
    }
  }

  void showSnackbar(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
            ),
            actions: <Widget>[
              Container(
                color: const Color.fromARGB(255, 230, 36, 102),
                child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeeScreen(
                                    currentIndex: 3,
                                  )));
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  deleteProduct() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.delete(
      Uri.parse(url + "/rest/product-delete/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + tokenn!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.deleteProduct);
    } else {
      showSnackbar(AppLocalizations.of(context)!.theProductCouldNotBeDeleted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030116),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff030116),
          title: Container(
            height: 80,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      'assets/askida.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Askıda"),
                  )
                ]),
          ),
        ),
      body: productDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff030116),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!.productUpdate,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextFormField(
                                style: TextStyle(color: Color(0xffffffff)),
                                key: Key(productDetail["title"]),
                                initialValue: productDetail["title"],
                                onSaved: (String? value) {
                                  title = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterProductName,
                                ),
                              ),
                            ),
                            const Divider( color: Color(0xffffffff),),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextFormField(
                                style:   TextStyle(color: Color(0xffffffff)),
                                key: Key(productDetail["description"]),
                                initialValue: productDetail["description"],
                                onSaved: (String? value) {
                                  description = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .descriptionProduct,
                                ),
                              ),
                            ),
                            const Divider( color: Color(0xffffffff),),
                           
                            const Divider(),
                            
                           const Divider( color: Color(0xffffffff),),
                            buildDropField(),
                            const Divider(),
                          ],
                        ),
                      )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          updateProduct();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Color(0xffef6328),),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.update,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteProduct();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Color(0xffef6328),),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductPhotoAdd(
                                        productId: widget.productId,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Color(0xffef6328),),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.photoAttachments,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  Widget buildDropField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                        itemCount: categoryList!.length,
                        itemBuilder: (context, i) {
                          return RadioListTile(
                            onChanged: (value) {
                              setState(() {
                                valcategory = value!;
                                getCategoryIdSubCategoryList();
                                Navigator.of(context).pop();
                              });
                            },
                            title: Text(categoryList![i]['title']),
                            groupValue: valcategory,
                            value: i,
                            activeColor:  Color(0xffef6328),
                          );
                        }),
                  );
                });
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color:  Color(0xffffffff),
                          width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(10),
                  child: valcategory == null
                      ? Text(AppLocalizations.of(context)!
                          .selectTheCategoryOfTheProduct, style: const TextStyle(
                              color: Color(0xffffffff), fontSize: 16),)
                      : Text(
                          categoryList![valcategory!]["title"], style: const TextStyle(
                              color: Color(0xffffffff), fontSize: 16),
                        ))),
        ),
        subCategoryList == null
            ? Container()
            : valcategory == null
                ? Container()
                : subCategoriWidget(),
      ],
    );
  }

  Widget subCategoriWidget() {
    return  SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: subCategoryList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => _onSelected(index),
                    child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex != null &&
                                    _selectedIndex == index
                                ? Color(0xffef6328)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(subCategoryList![index]["title"],style: TextStyle(   color: _selectedIndex != null &&
                                    _selectedIndex == index ?Color(0xffffffff):Colors.black),),
                        )),
                  ),
                );
              })
    );
  }
}
