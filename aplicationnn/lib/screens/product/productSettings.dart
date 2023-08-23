import 'dart:convert';
import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/tab/myaskim.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/productService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductSettingScreen extends StatefulWidget {
  const ProductSettingScreen({super.key});

  @override
  State<ProductSettingScreen> createState() => _ProductSettingScreenState();
}

class _ProductSettingScreenState extends State<ProductSettingScreen> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isCategoryLoading = false, isProductList = false;
  List? categoryList, subCategoryList, productList;
  bool isSwitched = false;
  String url = "http://185.88.175.96:";

  get id => productList![selectedIndex!]['id'];

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    await ProductService.getCompanyIdProduct().then((onValue) {
      if (mounted) {
        setState(() {
          productList = onValue['content'];
          print("++++++ÜRÜNLERRTTTTTTTTTTT+++++++++++++");
          print(productList);
          isProductList = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATAAAAAAAA");
          isProductList = false;
        });
      }
    });
  }

  getStatus() async {
    Map<String, dynamic> body = {
      "status": isSwitched,
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.put(Uri.parse(url + "/rest/product-updateStatus/$id"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
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

  deleteProduct(index) async {
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

  void showMessageInScaffold(messagee) {
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

  showSnackbar(message) {
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
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeeScreen(
                                      currentIndex: 2,
                                    )));
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myProducts),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: productList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: productList!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(productList![index]),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.16,
                    children: [
                      SlidableAction(
                          icon: Icons.delete,
                          backgroundColor:
                              const Color.fromARGB(255, 100, 50, 240),
                          onPressed: (context) {
                            setState(() {
                              selectedIndex =
                                  productList!.indexOf(productList![index]);
                              deleteProduct(index);
                            });
                          })
                    ],
                  ),
                  child: Container(
                    height: 70,
                    child: ListTile(
                      leading: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(productList![index]['imageUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      title: Text(productList![index]['title']),
                      trailing: Switch(
                        onChanged: (bool value) {
                          setState(() {
                            if (value == false) {
                              selectedIndex =
                                  productList!.indexOf(productList![index]);
                              isSwitched = true;
                              getStatus();
                            } else {
                              selectedIndex =
                                  productList!.indexOf(productList![index]);
                              isSwitched = false;
                              getStatus();
                            }
                          });
                        },
                        value: productList![index]['status'] == false
                            ? isSwitched = false
                            : isSwitched = true,
                        activeTrackColor: Colors.green.shade700,
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
