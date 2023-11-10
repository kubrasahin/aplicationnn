import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/screens/product/updatePhotoProduct.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../id.dart';
import '../../services/categoryService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../tab/myaskim.dart';

class ProductUpdate extends StatefulWidget {
  final String productId;
  const ProductUpdate({Key? key, required this.productId});

  @override
  State<ProductUpdate> createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  final _formKey = GlobalKey<FormState>();
  String? title, description, size, category, subcategory, stock, keyword;
  int? valcategory, selectedIndex;
  bool isProductLoading = false, isCategoryLoading = false;
  static var productDetail;
  List? categoryList, subCategoryList;
  int _selectedIndex = 0;

  XFile? image;
  String selectedFileName = '';
  get id => widget.productId;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
    getProductDetail();
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

  getProductDetail() async {
    await ProductService.getProductDetails(widget.productId).then((value) {
      if (mounted) {
        setState(() {
          productDetail = value;
          print("productDetay");
          print(productDetail);
          isProductLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isProductLoading = false;
        });
      }
    });
  }

   

   updateProducttt() async {
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
        'PUT',
        Uri.parse(Id + "/rest/product-update/$id"),
      );
      /* SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var headers = {
        'Authorization': 'Bearer' + tokenn!,
      };*/

      Map<String, dynamic> body = {
        "title": title.toString(),
        "description": description.toString(),
        "categoryId": valcategory==null? productDetail["categoryId"].toString(): categoryList![valcategory!]["id"].toString(),
        "subCategoryId": _selectedIndex==null? productDetail["subCategoryId"].toString() :subCategoryList![_selectedIndex]["id"].toString(),
        "categoryName":valcategory==null? productDetail["categoryName"].toString(): categoryList![valcategory!]["title"].toString(),
        "subCategoryName":  _selectedIndex != null? productDetail["subCategoryName"].toString() :subCategoryList![_selectedIndex]["title"].toString(),
        "productStock": stock.toString(),
        "keyWords": keyword.toString(),
      };

      Map<String, String> obj = {"product": json.encode(body).toString()};

      request.fields.addAll(obj);
      request.headers.addAll(headers);

      if( image!= null){
       Uint8List data = await this.image!.readAsBytes();
      List<int> list = data.cast();
      var multipartFile =
          http.MultipartFile.fromBytes('file', list, filename: image!.path);
      request.files.add(multipartFile);
      } else{
         var emptyData = Uint8List(0);
        var multipartFile =
          http.MultipartFile.fromBytes('file' , emptyData, filename:'' );
      request.files.add(multipartFile);
      }

      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        showMessageInScaffoldTwo(
            AppLocalizations.of(context)!.theProductHasBeenUpdated);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeeScreen(
                      currentIndex: 3,
                    )));
      } else {
        showMessageInScaffoldTwo(AppLocalizations.of(context)!.errorOccurredOnUpdate);
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
          selectedFileName = image!.path;
          print(image!.name);
          print("++++++++++++");
          print(image);
        });
      };

      final imageTempo = File(image!.path);
      // setState(() => this.image = imageTempo as XFile?);
    } on PlatformException catch (e) {
    image= productDetail["imageUrl"];
        print(image);
    }
  }
  imageSave() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');

    var headers = {
      'Authorization': basic!,
    };

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("http://185.88.175.96/rest/product-uploadImage/$id"),
    );
    request.headers.addAll(headers);
    Uint8List data = await this.image!.readAsBytes();
    List<int> list = data.cast();

    var multipartFile =
        http.MultipartFile.fromBytes('file', list, filename: "myProfil.png");
    request.files.add(multipartFile);

    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.photoSave);
      getProductDetail();
      
    } else {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.errorOccurredOnUpdate);
     
    }
  }
  deleteProduct() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.delete(
      Uri.parse(Id + "/rest/product-delete/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + tokenn!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.deleteProduct);
      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeeScreen(
                                    currentIndex: 3,
                                  )));
    } else {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.theProductCouldNotBeDeleted);

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
  @override
  Widget build(BuildContext context) {
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
      body: productDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Form(
                  key: _formKey,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff030116),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView(
                          children: [
                            productDetail["imageUrl"] != null
                            ? Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(20), image: DecorationImage(image: NetworkImage( productDetail["imageUrl"]), fit: BoxFit.cover)),
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
                              )
                              
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
                            
                              SizedBox(height: 20,),
                            Text("Ürün Adı", style:  TextStyle(color: Colors.white, fontSize: 18),),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child:productDetail["title"] == null? TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  maxLength: 50,
                                  onSaved: (String? value) {
                                    title = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                       border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterProductName,
                                      hintStyle: TextStyle(color: Color(0xffffffff)),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      
                                )) : TextFormField(
                                style: TextStyle(color: Color(0xffffffff)),
                                key: Key(productDetail["title"]),
                                initialValue: productDetail["title"],
                                onSaved: (String? value) {
                                  title = value;
                                },
                                decoration: InputDecoration(

                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterProductName,
                                ),
                              )
                            ),const Divider( color: Color(0xffffffff),),
                            Text("Açıklama", style:  TextStyle(color: Colors.white, fontSize: 18),),

                            Container(
                               width: MediaQuery.of(context).size.width / 1.5,
                              child:productDetail["description"] == null
                              ? TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  maxLength: 50,
                                  onSaved: (String? value) {
                                    description = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                       border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .descriptionProduct,
                                      hintStyle: TextStyle(color: Color(0xffffffff)),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      
                                )): TextFormField(
                                style: TextStyle(color: Color(0xffffffff)),
                                maxLength: 300,
                                maxLines: null,
                                key: Key(productDetail["description"]),
                                initialValue: productDetail["description"],
                                onSaved: (String? value) {
                                  description = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterProductName,
                                ),
                              )
                              
                            ),


                            const Divider( color: Color(0xffffffff),),
                            Text("Anahtar Kelime", style:  TextStyle(color: Colors.white, fontSize: 18),),
                            Container(
                               width: MediaQuery.of(context).size.width / 1.5,
                              child:productDetail["keyWords"] == null
                              ? TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  maxLength: 50,
                                  onSaved: (String? value) {
                                    keyword = value;
                                  },
                                  
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                       border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterAKeywordForTheProduct,
                                      hintStyle: TextStyle(color: Color(0xffffffff)),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      
                                )): TextFormField(
                                style: TextStyle(color: Color(0xffffffff)),
                                maxLength: 300,
                                maxLines: null,
                                key: Key(productDetail["keyWords"]),
                                initialValue: productDetail["keyWords"],
                                onSaved: (String? value) {
                                  keyword = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .enterProductName,
                                ),
                              )
                              
                            ),
                            const Divider( color: Color(0xffffffff),),
                            Text("Stok", style:  TextStyle(color: Colors.white, fontSize: 18),),
                            productDetail["productStock"] == null
                            ? TextFormField(
                                style: TextStyle(color: Color(0xffffffff)),
                                maxLength: 50,
                                onSaved: (String? value) {
                                  stock = value;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                     border: InputBorder.none,
                                hintText: AppLocalizations.of(context)!
                                    .inventoryOfProduct,
                                    hintStyle: TextStyle(color: Color(0xffffffff)),
                                    errorStyle:
                                        TextStyle(color: Color(0xffffffff)),
                                    // ignore: prefer_const_constructors

                                    contentPadding: EdgeInsets.all(15.0),

                              )): TextFormField(
                              style: TextStyle(color: Color(0xffffffff)),
                              key: Key(productDetail["productStock"].toString()),
                              initialValue: productDetail["productStock"].toString(),
                              onSaved: (String? value) {
                                stock = value;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                                hintText: AppLocalizations.of(context)!
                                    .inventoryOfProduct,
                              ),
                            ),
                            
                                         const Divider( color: Color(0xffffffff),),         
                            buildDropField(),
                            Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          valcategory==null? showMessageInScaffoldTwo("Lütfen kategoriyi seçiniz") :
                          updateProducttt();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                           decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Color(0xffef6328),),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.update,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          deleteProduct();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Color(0xffef6328),),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.delete,
                                style: TextStyle(
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
                      )),
                ),
                
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
                                getCategoryIdSubCategoryList();
                                Navigator.of(context).pop();
                              });
                            },
                            title: Text(categoryList![i]['title']),
                            groupValue: valcategory,
                            value: i,
                            activeColor:  Color(0xffef6328),
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
                      border: Border.all(
                          color:  Color(0xffffffff),
                          width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(10),
                  child: valcategory == null
                      ? Text( productDetail["categoryName"], style: const TextStyle(
                              color: Color(0xffffffff), fontSize: 16),)
                      : Text(
                          categoryList![valcategory!]["title"], style: const TextStyle(
                              color: Color(0xffffffff), fontSize: 16),
                        ))),
        ),
        subCategoryList == null
            ? Container()
            : valcategory == null
                ? subCategoriWidget()
                : subCategoriWidget(),
      ],
    );
  }

  Widget subCategoriWidget() {
    return  SizedBox(
          height: 60,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: subCategoryList!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () => _onSelected(index),
                    child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex != null &&
                                    _selectedIndex == index
                                ? Color(0xffef6328)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(subCategoryList![index]["title"],style: TextStyle(   color: _selectedIndex != null &&
                                    _selectedIndex == index ?Color(0xffffffff):Colors.black),),
                        )),
                  ),
                );
              })
    );
  }
}
