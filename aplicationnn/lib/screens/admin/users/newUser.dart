import 'dart:convert';
import 'package:aplicationnn/screens/admin/users/UsersDetays.dart';
import 'package:aplicationnn/services/userService.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../adminHome.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String? valueChoose, valueChoosee;
  int? selectedIndex;
  bool isUserLoading = false;
  List? userList;
  bool isSwitched = false;
  String url = "http://185.88.175.96:";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    await UserService.getStatusFalseUser().then((onValue) {
      if (mounted) {
        setState(() {
          userList = onValue['content'];

          isUserLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isUserLoading = false;
        });
      }
    });
  }

  getStatus(id) async {
    Map<String, dynamic> body = {
      "status": isSwitched,
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.put(Uri.parse(url + "/rest/user-status/$id"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + tokenn!,
        },
        body: jsonEncode(body));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.userRegistrationActive);
    } else {
      showSnackbar(AppLocalizations.of(context)!.userRegistrationNotActive);
    }
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
                                builder: (context) => AdminHomeeScreen()));
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registeredInstitutions),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 100, 50, 240),
      ),
      body: userList == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userList!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  key: ValueKey(userList![index]),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    extentRatio: 0.16,
                    children: [
                      SlidableAction(
                          icon: Icons.delete,
                          backgroundColor:
                              const Color.fromARGB(255, 100, 50, 240),
                          onPressed: (context) {
                            setState(() {
                              selectedIndex =
                                  userList!.indexOf(userList![index]);
                            });
                          })
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserDetailPage(
                                  userId: (userList![index]["id"]))));
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
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        title: Text(userList![index]['firstName'] +
                            " " +
                            userList![index]['lastName']),
                        trailing: Switch(
                          onChanged: (bool value) {
                            setState(() {
                              if (value == false) {
                                selectedIndex =
                                    userList!.indexOf(userList![index]);
                                isSwitched = true;
                                getStatus(userList![index]['id']);
                              } else {
                                selectedIndex =
                                    userList!.indexOf(userList![index]);
                                isSwitched = false;
                                getStatus(userList![index]['id']);
                              }
                            });
                          },
                          value: userList![index]['status'] == false
                              ? isSwitched = false
                              : isSwitched = true,
                          activeTrackColor: Colors.green.shade700,
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
