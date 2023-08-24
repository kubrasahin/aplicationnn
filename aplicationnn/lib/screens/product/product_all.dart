import 'package:aplicationnn/screens/product/product_deall.dart';
import 'package:aplicationnn/services/categoryService.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:aplicationnn/widget/productCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductAll extends StatefulWidget {
  final String? categoryId;
  const ProductAll({Key? key, this.categoryId});

  @override
  State<ProductAll> createState() => _ProductAllState();
}

class _ProductAllState extends State<ProductAll> {
  final ScrollController _scrollController = ScrollController();

  bool isUserLoaggedIn = false,
      isFirstPageLoading = true,
      isNextPageLoading = false,
      isSubCategoryLoading = true,
      isProductsForDeal = false,
      isProductsForCategory = false;
  int? productsPerPage = 12,
      productsPageNumber = 0,
      totalProducts = 1,
      selectedSubCategoryIndex;
  String? currency;
  List? productsList, subCategoryList;
  @override
  void initState() {
    getProductsList();
    getCategoryIdSubCategoryList();
    methodCallsInitiate();
    getProductsList();
    super.initState();
  }

  methodCallsInitiate() {
    if (selectedSubCategoryIndex == 0) {
      getProductsList();
    } else {
      getProductsSubCategoryId();
    }
  }

  getProductsList() async {
    await ProductService.getCategoriProducts(widget.categoryId).then((onValue) {
      if (mounted) {
        productsList = onValue['body']['content'];
        print("object");
        print(productsList);
        print("object");
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isFirstPageLoading = false;
          isNextPageLoading = false;
        });
      }
    });
  }

  getCategoryIdSubCategoryList() async {
    await CategoryService.getCategoryIdSubCategory(widget.categoryId)
        .then((onValue) {
      if (mounted) {
        setState(() {
          subCategoryList = onValue;
          print("SUBCATEGORY");
          print(subCategoryList);
        });
      }
    }).catchError((error) {});
  }

  getProductsSubCategoryId() async {
    await ProductService.getSubCatgoriesProducts(widget.categoryId,
            subCategoryList![selectedSubCategoryIndex! - 1]['id'])
        .then((onValue) {
      if (mounted) {
        setState(() {
          productsList = onValue['body']['content'];
          print(productsList);
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isFirstPageLoading = false;
          isNextPageLoading = false;
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
        toolbarHeight: 100,
        title: Container(
          height: 100,
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
      body: productsList == null || subCategoryList == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: subCategoryList == null
                          ? const Center(child: CircularProgressIndicator())
                          : DefaultTabController(
                              length: subCategoryList!.length + 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                decoration:
                                    BoxDecoration(color: Color(0xff030116)),
                                child: TabBar(
                                  isScrollable: true,
                                  unselectedLabelColor:
                                      Colors.white.withOpacity(0.7),
                                  labelColor: Colors.white,
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorWeight: 5,
                                  onTap: (index) {
                                    setState(() {
                                      selectedSubCategoryIndex = index;
                                    });
                                    methodCallsInitiate();
                                  },
                                  tabs: new List<Widget>.generate(
                                    subCategoryList!.length + 1,
                                    (int index) {
                                      return index == 0
                                          ? Tab(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .all)
                                          : Tab(
                                              text: subCategoryList![index - 1]
                                                  ['title'],
                                            );
                                    },
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: productsList!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDeal(
                                              productID: productsList![index]
                                                  ['id'])));
                                },
                                child: ProductCard(
                                  productData: productsList![index],
                                )),
                          );
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
