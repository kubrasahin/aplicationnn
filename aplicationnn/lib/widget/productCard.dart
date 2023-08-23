import 'package:aplicationnn/services/productService.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/product/product_deall.dart';
import '../screens/profil/profil.dart';

class ProductCard extends StatefulWidget {
  final Map? productData;
  const ProductCard({
    Key? key,
    this.productData,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDeal(
                            productID: widget.productData!['id'],
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: NetworkImage(widget.productData!['imageUrl']),
                      fit: BoxFit.cover)),
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UseProfil(
                                                companyId: widget
                                                    .productData!['companyId'],
                                              )));
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  child: ClipOval(
                                    child: widget.productData![
                                                'companyImageUrl'] ==
                                            null
                                        ? Container()
                                        : Image.network(
                                            widget.productData![
                                                'companyImageUrl'],
                                            fit: BoxFit.cover),
                                  ),
                                )),
                          ),
                          AutoSizeText(
                            widget.productData!["companyName"],
                            style: TextStyle(
                              color: Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, bottom: 10),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: IconButton(
                                icon: Icon(
                                  Icons.download,
                                  color: Color(0xffffffff),
                                ),
                                onPressed: () {}),
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(1),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffffffff)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                widget.productData!["productStock"].toString() +
                                    '  ' +
                                    "Adet",
                                style: TextStyle(
                                  color: Color(0xff2b2e83),
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
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Color(0xff2b2e83),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "850",
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xffffffff)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            "Takip Et",
                            style: TextStyle(
                              color: Color(0xff2b2e83),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          left: -13,
                          child: CircleAvatar(
                            backgroundColor: Color(0xff2b2e83),
                            radius: 12,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: Icon(
                                Icons.add,
                                color: Color(0xffffffff),
                              ),
                            ),
                          )),
                    ],
                  )),
            ],
          ),
        )
      ],
    );
  }
}
