import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/categoryService.dart';

class ProductApprovalDelete extends StatefulWidget {
  final String productId;
  const ProductApprovalDelete({Key? key, required this.productId});

  @override
  State<ProductApprovalDelete> createState() => _ProductApprovalDeleteState();
}

class _ProductApprovalDeleteState extends State<ProductApprovalDelete> {
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
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            productDetail["imageUrl"]),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Ürün Adı",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: productDetail["title"] == null
                                    ? Text("")
                                    : Text(productDetail["title"].toString(),
                                        style: TextStyle(
                                            color: Color(0xffffffff)))),
                            const Divider(
                              color: Color(0xffffffff),
                            ),
                            Text(
                              "Açıklama",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: productDetail["description"] == null
                                    ? Text("")
                                    : Text(
                                        productDetail["description"].toString(),
                                        style: TextStyle(
                                            color: Color(0xffffffff)))),
                            const Divider(
                              color: Color(0xffffffff),
                            ),
                            Text(
                              "Anahtar Kelime",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: productDetail["keyWords"] == null
                                  ? Text("")
                                  : Text(productDetail["keyWords"].toString(),
                                      style:
                                          TextStyle(color: Color(0xffffffff))),
                            ),
                            const Divider(
                              color: Color(0xffffffff),
                            ),
                            Text(
                              "Stok",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            productDetail["productStock"] == null
                                ? Text("")
                                : Text(
                                    productDetail["productStock"].toString(),
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                            const Divider(
                              color: Color(0xffffffff),
                            ),
                            Text(
                              "Kategori",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            productDetail["categoryName"] == null
                                ? Text("")
                                : Text(
                                    productDetail["categoryName"].toString(),
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                            const Divider(
                              color: Color(0xffffffff),
                            ),
                            Text(
                              "Alt Kategori",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            productDetail["SubCategoryName"] == null
                                ? Text("")
                                : Text(
                                    productDetail["SubCategoryName"].toString(),
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                            const Divider(
                              color: Color(0xffffffff),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
    );
  }
}
