import 'package:aplicationnn/services/userService.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../screens/product/product_deall.dart';

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
  bool isProfilDetail = false,
      isFollowing = false,
      isAddFollowing = false,
      isProductLoading = false;
  var UserDetail, following, addFollowing;

  getFollowingg() async {
    await UserService.following(widget.productData!['companyId']).then((value) {
      if (mounted) {
        setState(() {
          following = value;
          print(following);
          isFollowing = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isFollowing = false;
        });
      }
    });
  }

  AddFollowingg() async {
    await UserService.addFollowing(widget.productData!['companyId'])
        .then((value) {
      if (mounted) {
        setState(() {
          addFollowing = value;
          print(addFollowing);
          isAddFollowing = true;
          getFollowingg();
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isAddFollowing = false;
        });
      }
    });
  }

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
                            child: CircleAvatar(
                              radius: 30,
                              child: ClipOval(
                                child: widget.productData!['companyImageUrl'] ==
                                        null
                                    ? Container()
                                    : Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                  widget.productData![
                                                      'companyImageUrl'],
                                                ))),
                                      ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: AutoSizeText(
                                widget.productData!["companyName"],
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
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
              following == false
                  ? Container(
                      decoration: BoxDecoration(
                          color: Color(0xffffffff),
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          InkWell(
                            onTap: () {
                              AddFollowingg();
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffffffff)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  AppLocalizations.of(context)!.follows,
                                  style: TextStyle(
                                    color: Color(0xff2b2e83),
                                  ),
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
                      ))
                  : InkWell(
                      onTap: () {
                        AddFollowingg();
                      },
                      child: Container(
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
                                    color: Color(0xff2b2e83)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    AppLocalizations.of(context)!.beingFollowed,
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    )
            ],
          ),
        )
      ],
    );
  }
}
