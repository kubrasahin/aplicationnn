import 'dart:convert';
import 'dart:io';
import 'package:aplicationnn/screens/admin/category/addPhoto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/categoryService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'categorySettings.dart';

class CategoryDeleteUpdate extends StatefulWidget {
  final String categoryId;
  const CategoryDeleteUpdate({super.key, required this.categoryId});

  @override
  State<CategoryDeleteUpdate> createState() => _CategoryDeleteUpdateState();
}

class _CategoryDeleteUpdateState extends State<CategoryDeleteUpdate> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? title, description, size, category, subcategory, stock;
  int? valcategory, selectedIndex;
  String url = "http://185.88.175.96:";
  XFile? image;
  String selectedFileName = '';
  static var categoryDetail;
  bool isCategoryDetayLoading = false;
  List? categoryList, subCategoryList;

  int _selectedIndex = 0;

  get id => widget.categoryId;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    getCategoryDetail();
  }

  getCategoryDetail() async {
    await CategoryService.getCategoryDetay(widget.categoryId).then((value) {
      if (mounted) {
        setState(() {
          categoryDetail = value;
          isCategoryDetayLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isCategoryDetayLoading = false;
        });
      }
    });
  }

  deleteCategory() async {
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

  updateCategory() async {
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
      var res = await http.put(Uri.parse(url + "/rest/category-update/$id"),
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
        showSnackbar(AppLocalizations.of(context)!.updateCategoryyy);
      } else {
        showSnackbar(AppLocalizations.of(context)!.errorOccurredOnUpdate);
      }
    }
  }

  PickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(
        source: source,
      );
      if (image != null) {
        setState(() {
          selectedFileName = image!.name;
          print(image!.name);
        });
      }
      ;

      final imageTempo = File(image!.path);
      setState(() => this.image = imageTempo as XFile?);
    } on PlatformException catch (e) {}
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
      body: categoryDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
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
                                  AppLocalizations.of(context)!.updateCategory,
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
                                key: Key(categoryDetail["title"]),
                                initialValue: categoryDetail["title"],
                                onSaved: (String? value) {
                                  title = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterCategoryName,
                                ),
                              ),
                            ),
                            const Divider(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TextFormField(
                                key: Key(categoryDetail["description"]),
                                initialValue: categoryDetail["description"],
                                onSaved: (String? value) {
                                  description = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterCategoryName,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          updateCategory();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            color: const Color.fromARGB(255, 100, 50, 240),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.update,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteCategory();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            color: const Color.fromARGB(255, 100, 50, 240),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CategoryPhotoAdd(
                                        categoryId: categoryDetail["id"],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            color: const Color.fromARGB(255, 100, 50, 240),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.photoAttachments,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
