import 'dart:convert';
import 'dart:io';
import 'package:aplicationnn/screens/admin/subcategory/addPhotoSubcategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/categoryService.dart';
import '../adminHome.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubCategoryDeleteUpdate extends StatefulWidget {
  final String subCategoryId;
  const SubCategoryDeleteUpdate({super.key, required this.subCategoryId});

  @override
  State<SubCategoryDeleteUpdate> createState() =>
      _SubCategoryDeleteUpdateState();
}

class _SubCategoryDeleteUpdateState extends State<SubCategoryDeleteUpdate> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? title, description, size, category, subcategory, stock;
  int? valcategory, selectedIndex;
  String url = "http://185.88.175.96:";
  XFile? image;
  String selectedFileName = '';
  static var subCategoryDetail;
  bool isCategoryDetayLoading = false;

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

  get id => widget.subCategoryId;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    getSubCategoryDetail();
  }

  getSubCategoryDetail() async {
    await CategoryService.getSubCategoryDetay(widget.subCategoryId)
        .then((value) {
      if (mounted) {
        setState(() {
          subCategoryDetail = value;
          print("alrthsdbmn");
          print(subCategoryDetail);
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

  deleteSubCategory() async {
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

  updateSubCategory() async {
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
      var res = await http.put(Uri.parse(url + "/rest/subcategory-update/$id"),
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
  }

  PickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(
        source: source,
      );
      if (image != null) {
        setState(() {
          selectedFileName = image!.name;
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
                              builder: (context) => const AdminHomeeScreen()));
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
      body: subCategoryDetail == null
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
                                  AppLocalizations.of(context)!
                                      .updateDeleteSubcategory,
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
                                key: Key(subCategoryDetail["title"]),
                                initialValue: subCategoryDetail["title"],
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
                                key: Key(subCategoryDetail["description"]),
                                initialValue: subCategoryDetail["description"],
                                onSaved: (String? value) {
                                  description = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      AppLocalizations.of(context)!.description,
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
                          updateSubCategory();
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
                          deleteSubCategory();
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
                                  builder: (context) => SubcategoryPhotoAdd(
                                        subCategoryId: subCategoryDetail["id"],
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            color: const Color.fromARGB(255, 100, 50, 240),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
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
