import 'package:aplicationnn/screens/takeHelp/myTakeHelpDetay.dart';
import 'package:aplicationnn/services/productService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHelp extends StatefulWidget {
  const MyHelp({super.key});

  @override
  State<MyHelp> createState() => _MyHelpState();
}

class _MyHelpState extends State<MyHelp> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isHelpLoading = false;
  List? helpList;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    getMyHelp();
  }

  getMyHelp() async {
    await ProductService.getHelp().then((onValue) {
      if (mounted) {
        setState(() {
          helpList = onValue['content'];
          isHelpLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isHelpLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myHelp),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: isHelpLoading == false
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: helpList!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTalkHelpDetay(
                                orderID: (helpList![index]["id"]))));
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
                              helpList![index]["products"]['imageUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                      title: Text(helpList![index]["products"]['productName']),
                    ),
                  ),
                );
              }),
    );
  }
}
