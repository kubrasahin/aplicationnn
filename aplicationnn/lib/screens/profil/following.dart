import 'dart:convert';
import 'package:aplicationnn/screens/admin/subcategory/updateDeleteSubCategory.dart';
import 'package:aplicationnn/screens/profil/profil.dart';
import 'package:aplicationnn/services/categoryService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/userService.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isSubCategoryLoading = false, isProductList = false;
  List? followingList;
  bool isFollowingLoading = false;

  @override
  void initState() {
    super.initState();
    getFollowing();
  }

  getFollowing() async {
    await UserService.getFollowinggs().then((value) {
      if (mounted) {
        setState(() {
          followingList = value["content"];
          print("TAKİPÇİİİİİİ");
          print(followingList);
          isFollowingLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATA");
          isFollowingLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myFollowing),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: followingList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: followingList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UseProfil(
                                  companyId: followingList![index]['id'],
                                )));
                  },
                  child: Container(
                      height: 70,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: followingList![index]['imageUrl'] ==
                                  null
                              ? NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSy7nFdX1g_CVR4WyP5LgKOGytP0J8PE53_RQ&usqp=CAU")
                              : NetworkImage(followingList![index]['imageUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(followingList![index]['firstName'] +
                            " " +
                            followingList![index]['lastName']),
                      )),
                );
              }),
    );
  }
}
