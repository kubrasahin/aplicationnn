import 'dart:convert';
import 'package:aplicationnn/screens/admin/subcategory/subCategorySettings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/categoryService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubCategoryAdd extends StatefulWidget {
  const SubCategoryAdd({super.key});

  @override
  State<SubCategoryAdd> createState() => _SubCategoryAddState();
}

class _SubCategoryAddState extends State<SubCategoryAdd> {
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

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  getCategoryData() async {
    await CategoryService.getCategory().then((onValue) {
      if (mounted) {
        setState(() {
          categoryList = onValue['content'];
          print(categoryList);

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

  saveSubCategory() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      Map<String, dynamic> body = {
        "title": title,
        "description": description,
        "categoryName": categoryList![valcategory!]["title"],
        "categoryId": categoryList![valcategory!]["id"].toString(),
      };
      SharedPreferences basicAuth = await SharedPreferences.getInstance();
      String? basic = basicAuth.getString('basic');

      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var res = await http.post(Uri.parse(url + "/rest/subcategory-create"),
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
        showSnackbar(AppLocalizations.of(context)!.subcategorySaved);
      } else {
        showSnackbar(AppLocalizations.of(context)!.subCategoryNotSaved);
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
                                  SubCategorySettingScreen()));
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
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.addSubcategory,
                            style: TextStyle(
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
                            hintText: AppLocalizations.of(context)!
                                .enterSubCategoryName,
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
                            hintText: AppLocalizations.of(context)!.description,
                          ),
                        ),
                      ),
                      const Divider(),
                      buildDropField()
                    ],
                  ),
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                saveSubCategory();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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

  Widget buildDropField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                        itemCount: categoryList!.length,
                        itemBuilder: (context, i) {
                          return RadioListTile(
                            onChanged: (value) {
                              setState(() {
                                valcategory = value!;
                                Navigator.of(context).pop();
                              });
                            },
                            title: Text(categoryList![i]['title']),
                            groupValue: valcategory,
                            value: i,
                            activeColor: const Color.fromARGB(255, 60, 42, 226),
                          );
                        }),
                  );
                });
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(10),
                  child: valcategory == null
                      ? Text(AppLocalizations.of(context)!.selectCategory)
                      : Text(
                          categoryList![valcategory!]["title"],
                        ))),
        ),
      ],
    );
  }
}
