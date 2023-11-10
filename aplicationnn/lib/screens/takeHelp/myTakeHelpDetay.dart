import 'package:aplicationnn/screens/chat/chat.dart';
import 'package:aplicationnn/screens/profil/profil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/productService.dart';

class MyTalkHelpDetay extends StatefulWidget {
  final String? orderID;
  const MyTalkHelpDetay({Key? key, this.orderID});

  @override
  State<MyTalkHelpDetay> createState() => _MyTalkHelpDetayState();
}

class _MyTalkHelpDetayState extends State<MyTalkHelpDetay> {
  var orderDetail;
  String? variantUnit, variantId, currency, description;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? groupValue = 0;
  bool? sizeSelect = false,
      getTokenValue = false,
      addProductTocart = false,
      isOrderDetails = false,
      isFavProductLoading = false,
      isProductAlredayInCart = false;
  int? quantity = 1, variantPrice, variantStock;
  var rating;

  @override
  void initState() {
    getOrderDetail();
    super.initState();
  }

  getOrderDetail() async {
    await ProductService.getMyTalkHelpDetay(widget.orderID).then((value) {
      if (mounted) {
        setState(() {
          orderDetail = value;
          isOrderDetails = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isOrderDetails = false;
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
                color: const Color.fromARGB(255, 230, 36, 102),
                child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.yes)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.grey.shade300,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.west,
                size: 30,
                color: Colors.black,
              ))),
      backgroundColor: Colors.grey.shade300,
      body: orderDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  orderDetail["products"]['imageUrl']))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
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
                                      orderDetail['products']['productName'],
                                      style: const TextStyle(fontSize: 20),
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
                            InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UseProfil(
                                                companyId:
                                                    orderDetail['companyId'],
                                              )));
                                },
                                child: ListTile(
                                    title: orderDetail!["user"]['firstName'] ==
                                            null
                                        ? const Text("meh")
                                        : Text(orderDetail!["user"]
                                                ['firstName'] +
                                            " " +
                                            orderDetail!["user"]['lastName']))),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                        chatId: orderDetail!["companyId"])));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.chat,
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
