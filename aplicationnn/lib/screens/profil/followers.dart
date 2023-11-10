import 'package:aplicationnn/screens/profil/profil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/userService.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isSubCategoryLoading = false, isProductList = false;
  List? followersList;
  bool isFollowersLoading = false;

  @override
  void initState() {
    super.initState();
    getFollowers();
  }

  getFollowers() async {
    await UserService.getFollowerss().then((value) {
      if (mounted) {
        setState(() {
          followersList = value["content"];
          print("TAKİPÇİİİİİİ");
          print(followersList);
          isFollowersLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATA");
          isFollowersLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myFollower),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: followersList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: followersList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UseProfil(
                                  companyId: followersList![index]['id'],
                                )));
                  },
                  child: Container(
                      height: 70,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: followersList![index]['imageUrl'] ==
                                  null
                              ? NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSy7nFdX1g_CVR4WyP5LgKOGytP0J8PE53_RQ&usqp=CAU")
                              : NetworkImage(followersList![index]['imageUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(followersList![index]['firstName'] +
                            " " +
                            followersList![index]['lastName']),
                      )),
                );
              }),
    );
  }
}
