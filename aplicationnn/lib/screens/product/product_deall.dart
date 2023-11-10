import 'dart:convert';

import 'package:aplicationnn/screens/profil/profil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../id.dart';
import '../../services/productService.dart';
import '../takeHelp/myTake.dart';
import 'package:http/http.dart' as http;

class ProductDeal extends StatefulWidget {
  final String? productID;
  const ProductDeal({Key? key, this.productID});

  @override
  State<ProductDeal> createState() => _ProductDealState();
}

class _ProductDealState extends State<ProductDeal> {
  var productDetail;

  String? variantUnit, variantId, currency, description;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? groupValue = 0;
  bool? sizeSelect = false,
      getTokenValue = false,
      addProductTocart = false,
      isProductDetails = false,
      isFavProductLoading = false,
      isProductAlredayInCart = false;
  int? quantity = 1, variantPrice, variantStock;
  var rating;

  @override
  void initState() {
    getProductDetail();
    super.initState();
  }

  orderProduct() async {
    if (mounted) {
      setState(() {
        addProductTocart = true;
      });
    }
    Map buyNowProduct = {
      "products": {"productId": widget.productID},
      "deliveryInstruction": "tsk"
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.post(Uri.parse(Id + "/rest/order-create"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + tokenn!,
        },
        body: jsonEncode(buyNowProduct));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
    showSnackbar("Ürünü Aldınız Kodunuz:2323232321");
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

  getProductDetail() async {
    await ProductService.getProductDetails(widget.productID).then((value) {
      if (mounted) {
        setState(() {
          productDetail = value;
          isProductDetails = true;
          print(productDetail);
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProductDetails = false;
        });
      }
    });
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
                decoration: BoxDecoration(
                    color: Color(0xffef6328),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        orderProduct();
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.yes)),
                ),
              )
            ],
          );
        });
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
    return Scaffold(
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
                  child: Text("Askıda"),
                )
              ]),
        ),
      ),
      body: productDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(fit: BoxFit.cover,
                              image: NetworkImage(productDetail['imageUrl'])),
                        ),
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        ),
                    Positioned(
                      bottom: -25,
                      left: 3,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UseProfil(
                                          companyId:
                                              productDetail['companyId'],
                                        )));
                          },
                          child: CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: productDetail['companyImageUrl'] == null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                        image: AssetImage(
                                          'assets/askida.png',
                                        ),
                                      )),
                                    )
                                  :Container(
    decoration: BoxDecoration(
    image: DecorationImage(fit: BoxFit.cover,
    image: NetworkImage(
    productDetail['companyImageUrl'],

    ),
    )),
    )
                            ),
                          )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0x49d9d9d9),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      productDetail['title'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 8),
                                      child: RatingBar.builder(
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        unratedColor: const Color.fromARGB(
                                            255, 243, 220, 12),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.grey,
                                          size: 12.0,
                                        ),
                                        onRatingUpdate: (value) {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15, left: 8, right: 8),
                              child: Text(productDetail['description'], style: const TextStyle(
                                  color: Colors.white, fontSize: 18),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15, left: 8, right: 8),
                              child: Row( mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(productDetail['productStock'].toString(), style: const TextStyle(
                                      color: Colors.white, fontSize: 18),),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Adet", style: const TextStyle(
                                        color: Colors.white, fontSize: 18),),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15, left: 8, right: 8),
                              child: Text(productDetail['companyName'], style: const TextStyle(
                                  color: Colors.white, fontSize: 18),),
                            ),


                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            showSnackbar(AppLocalizations.of(context)!
                                .doYouWantToBuyTheProductYou);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Color(0xffef6328),
                                  borderRadius: BorderRadius.circular(30)),
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.buyProduct,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
