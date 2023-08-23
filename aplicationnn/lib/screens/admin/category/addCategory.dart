import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'categorySettings.dart';

class CategoryAdd extends StatefulWidget {
  const CategoryAdd({super.key});

  @override
  State<CategoryAdd> createState() => _CategoryAddState();
}

class _CategoryAddState extends State<CategoryAdd> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? title, description, size, category, subcategory, stock;
  int? valcategory, selectedIndex;
  String url = "http://185.88.175.96:";
  XFile? image;
  String selectedFileName = '';

  bool isCategoryLoading = false;
  List? categoryList, subCategoryList;
  List<Color> colors = [
    const Color.fromARGB(255, 224, 30, 72),
    const Color.fromARGB(255, 7, 214, 111),
    const Color.fromARGB(255, 230, 227, 67),
    const Color.fromARGB(255, 110, 47, 112),
    const Color.fromARGB(255, 194, 113, 37),
    const Color.fromARGB(255, 24, 174, 194),
    Colors.white
  ];
  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
  }

  saveCategory() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      Map<String, dynamic> body = {
        "title": title,
        "description": description,
      };

      SharedPreferences basicAuth = await SharedPreferences.getInstance();
      String? basic = basicAuth.getString('basic');
      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var res = await http.post(Uri.parse(url + "/rest/category-create"),
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
        showSnackbar(AppLocalizations.of(context)!.categorySaved);
      } else {
        showSnackbar(AppLocalizations.of(context)!.categoryNotSaved);
      }
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CategorySettingScreen()));
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
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.addCategory,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          onSaved: (String? value) {
                            title = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                AppLocalizations.of(context)!.enterCategoryName,
                          ),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          onSaved: (String? value) {
                            description = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)!
                                .descriptionCategory,
                          ),
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                saveCategory();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.save,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                  color: const Color.fromARGB(255, 100, 50, 240),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
