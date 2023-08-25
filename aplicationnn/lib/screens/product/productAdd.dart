import 'dart:convert';
import 'dart:io';
import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/screens/product/productSettings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/categoryService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  State<ProductAdd> createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final stockcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? title, description, keyword, category, subcategory, stock;
  int? valcategory, selectedIndex;
  String url = "http://185.88.175.96:";
  bool isCategoryLoading = false;
  List? categoryList, subCategoryList;

  int _selectedIndex = 0;
  XFile? image;
  String selectedFileName = '';

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  getCategoryIdSubCategoryList() async {
    await CategoryService.getCategoryIdSubCategory(valcategory == 0
            ? categoryList![0]["id"]
            : categoryList![valcategory!]["id"])
        .then((onValue) {
      if (mounted) {
        setState(() {
          subCategoryList = onValue;
          print("SUBCATEGORY");
          print(subCategoryList);
        });
      }
    }).catchError((error) {
      print("HATAAAAA");
    });
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

  saveProduct() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();

      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      SharedPreferences basicAuth = await SharedPreferences.getInstance();
      String? basic = basicAuth.getString('basic');
      print(tokenn);
      var headers = {
        'Content-Type': 'multipart/form-data; charset=UTF-8',
        'Authorization': 'Bearer' + tokenn!,
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://185.88.175.96/rest/product-create"),
      );
      /* SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var headers = {
        'Authorization': 'Bearer' + tokenn!,
      };*/

      Map<String, dynamic> body = {
        "title": title.toString(),
        "description": description.toString(),
        "categoryId": categoryList![valcategory!]["id"].toString(),
        "subCategoryId": subCategoryList![_selectedIndex]["id"].toString(),
        "categoryName":  categoryList![valcategory!]["title"].toString(),
        "subCategoryName": subCategoryList![_selectedIndex]["title"].toString(),
        "productStock": stock.toString(),
        "keyWords": keyword.toString(),
      };

      Map<String, String> obj = {"product": json.encode(body).toString()};
      //var obj = {"product": body.toString()};

      request.fields.addAll(obj);
      request.headers.addAll(headers);
      Uint8List data = await this.image!.readAsBytes();
      List<int> list = data.cast();
      print(list);
      var multipartFile =
          http.MultipartFile.fromBytes('file', list, filename: image!.path);
      request.files.add(multipartFile);
      print(image!.path);
      print(body);
      print(obj);
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        showMessageInScaffoldTwo(
            AppLocalizations.of(context)!.yourProductSharingWasSuccessful);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeeScreen(
                      currentIndex: 3,
                    )));
      } else {
        showMessageInScaffoldTwo(AppLocalizations.of(context)!.error);
      }
    }
  }

  void showMessageInScaffoldTwo(messagee) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 6.0,
      backgroundColor: Color(0xffef6328),
      behavior: SnackBarBehavior.floating,
      content: Text(
        messagee,
        style: TextStyle(color: Colors.white),
      ),
      action: SnackBarAction(
          textColor: Color(0xffffffff),
          label: AppLocalizations.of(context)!.close,
          onPressed: () {}),
    ));
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
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  PickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(
        source: source,
      );
      if (image != null) {
        setState(() {
          selectedFileName = image!.path;
          print(image!.name);
        });
      }
      ;

      final imageTempo = File(image!.path);
      // setState(() => this.image = imageTempo as XFile?);
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 650;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      backgroundColor: Color(0xff030116),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff030116),
        title: Container(
          height: 80,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/askida.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Askıda"),
                )
              ]),
        ),
      ),
      body: categoryList == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff030116),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Haydi Askıla",
                              style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        image != null
                            ? Align(
                                alignment: Alignment.center,
                               
                                child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          
                                          child: Image.file(  File(image!.path),
                                                                  fit: BoxFit.cover,
                                                                  height: 150,
                                    width: 150,
                                                                  ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade500,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: IconButton(
                                              onPressed: () {
                                                PickImage(ImageSource.gallery);
                                              },
                                              icon: Icon(Icons.camera_alt),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),)
                              
                            : Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade500,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: IconButton(
                                              onPressed: () {
                                                PickImage(ImageSource.gallery);
                                              },
                                              icon: Icon(Icons.camera_alt),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                                AppLocalizations.of(context)!.photoAttachments,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              style: TextStyle(color: Color(0xff2daae1)),
                              onSaved: (String? value) {
                                title = value;
                              },
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterProductName;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  helperText: ' ',
                                  fillColor: Color(0xff030116),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText: AppLocalizations.of(context)!
                                      .enterProductName,
                                  hintStyle: const TextStyle(
                                      color: Color(0xffffffff), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              style: TextStyle(color: Color(0xff2daae1)),
                              onSaved: (String? value) {
                                description = value;
                              },
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .descriptionProduct;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  helperText: ' ',
                                  fillColor: Color(0xff030116),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText: AppLocalizations.of(context)!
                                      .descriptionProduct,
                                  hintStyle: const TextStyle(
                                      color: Color(0xffffffff), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              style: TextStyle(color: Color(0xff2daae1)),
                              onSaved: (String? value) {
                                keyword = value;
                              },
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterAKeywordForTheProduct;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  helperText: ' ',
                                  fillColor: Color(0xff030116),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText: AppLocalizations.of(context)!
                                      .enterAKeywordForTheProduct,
                                  hintStyle: const TextStyle(
                                      color: Color(0xffffffff), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red))),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 2),
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              style: TextStyle(color: Color(0xff2daae1)),
                              onSaved: (String? value) {
                                stock = value;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                              ],
                              controller: stockcontroller,
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return  AppLocalizations.of(context)!
                                      .inventoryOfProduct;
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  helperText: ' ',
                                  fillColor: Color(0xff030116),
                                  filled: true,
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText: AppLocalizations.of(context)!
                                      .inventoryOfProduct,
                                  hintStyle: const TextStyle(
                                      color: Color(0xffffffff), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Color(0xff2daae1),
                                      )),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.red))),
                            ),
                          ),
                        ),
                        buildDropField(),
                        const Divider(),
                        InkWell(
                          onTap: () {
                            valcategory==null? showMessageInScaffoldTwo("Lütfen kategoriyi seçiniz") :
                            saveProduct();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Container(
                              height: 40,
                              width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xffef6328),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!.save,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }

  Widget saveBuidButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xffef6328),
        ),
        height: 50,
        width: 200,
        child: TextButton(
            onPressed: () async {
              saveProduct();
            },
            child: Text(
              AppLocalizations.of(context)!.save,
              style: TextStyle(color: Colors.white, fontSize: 22),
            )),
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
                                getCategoryIdSubCategoryList();
                                Navigator.of(context).pop();
                              });
                            },
                            title: Text(categoryList![i]['title']),
                            groupValue: valcategory,
                            value: i,
                            activeColor: Color(0xff2daae1),
                          );
                        }),
                  );
                });
          },
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 30),
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff2daae1), width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.all(10),
                  child: valcategory == null
                      ? Text(
                          AppLocalizations.of(context)!
                              .selectTheCategoryOfTheProduct,
                          style: const TextStyle(
                              color: Color(0xffffffff), fontSize: 16),
                        )
                      : Text(categoryList![valcategory!]["title"],
                          style: TextStyle(color: Color(0xffffffff))))),
        ),
        subCategoryList == null
            ? Container()
            : valcategory == null
                ? Container()
                : subCategoriWidget(),
      ],
    );
  }

  Widget buildTextField(BuildContext context, valuee, name, desct) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2daae1)),
          onSaved: (String? value) {
            valuee = value;
          },
          keyboardType: TextInputType.text,
          validator: (String? value) {
            if (value!.isEmpty) {
              return desct;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Color(0xff030116),
              filled: true,
              contentPadding: EdgeInsets.all(5.0),
              hintText: name,
              hintStyle:
                  const TextStyle(color: Color(0xffffffff), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2daae1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2daae1),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget subCategoriWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: SizedBox(
          height: 50,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: subCategoryList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () => _onSelected(index),
                    child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex != null &&
                                    _selectedIndex == index
                                ? Color(0xff2daae1)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(subCategoryList![index]["title"]),
                        )),
                  ),
                );
              })),
    );
  }
}
