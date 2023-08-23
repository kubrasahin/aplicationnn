import 'package:aplicationnn/screens/product/product_deall.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../services/userService.dart';

class UseProfil extends StatefulWidget {
  final String? companyId;
  const UseProfil({super.key, this.companyId});

  @override
  State<UseProfil> createState() => _UseProfilState();
}

class _UseProfilState extends State<UseProfil> {
  bool isProfilDetail = false,
      isFollowing = false,
      isAddFollowing = false,
      isProductLoading = false;
  var UserDetail, following, addFollowing;
  List? productList;
  @override
  void initState() {
    super.initState();
    setState(() {
      getUserDetail();
      getFollowingg();
      getProduct();
    });
  }

  getProduct() async {
    await ProductService.getCompanyProduct(widget.companyId).then((value) {
      if (mounted) {
        setState(() {
          productList = value["content"];
          print(productList);
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

  getUserDetail() {
    UserService.getIdUserDetay(widget.companyId).then((value) {
      if (mounted) {
        setState(() {
          UserDetail = value;
          print(UserDetail);
          isProfilDetail = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProfilDetail = false;
        });
      }
    });
  }

  getFollowingg() async {
    await UserService.following(widget.companyId).then((value) {
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
    await UserService.addFollowing(widget.companyId).then((value) {
      if (mounted) {
        setState(() {
          addFollowing = value;
          print(addFollowing);
          isAddFollowing = true;
          getFollowingg();
          getUserDetail();
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
    return UserDetail == null || following == null || productList == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Color(0xff030116),
            // endDrawer: Drawer(),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/giris.png',
                          ),
                        )),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Container(
                            height: MediaQuery.of(context).size.height / 3.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xff2b2e83)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Text(
                                    UserDetail["firstName"] +
                                        " " +
                                        UserDetail["lastName"],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: "Poppins",
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                UserDetail["bio"] == null
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          UserDetail["bio"],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: "Poppins",
                                            color: Color(0xffffffff),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(children: [
                                          UserDetail["following"] == null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    UserDetail["following"]
                                                        .length
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  )),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .following,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: "Poppins",
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w300,
                                            ),
                                          )
                                        ]),
                                      ),
                                      productList == null
                                          ? Text(
                                              "0",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins",
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Column(children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    productList!.length
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .myHanger,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: "Poppins",
                                                    color: Color(0xffffffff),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ]),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(children: [
                                          UserDetail["followers"] == null
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "0",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Poppins",
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                      UserDetail["followers"]
                                                          .length
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "Poppins",
                                                        color:
                                                            Color(0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ))),
                                          Text(
                                              AppLocalizations.of(context)!
                                                  .follower,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Poppins",
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.w300,
                                              )),
                                        ]),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                      UserDetail["imageUrl"] == null
                          ? Positioned(
                              top: -40,
                              child: CircleAvatar(
                                  radius: 55.0,
                                  backgroundImage: NetworkImage(
                                      "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8&w=1000&q=80")),
                            )
                          : Positioned(
                              top: -40,
                              child: CircleAvatar(
                                radius: 55.0,
                                backgroundImage:
                                    NetworkImage(UserDetail["imageUrl"]),
                                backgroundColor: Color(0x33e6eefa),
                              ),
                            ),
                      Positioned(
                        bottom: -5,
                        child: following == false
                            ? Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Color(0x33e6eefa),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: TextButton(
                                      onPressed: () {
                                        AddFollowingg();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.follows,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xffffffff),
                                        ),
                                      )),
                                ),
                              )
                            : Container(
                                width: 120,
                                decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  child: TextButton(
                                      onPressed: () {
                                        AddFollowingg();
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .beingFollowed,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xff2b2e83),
                                        ),
                                      )),
                                ),
                              ),
                      )
                    ],
                  ),
                  /* Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          productSetting(),
                          productWidget(),
                          myTakee(),
                          myHelp()
                        ],
                      ),*/
                  productList != null
                      ? Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 10,
                          color: Color(0xff030116),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Color(0xff030116), width: 1),
                              borderRadius: BorderRadius.circular(40)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: MasonryGridView.builder(
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: productList!.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDeal(
                                            productID: productList![index]
                                                ['id'],
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                          productList![index]["imageUrl"]),
                                    ),
                                  );
                                }),
                          ),
                        )
                      : Container()
                ],
              ),
            )));

    /*Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              UserDetail["firstName"] + " " + UserDetail["lastName"],
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserDetail["imageUrl"] == null
                          ? (CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage(""),
                            ))
                          : CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  NetworkImage(UserDetail["imageUrl"]),
                              backgroundColor: Colors.transparent,
                            ),
                      UserDetail["firstName"] == null && UserDetail["lastName"]
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                UserDetail["firstName"] +
                                    " " +
                                    UserDetail["lastName"],
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                      UserDetail["bio"] == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(UserDetail["bio"]),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 40),
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: UserDetail["followers"] != null
                                          ? Text(UserDetail["followers"]
                                              .length
                                              .toString())
                                          : Text("0")),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        AppLocalizations.of(context)!.follower),
                                  )
                                ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Column(children: [
                                  Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: UserDetail["following"] != null
                                          ? Text(UserDetail["following"]
                                              .length
                                              .toString())
                                          : Text("0")),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(AppLocalizations.of(context)!
                                        .following),
                                  )
                                ]),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(productList!.length.toString()),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                        AppLocalizations.of(context)!.myHanger),
                                  )
                                ]),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    following == false
                        ? Container(
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: TextButton(
                                  onPressed: () {
                                    AddFollowingg();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.follows,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          )
                        : Container(
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: TextButton(
                                  onPressed: () {
                                    AddFollowingg();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.beingFollowed,
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          )
                  ],
                ),
              ]),
            ),
          ),
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 10,
            color: Color(0xff030116),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xff030116), width: 1),
                borderRadius: BorderRadius.circular(40)),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: MasonryGridView.builder(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: productList!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDeal(
                              productID: productList![index]['id'],
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(productList![index]["imageUrl"]),
                      ),
                    );
                  }),
            ),
          )
        ],
      )),
    );*/
  }
}
