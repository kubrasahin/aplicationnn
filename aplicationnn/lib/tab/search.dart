import 'package:aplicationnn/screens/product/product_deall.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final getSearchController = TextEditingController();
  final GlobalKey<FormState> _formKeyForSearch = GlobalKey<FormState>();
  String? getSearch;
  List searchresult = [];
  bool isSearching = false, isFirstTime = true, isProductLoading = false;
  List? productsList;
  @override
  void initState() {
    getProduct();
    super.initState();
  }

  searcProduct() async {
    final form = _formKeyForSearch.currentState!;
    if (form.validate()) {
      form.save();

      await ProductService.searchProduct(getSearch).then((onValue) {
        if (mounted) {
          setState(() {
            searchresult = onValue["content"];
            isFirstTime = false;
            isSearching = true;
            print("ARAMAAAAAAAAAAAAA");
            print(searchresult);
          });
        }
      }).catchError((error) {
        print("HATAAAAAAAAA");
      });
    }
  }

  getProduct() async {
    await ProductService.getProducts().then((onValue) {
      if (mounted) {
        setState(() {
          productsList = onValue['body']['content'];
          isProductLoading = false;
          isSearching = true;
          print("ARAMAAAAAAAAAAAAA");
          print(productsList);
        });
      }
    }).catchError((error) {
      print("HATAAAAAAAAA");
    });
  }

  @override
  Widget build(BuildContext context) {
    return productsList == null
        ? const Center(child: CircularProgressIndicator())
        : WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Color(0xff030116),
                toolbarHeight: 100,
                title: Container(
                  height: 100,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/askida.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.hanging,
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ]),
                ),
              ),
              body: Form(
                  key: _formKeyForSearch,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(color: Color(0xff030116)),
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          child: Container(
                            height: 70,
                            child: TextFormField(
                              style: TextStyle(color: Color(0xffffffff)),
                              cursorColor:
                                  const Color.fromARGB(255, 230, 36, 102),
                              onSaved: (String? value) {
                                getSearch = value;
                              },
                              controller: getSearchController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return AppLocalizations.of(context)!
                                      .enterTheWordYouWantToSearch;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.white),
                                  helperText: ' ',
                                  fillColor: Color(0x49d9d9d9),
                                  filled: true,
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        onTap: () {
                                          searcProduct();
                                        },
                                        child: const Icon(Icons.search,
                                            color: Color(0xffffffff))),
                                  ),
                                  contentPadding: EdgeInsets.all(5.0),
                                  hintText:
                                      AppLocalizations.of(context)!.search,
                                  hintStyle:
                                      const TextStyle(color: Color(0xffffffff)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Color(0x49d9d9d9))),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                          color: Color(0x49d9d9d9))),
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
                        isFirstTime
                            ? Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                elevation: 10,
                                color: Color(0xff030116),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xff030116), width: 1),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: MasonryGridView.builder(
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      gridDelegate:
                                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2),
                                      itemCount: productsList!.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDeal(
                                                  productID:
                                                      productsList![index]
                                                          ['id'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: productsList![index]
                                                        ["imageUrl"] ==
                                                    null
                                                ? Image.asset(
                                                    "assets/askida.png")
                                                : Image.network(
                                                    productsList![index]
                                                        ["imageUrl"]),
                                          ),
                                        );
                                      }),
                                ),
                              )
                            : searchresult.length > 0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 18.0,
                                            bottom: 18.0,
                                            left: 20.0,
                                            right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              searchresult.length.toString() +
                                                  " " +
                                                  AppLocalizations.of(context)!
                                                      .foundProducts,
                                              style: TextStyle(
                                                  color: Color(0xffffffff)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 10,
                                        color: Color(0xff030116),
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xff030116),
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: MasonryGridView.builder(
                                              crossAxisSpacing: 8,
                                              mainAxisSpacing: 8,
                                              scrollDirection: Axis.vertical,
                                              physics: ScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate:
                                                  SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2),
                                              itemCount: searchresult.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDeal(
                                                          productID:
                                                              searchresult[
                                                                  index]['id'],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.network(
                                                        searchresult[index]
                                                            ["imageUrl"]),
                                                  ),
                                                );
                                              }),
                                        ),
                                      )
                                    ],
                                  )
                                : Container()
                      ],
                    ),
                  )),
            ),
          );
  }

  Widget searchPage(BuildContext context, title, icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 20.0),
        icon
      ],
    );
  }
}
