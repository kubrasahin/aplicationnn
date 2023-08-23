import 'dart:convert';

import 'package:aplicationnn/screens/admin/category/addCategory.dart';
import 'package:aplicationnn/screens/admin/category/categorySettings.dart';
import 'package:aplicationnn/screens/admin/subcategory/addSubCategory.dart';
import 'package:aplicationnn/screens/admin/subcategory/subCategorySettings.dart';
import 'package:aplicationnn/services/categoryService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../auth/login.dart';

class AdminStoreScreen extends StatefulWidget {
  const AdminStoreScreen({super.key});

  @override
  State<AdminStoreScreen> createState() => _AdminStoreScreenState();
}

class _AdminStoreScreenState extends State<AdminStoreScreen> {
  String url = "http://185.88.175.96:";
  PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCategoryLoading = false;
  List? categoryList;

  @override
  void initState() {
    super.initState();
    getCategoryData();
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

  getCategoryData() async {
    await CategoryService.getCategory().then((onValue) {
      if (mounted) {
        setState(() {
          categoryList = onValue['content'];
          isCategoryLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCategoryLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: categoryList == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Divider(),
                  const Text("Kategori"),
                  const Divider(),
                  Container(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CategoryAdd()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 100, 50, 240),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.addCategory,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategorySettingScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(255, 100, 50, 240),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .categorySettings,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const Text("Alt Kategori"),
                  const Divider(),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubCategoryAdd()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 100, 50, 240),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .addSubcategory,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SubCategorySettingScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 100, 50, 240),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .subcategorySettings,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const Divider(),
                  Container(
                    height: 70,
                    child: InkWell(
                      onTap: () {
                        getLogouth();
                      },
                      child: ListTile(
                        selectedColor: Colors.red,
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.exit,
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                ]),
              ));
  }
}
