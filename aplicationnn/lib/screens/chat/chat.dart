import 'dart:convert';
import 'package:aplicationnn/screens/home.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/chatService.dart';
import '../../services/userService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  const ChatPage({
    Key? key,
    required this.chatId,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool sendButton = false,
      isLoadingChat = false,
      show = false,
      isChatMessagesLoading = false,
      userDetailLoading = false,
      isChatReciverMessagesLoading = false;
  String? message, isMe;
  List? chatSenderList, chatReciverList;
  static var userDetail;
  String url = "http://185.88.175.96:";
  FocusNode focusnode = FocusNode();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  get id => widget.chatId;
  @override
  void initState() {
    getSenderMessages();
    getUserDetail();
    super.initState();
  }

  getUserDetail() {
    UserService.getIdUserDetay(widget.chatId).then((value) {
      if (mounted) {
        setState(() {
          userDetail = value;
          print("++++++DETAYYYYYYYYYYYY+++++++++++++");
          print(userDetail);
          userDetailLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          userDetailLoading = false;
        });
      }
    });
  }

  getSenderMessages() async {
    await ChatServices.getSenderReciverChat(widget.chatId).then((onValue) {
      if (mounted) {
        setState(() {
          chatSenderList = onValue['content'];
          isMe = widget.chatId;
          print("++++++SENDER+++++++++++++");
          print(chatSenderList);
          isChatMessagesLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          print("HATAAAAAAAA");
          isChatMessagesLoading = false;
        });
      }
    });
  }

  sendMessage(text) async {
    Map<String, dynamic> body = {
      "message": text,
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = basicAuth.getString('token');
    var res = await http.post(Uri.parse(url + "/rest/message-sender/$id"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + token!,
        },
        body: jsonEncode(body));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      print("MESja İltildi");
      getSenderMessages();
      controller.text = '';
    } else {}
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
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      /*appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 85, 53, 231),
        title: chatSenderList == null
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  userDetail["imageUrl"] == null
                      ? (CircleAvatar(
                          backgroundImage: NetworkImage(""),
                        ))
                      : CircleAvatar(
                          backgroundImage: NetworkImage(userDetail["imageUrl"]),
                          backgroundColor: Colors.transparent,
                        ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userDetail["firstName"] + userDetail["lastName"] == null
                            ? Container()
                            : Text(userDetail["firstName"] +
                                '  ' +
                                userDetail["lastName"])
                      ],
                    ),
                  )
                ],
              ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),*/
      body:  chatSenderList == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: MediaQuery.sizeOf(context).height,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                  color: Color(0x33e6eefa),
                  borderRadius: BorderRadius.circular(40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userDetail == null
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  userDetail["imageUrl"] == null
                                      ? CircleAvatar(
                                          radius: 25,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: AssetImage(
                                                'assets/askida.png',
                                              ),
                                            )),
                                          )
                                        )
                                      : CircleAvatar(
                                          radius: 25,
                                          backgroundImage: NetworkImage(
                                              userDetail["imageUrl"]),
                                          backgroundColor: Colors.transparent,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        userDetail["firstName"] +
                                                    userDetail["lastName"] ==
                                                null
                                            ? Container()
                                            : Text(
                                                userDetail["firstName"] +
                                                    '  ' +
                                                    userDetail["lastName"],
                                                style: TextStyle(
                                                  color: Color(0xffffffff),
                                                ),
                                              )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeeScreen(
                                              currentIndex: 2,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 20, bottom: 5, top: 5),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color(0xff5790df),
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Color(0xff5790df),
                    ),
                  ),
                  Expanded(
                    child:  chatSenderList == null
                          ? Container()
                          : ListView.builder(
                              reverse: true,
                              controller: scrollController,
                              itemCount: chatSenderList!.length,
                              itemBuilder: (context, index) {
                                return isMe ==
                                        chatSenderList![index]['receiverId']
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Flexible(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xff5790df),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                          topLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13),
                                                child: Text(
                                                    chatSenderList![index]
                                                        ['message']),
                                              ),
                                            ))
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                                child: Container(
                                              decoration: BoxDecoration(
                                                  color: Color(0xffffffff),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13),
                                                child: Text(
                                                    chatSenderList![index]
                                                        ['message']),
                                              ),
                                            ))
                                          ],
                                        ),
                                      );
                              }),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(children: [
                        Expanded(
                            child: TextFormField(
                          focusNode: focusnode,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          controller: controller,
                          decoration: InputDecoration(
                              fillColor: Color(0xffffffff),
                              filled: true,

                              /*prefixIcon: IconButton(
                                      onPressed: () {
                                        focusnode.unfocus();
                                        focusnode.canRequestFocus = false;
                                        setState(() {
                                          show = !show;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.emoji_emotions,
                                        color: Color.fromARGB(255, 85, 53, 231),
                                      )),*/
                              hintText: AppLocalizations.of(context)!.message,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                      color: Color(0xffffffff))),
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(width: 1),
                                  borderRadius: BorderRadius.circular(30))),
                        )),
                        Positioned(
                            right: 0,
                            child: InkWell(
                              onTap: () async {
                                sendMessage(controller.text);
                              },
                              child: CircleAvatar(
                                backgroundColor: Color(0xff5790df),
                                radius: 30,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ]),
                      // show ? emojiSelect() : Container()
                    ),
                  )
                ],
              ),
            ),
          ),
    );
  }

 

  Widget emojiSelect() {
    return Offstage(
      offstage: false,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
          config: const Config(
              columns: 7,
              emojiSizeMax: 32.0,
              verticalSpacing: 0,
              horizontalSpacing: 0,
              initCategory: Category.RECENT,
              bgColor: Color(0xFFF2F2F2),
              indicatorColor: Color.fromARGB(255, 85, 53, 231),
              iconColor: Colors.grey,
              iconColorSelected: Color.fromARGB(255, 85, 53, 231),
              showRecentsTab: true,
              recentsLimit: 28,
              categoryIcons: CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL),
          onEmojiSelected: (category, emoji) {},
          onBackspacePressed: () {},
        ),
      ),
    );
  }
}
//Text(   chatList![index]['notifications'][index]['message'])

/* import 'package:flutter/material.dart';
import 'package:pediatricloginpage/screens/widgets/message_textfield.dart';
import 'package:pediatricloginpage/services/chat_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final String chatId;
  ChatPage({
    Key? key,
    required this.chatId,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool sendButton = false, isLoadingChat = false, show = false;
  String? message, isMe;
  List? chatList;

  final TextEditingController _controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    getChat();
    super.initState();
  }

  getChat() async {
    await ChatService.getChatUserMessage(widget.chatId).then((onValue) {
      if (mounted) {
        setState(() {
          chatList = onValue['results'];
          isMe = widget.chatId;
          print("fffffffffffffffffffffffffffffffffffffff");
          print(chatList);
          isLoadingChat = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoadingChat = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: chatList == null
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage(
                        "http://localhost:8181/assets/img/testimonial/ben.jpg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(chatList![0]['notifications'][0]['receiverName'])
                      ],
                    ),
                  )
                ],
              ),
      ),
      body: chatList == null
          ? const Center(child: CircularProgressIndicator())
          : body(),
    );
  }

  body() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Container(
            child: ListView.builder(
                itemCount: chatList![0]['notifications'].length,
                itemBuilder: (context, index) {
                  return isMe ==
                          chatList![0]['notifications'][index]['receiverId']
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.3),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(chatList![0]['notifications']
                                      [index]['message']),
                                ),
                              ))
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.yellow.withOpacity(0.5),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(15),
                                        topLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15))),
                                child: Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Text(chatList![0]['notifications']
                                      [index]['message']),
                                ),
                              ))
                            ],
                          ),
                        );
                }),
          )),
          MessageText()
        ],
      ),
    );
  }
}
//Text(   chatList![index]['notifications'][index]['message'])*/
