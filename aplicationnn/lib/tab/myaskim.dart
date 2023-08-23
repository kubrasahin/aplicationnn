import 'dart:convert';

import 'package:aplicationnn/screens/auth/login.dart';
import 'package:aplicationnn/screens/chat/chatAll.dart';
import 'package:aplicationnn/screens/notification/notifications.dart';
import 'package:aplicationnn/screens/product/productAdd.dart';
import 'package:aplicationnn/screens/product/productSettings.dart';
import 'package:aplicationnn/screens/product/productUpdate.dart';
import 'package:aplicationnn/screens/profil/following.dart';
import 'package:aplicationnn/screens/takeHelp/myHelp.dart';
import 'package:aplicationnn/screens/takeHelp/myTake.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../screens/dropdown/settings.dart';
import '../screens/home.dart';
import '../screens/profil/followers.dart';
import '../services/userService.dart';

class AskimScreen extends StatefulWidget {
  const AskimScreen({super.key});

  @override
  State<AskimScreen> createState() => _AskimScreenState();
}

class _AskimScreenState extends State<AskimScreen> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  String? valueChoose, valueChoosee;
  int selectedIndex = 0, currentIndex = 0;
  bool isCategoryLoading = false,
      isProductList = false,
      isUserDetail = false,
      isFoolowingLoading = false,
      isFollowerLoading = false;
  List? productList, followerList, followingList;
  static var UserDetail;
  List screens = [
    const SettingsScreen(),
    const NotificationPage(),
    const LoginScreen(),
  ];

  @override
  void initState() {
    setState(() {
      getUserDetail();
      getProducts();
      getFollowers();
      getFollowing();
    });
    super.initState();
  }

  getFollowing() async {
    await UserService.getFollowinggs().then((value) {
      if (mounted) {
        setState(() {
          followingList = value['content'];
          print("TAKİPPPPPPPPPPPPPPPPPPPPPPP");
          print(followingList);
          isFoolowingLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("TAKİP HATASI");
          isFoolowingLoading = false;
        });
      }
    });
  }

  getFollowers() async {
    await UserService.getFollowerss().then((value) {
      if (mounted) {
        setState(() {
          followerList = value['content'];
          print("TAKİPÇİİİİİİ");
          print(followerList);
          isFollowerLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("TAKİPÇİ HATASI");
          isFollowerLoading = false;
        });
      }
    });
  }

  getUserDetail() async {
    await UserService.getUserDetay().then((value) {
      if (mounted) {
        setState(() {
          UserDetail = value;
          print(UserDetail);
          isUserDetail = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isUserDetail = false;
        });
      }
    });
  }

  getProducts() async {
    await ProductService.getCompanyIdStatusProduct().then((onValue) {
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

  getLogouth() async {
    String url = "http://185.88.175.96:";
    var res = await http.post(
      Uri.parse(url + "/logout"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    );
    var response = json.encode(res.body);
    print("msdddddddddddddds");
    print(response);

    if (res.statusCode == 200) {
      showSnackbar2(AppLocalizations.of(context)!.exitSuccessful);
    } else {
      showSnackbar(AppLocalizations.of(context)!.notSignedOut);
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
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var items = [
      AppLocalizations.of(context)!.settings,
      AppLocalizations.of(context)!.notifications,
      AppLocalizations.of(context)!.exit
    ];
    return productList == null ||
            UserDetail == null ||
            followingList == null ||
            followerList == null
        ? const Center(child: CircularProgressIndicator())
        : WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
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
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffffffff),
                                    radius: 25,
                                    child: Center(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.notifications_active,
                                            color: Colors.black,
                                            size: 30,
                                            weight: 10,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        NotificationPage()));
                                          }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffffffff),
                                    radius: 25,
                                    child: Center(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.chat,
                                            color: Colors.black,
                                            size: 30,
                                            weight: 10,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeeScreen(
                                                          currentIndex: 2,
                                                        )));
                                          }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffffffff),
                                    radius: 25,
                                    child: Center(
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.settings,
                                            color: Colors.black,
                                            size: 30,
                                            weight: 10,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SettingsScreen()));
                                          }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 3.5,
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
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        "0",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "Poppins",
                                                          color:
                                                              Color(0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                        UserDetail["following"]
                                                            .length
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "Poppins",
                                                          color:
                                                              Color(0xffffffff),
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
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        productList!.length
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "Poppins",
                                                          color:
                                                              Color(0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .myHanger,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: "Poppins",
                                                        color:
                                                            Color(0xffffffff),
                                                        fontWeight:
                                                            FontWeight.w300,
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
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        "0",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: "Poppins",
                                                          color:
                                                              Color(0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: Text(
                                                          UserDetail[
                                                                  "followers"]
                                                              .length
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontFamily:
                                                                "Poppins",
                                                            color: Color(
                                                                0xffffffff),
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
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
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
                                              builder: (context) =>
                                                  ProductUpdate(
                                                productId: productList![index]
                                                    ['id'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                ))),
          );
  }

  Widget productWidget() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProductAdd()));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 100, 50, 240),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.productShare,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget productSetting() {
    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProductSettingScreen()));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 100, 50, 240),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.productSettings,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget myTakee() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyTake()));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 100, 50, 240),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.myTake,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget myHelp() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MyHelp()));
      },
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 100, 50, 240),
              borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.myHelp,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
