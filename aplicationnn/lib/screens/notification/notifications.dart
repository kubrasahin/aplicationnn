import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isNotificationLoading = false;
  List? notificationList;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  getNotifications() async {
    await ChatServices.getNotifications().then((onValue) {
      if (mounted) {
        setState(() {
          notificationList = onValue['content'];
          print("++++++BİLDİRİMLER+++++++++++++");
          print(notificationList);
          isNotificationLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATAAAAAAAA");
          isNotificationLoading = false;
        });
      }
    });
  }

  showSnackbar(message) {
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
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeeScreen(
                                      currentIndex: 2,
                                    )));
                      });
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
      backgroundColor: Color(0xff030116),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff030116),
        toolbarHeight: 80,
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
                  child: Text(
                    AppLocalizations.of(context)!.hanging,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ]),
        ),
      ),
      body: notificationList == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Color(0xff030116)),
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 13,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.notifications,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: notificationList!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NotificationDetail(
                                                notificationID:
                                                    notificationList![index]
                                                        ['id'])));*/
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    child: ListTile(
                                      title: Text(
                                        notificationList![index]['description'],
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                      subtitle: Text(
                                        notificationList![index]['title'],
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
