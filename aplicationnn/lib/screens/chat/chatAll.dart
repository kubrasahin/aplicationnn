import 'dart:convert';
import 'package:aplicationnn/screens/chat/chat.dart';
import 'package:aplicationnn/screens/home.dart';
import 'package:aplicationnn/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../id.dart';

class ChatAll extends StatefulWidget {
  const ChatAll({super.key});

  @override
  State<ChatAll> createState() => _ChatAllState();
}

class _ChatAllState extends State<ChatAll> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool ischatLoading = false;
  List? chatList, chatTwoList;
  bool isSwitched = false;

  get id => chatList![selectedIndex!]['receiverId'];

  @override
  void initState() {
    super.initState();
    getChats();
  }

  getChats() async {
    await ChatServices.getChatAll().then((onValue) {
      if (mounted) {
        setState(() {
          chatList = onValue['results'];
          print("++++++MESAJLARRRRRRRRRRRRRR+++++++++++++");
          print(chatList);
          for (int i = 0; i < chatList!.length; i++) {
            for (int a = 0; a < chatList!.length; a++) {
              if (chatList![i]['_id']['receiverId'] ==
                  chatList![a]['_id']['senderId']) {
                chatTwoList = chatList![a];
                print("fcccccccccccc");
                print(chatList![i]['_id']['receiverId']);
              } else {}
            }
          }
          print("İİNCİ LİSTEEEEEEEEEEEEE");
          print(chatTwoList);
          ischatLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATAAAAAAAA");
          ischatLoading = false;
        });
      }
    });
  }

  deleteMessage(index) async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = basicAuth.getString('token');
  setState(() async{
    var res = await http.delete(
      Uri.parse(Id + "/rest/chat-deleteAll/$id"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        'Authorization': 'Bearer' + token!,
      },
    );
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showMessageInScaffold(AppLocalizations.of(context)!.deleteMessage);
    } else {
      showMessageInScaffold(AppLocalizations.of(context)!.error);
    }
  });
  }

  void showMessageInScaffold(messagee) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 6.0,
      backgroundColor: Color(0xffef6328),
      behavior: SnackBarBehavior.floating,
      content: Text(
        messagee,
        style: TextStyle(color: Colors.white),
      ),
    ));
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
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
        body:  Container(
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(color: Color(0xff030116)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Container(
                        height: 70,
                        child: TextFormField(
                          style: TextStyle(color: Color(0xffffffff)),
                          cursorColor: const Color.fromARGB(255, 230, 36, 102),
                          onSaved: (String? value) {},
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
                              fillColor: Color(0x33e6eefa),
                              filled: true,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {},
                                    child: const Icon(Icons.search,
                                        color: Color(0xffffffff))),
                              ),
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: AppLocalizations.of(context)!.search,
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
                  Expanded(
                    child: chatList==null? const Center(child: CircularProgressIndicator()) :  Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(

                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                            color: Color(0x33e6eefa),
                          ),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: chatList!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                chatId: chatList![index]
                                                    ['senderId'])));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Divider(
                                          color:
                                          Color.fromARGB(255, 40, 119, 209),
                                        ),
                                      ),
                                      Slidable(
                                        key: ValueKey(chatList![index]),
                                        endActionPane: ActionPane(
                                          motion: const DrawerMotion(),
                                          extentRatio: 0.16,
                                          children: [
                                            SlidableAction(
                                                icon: Icons.delete,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 100, 50, 240),
                                                onPressed: (context) {
                                                  setState(() {
                                                    selectedIndex = chatList!
                                                        .indexOf(
                                                            chatList![index]);
                                                    deleteMessage(index);
                                                  });
                                                })
                                          ],
                                        ),
                                        child: Container(
                                          height: 70,
                                          child: ListTile(
                                            title: Text(
                                              chatList![index]['senderName'],
                                              style: TextStyle(
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                            subtitle: Text(
                                              chatList![index]['message'],
                                              style: TextStyle(
                                                color: Color(0xffffffff),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                );
                              }),
                        ),
                      ),
                  ),
                  ],
                )),
      ),
    );
  }
}
