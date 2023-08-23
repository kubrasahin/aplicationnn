import 'package:aplicationnn/screens/takeHelp/myTakeHelpDetay.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyTake extends StatefulWidget {
  const MyTake({super.key});

  @override
  State<MyTake> createState() => _MyTakeState();
}

class _MyTakeState extends State<MyTake> {
  bool isTakeLoading = false;
  List? takeList;

  @override
  void initState() {
    super.initState();
    getMyTake();
  }

  getMyTake() async {
    await ProductService.getTake().then((onValue) {
      if (mounted) {
        setState(() {
          takeList = onValue['content'];
          isTakeLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isTakeLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myTake),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: isTakeLoading == false
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: takeList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTalkHelpDetay(
                                orderID: (takeList![index]["id"]))));
                  },
                  child: Container(
                    height: 70,
                    child: ListTile(
                      leading: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 5,
                        margin: const EdgeInsets.all(10),
                        child: CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                              takeList![index]["products"]['imageUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      title: Text(takeList![index]["products"]['productName']),
                    ),
                  ),
                );
              }),
    );
  }
}
