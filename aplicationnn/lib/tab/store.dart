import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:aplicationnn/screens/product/product_all.dart';
import 'package:aplicationnn/screens/product/product_deall.dart';
import 'package:aplicationnn/services/categoryService.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../id.dart';
import '../screens/profil/profil.dart';
import 'package:http/http.dart' as http;

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCategoryLoading = false,
      isProductLoading = false,
      addProductTocart = false;
  List? categoryList, productList, buyProductList;

  @override
  void initState() {
    getCategoryData();
    getProduct();
    super.initState();
  }

  getCategoryData() async {
    await CategoryService.getCategory().then((onValue) {
      if (mounted) {
        setState(() {
          categoryList = onValue['content'];
          print("+++++++++++++++++++");
          print(categoryList);
          isCategoryLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATAAAAAAAA");
          isCategoryLoading = false;
        });
      }
    });
  }

  getProduct() async {
    await ProductService.getFollowingProduct().then((onValue) {
      if (mounted) {
        setState(() {
          productList = onValue['content'];
          print("+++++++++++++++++++");
          print(productList);
          isProductLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATAAAAAAAA");
          isProductLoading = false;
        });
      }
    });
  }

  orderProduct(BuildContext context, index) async {
    if (mounted) {
      setState(() {
        addProductTocart = true;
      });
    }

    Map buyNowProduct = {
      "products": {"productId": index['id']},
      "deliveryInstruction": "tsk"
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.post(Uri.parse(Id  + "/rest/order-create"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + tokenn!,
        },
        body: jsonEncode(buyNowProduct));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showMessageInScaffold(AppLocalizations.of(context)!.buyProduct);
    } else if (res.statusCode == 400) {
      showMessageInScaffold(
          AppLocalizations.of(context)!.youCannoBuyYourOwnProduct);
    } else if (res.statusCode == 404) {
      showMessageInScaffold(
          AppLocalizations.of(context)!.theProductIsOutOfStock);
    } else if (res.statusCode == 417) {
      showMessageInScaffold(
          AppLocalizations.of(context)!.youCanOnlyGetOneItemPerDay);
    } else {
      showMessageInScaffold(AppLocalizations.of(context)!.error);
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

  void showSnackbar2(message) {
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
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return categoryList == null || productList == null
        ? const Center(child: CircularProgressIndicator())
        : WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              backgroundColor: Color(0xff030116),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xff030116),
                toolbarHeight: 100,
                title: Container(
                  height: 100,
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
                          child: Text(
                            AppLocalizations.of(context)!.hanging,
                          ),
                        )
                      ]),
                ),
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Color(0xff030116)),
                child: ListView(
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Color(0xff030116)),
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(3),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductAll(
                                          categoryId: categoryList![index]
                                              ['id'])));
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: CircleAvatar(
                                  radius: 35.0,
                                  backgroundImage: NetworkImage(
                                    categoryList![index]["imageUrl"],
                                  ),
                                  backgroundColor: Colors.transparent,
                                )),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: productList!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(3.0),
                                                    child: InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UseProfil(
                                                                            companyId:
                                                                                productList![index]['companyId'],
                                                                          )));
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 20,
                                                          child: ClipOval(
                                                            child: productList![
                                                                            index]
                                                                        [
                                                                        'companyImageUrl'] ==
                                                                    null
                                                                ? Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
                                                                      image:
                                                                          AssetImage(
                                                                        'assets/askida.png',
                                                                      ),
                                                                    )),
                                                                  )
                                                                : Image.network(
                                                                    productList![
                                                                            index]
                                                                        [
                                                                        'companyImageUrl'],
                                                                    fit: BoxFit
                                                                        .cover),
                                                          ),
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child:  FittedBox(
                                                         fit: BoxFit.scaleDown,
                                                        child: AutoSizeText(
                                                          productList![index]
                                                              ["companyName"],
                                                          style: TextStyle(
                                                            color: Color(0xffffffff),
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 17
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  
                                                ],
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ProductDeal(
                                                        productID: productList![index]
                                                            ['id'],
                                                      )));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(40),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      productList![index]
                                                          ['imageUrl']),
                                                  fit: BoxFit.cover)),
                                          height: 180,
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 15, bottom: 10),
                                                child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.all(1.0),
                                                        child: IconButton(
                                                            icon: Icon(
                                                              Icons.download,
                                                              color:
                                                                  Color(0xffffffff),
                                                            ),
                                                            onPressed: () {
                                                              orderProduct(
                                                                  context,
                                                                  productList![
                                                                      index]);
                                                            }),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.all(5),
                                                        margin: EdgeInsets.all(1),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10),
                                                            color: Color(0xffffffff)),
                                                        child: FittedBox(
                                                           fit: BoxFit.scaleDown,
                                                          child: AutoSizeText(
                                                            maxLines: 2,
                                                            productList![index]
                                                                        ["productStock"]
                                                                    .toString() +
                                                                '  ' +
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .piece,
                                                            style: TextStyle(
                                                              fontSize: 17,
                                                              color: Color(0xff2b2e83),
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
