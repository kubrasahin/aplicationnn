import 'dart:convert';
import 'package:aplicationnn/screens/admin/subcategory/updateDeleteSubCategory.dart';
import 'package:aplicationnn/services/categoryService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../adminHome.dart';

class SubCategorySettingScreen extends StatefulWidget {
  const SubCategorySettingScreen({super.key});

  @override
  State<SubCategorySettingScreen> createState() =>
      _SubCategorySettingScreenState();
}

class _SubCategorySettingScreenState extends State<SubCategorySettingScreen> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isSubCategoryLoading = false, isProductList = false;
  List? subCategoryList;
  bool isSwitched = false;
  String url = "http://185.88.175.96:";

  get id => subCategoryList![selectedIndex!]['id'];

  @override
  void initState() {
    super.initState();
    getSubCategories();
  }

  getSubCategories() async {
    await CategoryService.getAllSubCategori().then((onValue) {
      if (mounted) {
        setState(() {
          subCategoryList = onValue['content'];

          isProductList = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProductList = false;
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
    var res =
        await http.put(Uri.parse(url + "/rest/subcategory-updateStatus/$id"),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
              "Access-Control-Allow-Headers":
                  "Access-Control-Allow-Origin, Accept",
              'Authorization': 'Bearer' + tokenn!,
            },
            body: jsonEncode(body));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.updateSubCategory);
    } else {
      showSnackbar(AppLocalizations.of(context)!.errorOccurredOnUpdate);
    }
  }

  deleteSubCategori(index) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.delete(
      Uri.parse(url + "/rest/subcategory-delete/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + tokenn!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.deleteSubCategori);
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
        title: Text(AppLocalizations.of(context)!.subcategorys),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: subCategoryList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: subCategoryList!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(subCategoryList![index]),
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
                              selectedIndex = subCategoryList!
                                  .indexOf(subCategoryList![index]);
                              deleteSubCategori(index);
                            });
                          })
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubCategoryDeleteUpdate(
                                  subCategoryId: (subCategoryList![index]
                                      ["id"]))));
                    },
                    child: SizedBox(
                      height: 70,
                      child: ListTile(
                        leading: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: subCategoryList![index]['imageUrl'] == null
                              ? const CircleAvatar(
                                  radius: 30.0,
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(
                                      subCategoryList![index]['imageUrl']),
                                  backgroundColor: Colors.transparent,
                                ),
                        ),
                        title: Text(subCategoryList![index]['title']),
                        trailing: Switch(
                          onChanged: (bool value) {
                            setState(() {
                              if (value == false) {
                                selectedIndex = subCategoryList!
                                    .indexOf(subCategoryList![index]);
                                isSwitched = true;
                                getStatus();
                              } else {
                                selectedIndex = subCategoryList!
                                    .indexOf(subCategoryList![index]);
                                isSwitched = false;
                                getStatus();
                              }
                            });
                          },
                          value: subCategoryList![index]['status'] == false
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
