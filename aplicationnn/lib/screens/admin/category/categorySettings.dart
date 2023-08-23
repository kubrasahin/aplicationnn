import 'dart:convert';
import 'package:aplicationnn/screens/admin/category/updateDelete.dart';
import 'package:aplicationnn/services/categoryService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../adminHome.dart';

class CategorySettingScreen extends StatefulWidget {
  const CategorySettingScreen({super.key});

  @override
  State<CategorySettingScreen> createState() => _CategorySettingScreenState();
}

class _CategorySettingScreenState extends State<CategorySettingScreen> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isCategoryLoading = false;
  List? categoryList;
  bool isSwitched = false;
  String url = "http://185.88.175.96:";

  get id => categoryList![selectedIndex!]['id'];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    await CategoryService.getAllCategori().then((onValue) {
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

  getStatus() async {
    Map<String, dynamic> body = {
      "status": isSwitched,
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.put(Uri.parse(url + "/rest/category-updateStatus/$id"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + tokenn!,
        },
        body: jsonEncode(body));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.updateCategoryyy);
    } else {
      showSnackbar(AppLocalizations.of(context)!.errorOccurredOnUpdate);
    }
  }

  deleteCategories(index) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.delete(
      Uri.parse(url + "/rest/category-delete/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + tokenn!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.deleteCategory);
    } else {
      showSnackbar(AppLocalizations.of(context)!.errorOccurredWhileDeleting);
    }
  }

  showSnackbar(message) {
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
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminHomeeScreen()));
                      });
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.categories),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: categoryList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categoryList!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(categoryList![index]),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.16,
                    children: [
                      SlidableAction(
                          icon: Icons.delete,
                          backgroundColor:
                              const Color.fromARGB(255, 100, 50, 240),
                          onPressed: (context) {
                            setState(() {
                              selectedIndex =
                                  categoryList!.indexOf(categoryList![index]);
                              deleteCategories(index);
                            });
                          })
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryDeleteUpdate(
                                  categoryId: (categoryList![index]["id"]))));
                    },
                    child: SizedBox(
                      height: 70,
                      child: ListTile(
                        leading: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          child: categoryList![index]['imageUrl'] == null
                              ? const CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                      categoryList![index]['imageUrl']),
                                  backgroundColor: Colors.transparent,
                                ),
                        ),
                        title: Text(categoryList![index]['title']),
                        trailing: Switch(
                          onChanged: (bool value) {
                            setState(() {
                              if (value == false) {
                                selectedIndex =
                                    categoryList!.indexOf(categoryList![index]);
                                isSwitched = true;
                                getStatus();
                              } else {
                                selectedIndex =
                                    categoryList!.indexOf(categoryList![index]);
                                isSwitched = false;
                                getStatus();
                              }
                            });
                          },
                          value: categoryList![index]['status'] == false
                              ? isSwitched = false
                              : isSwitched = true,
                          activeTrackColor: Colors.green.shade700,
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
