import 'package:aplicationnn/screens/product/productUpdate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../services/productService.dart';

class ApprovalProduct extends StatefulWidget {
  const ApprovalProduct({super.key});

  @override
  State<ApprovalProduct> createState() => _ApprovalProductState();
}

class _ApprovalProductState extends State<ApprovalProduct> {

  final userController = TextEditingController();
  final passwordController = TextEditingController();
  TabController? tabcontroller;
  String? valueChoose, valueChoosee;
  int selectedIndex = 0, currentIndex = 0;
  bool isCategoryLoading = false,
      isProductList = false;
  List?  productList;
  static var UserDetail;


  @override
  void initState() {
    setState(() {
      getProducts();
    });
    super.initState();
  }






  getProducts() async {
    await ProductService.getOnayProducts().then((onValue) {
      if (mounted) {
        setState(() {
          productList = onValue['content'];
          print(productList);
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

  @override
  Widget build(BuildContext context) {
    return                        productList != null
        ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(

      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 10,
      color: Color(0xff030116),
      shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Color(0xff030116), width: 1),
            borderRadius: BorderRadius.circular(20)),
      child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: productList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductUpdate(
                              productId: productList![index]
                              ['id'],
                            ),
                      ),
                    );

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(5),
                        child: Stack(
                          alignment:Alignment.bottomLeft ,
                          children: [
                            Container(
                              height:200,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(image: DecorationImage( fit: BoxFit.cover, image: NetworkImage( productList![index]["imageUrl"]))),

                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: productList![index]["companyImageUrl"]==null?NetworkImage(""): NetworkImage( productList![index]["companyImageUrl"]),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      TextButton(onPressed: (){}, child: Text("Onayla", style: TextStyle(color: Colors.green),)),
                                      TextButton(onPressed: (){}, child: Text("Reddet", style: TextStyle(color: Colors.red),))
                                    ],
                                  ),
                                )
                              ],
                            ),

                          ],
                        )
                    ),
                  ),
                );
              }),
      ),
    ),
        )
        : Container();
  }
}
