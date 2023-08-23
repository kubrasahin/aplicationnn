import 'dart:convert';
import 'package:aplicationnn/screens/dropdown/settings.dart';
import 'package:aplicationnn/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSettingScreen extends StatefulWidget {
  const UserSettingScreen({super.key});

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? username, lastName, email, address, bio;
  bool isProductLoading = false, isCategoryLoading = false;
  static var UserDetail;
  int _selectedIndex = 0;
  String url = "http://185.88.175.96:";

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  getUserDetail() async {
    await UserService.getUserDetay().then((value) {
      if (mounted) {
        setState(() {
          UserDetail = value;
          print(UserDetail);
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

  updateUser() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      Map<String, dynamic> body = {
        "firstName": username,
        "lastName": lastName,
        "address": address,
        "email": email,
        "bio": bio
      };
      SharedPreferences basicAuth = await SharedPreferences.getInstance();
      String? basic = basicAuth.getString('basic');
      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var res = await http.put(Uri.parse(url + "/rest/user-updateName"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept",
            'Authorization': 'Bearer' + tokenn!,
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      if (res.statusCode == 200) {
        showMessageInScaffold(
            AppLocalizations.of(context)!.userInformationUpdated);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
      } else {
        showMessageInScaffold(
            AppLocalizations.of(context)!.errorOccurredOnUpdate);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
      }
    }
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
      action: SnackBarAction(
          textColor: Color(0xffffffff),
          label: AppLocalizations.of(context)!.close,
          onPressed: () {}),
    ));
  }

  void showSnackbar(message) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
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
          backgroundColor: Color(0xff030116),
        ),
        body: UserDetail == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.userInformation,
                            style: TextStyle(
                                color: Color(0xffffffff),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          style: TextStyle(color: Color(0xffffffff)),
                          key: Key(UserDetail["firstName"]),
                          initialValue: UserDetail["firstName"],
                          onSaved: (String? value) {
                            username = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.name,
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              errorStyle: TextStyle(color: Color(0xffffffff)),
                              helperText: ' ',
                              fillColor: Color(0xff2b2e83),
                              filled: true,
                              // ignore: prefer_const_constructors

                              contentPadding: EdgeInsets.all(15.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
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
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          style: TextStyle(color: Color(0xffffffff)),
                          key: Key(UserDetail["lastName"]),
                          initialValue: UserDetail["lastName"],
                          onSaved: (String? value) {
                            lastName = value;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.surname,
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              errorStyle: TextStyle(color: Color(0xffffffff)),
                              helperText: ' ',
                              fillColor: Color(0xff2b2e83),
                              filled: true,
                              // ignore: prefer_const_constructors

                              contentPadding: EdgeInsets.all(15.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
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
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          style: TextStyle(color: Color(0xffffffff)),
                          key: Key(UserDetail["email"]),
                          initialValue: UserDetail["email"],
                          onSaved: (String? value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.email,
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              errorStyle: TextStyle(color: Color(0xffffffff)),
                              helperText: ' ',
                              fillColor: Color(0xff2b2e83),
                              filled: true,
                              // ignore: prefer_const_constructors

                              contentPadding: EdgeInsets.all(15.0),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
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
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Container(
                          height: 60,
                          child: UserDetail["address"] == null
                              ? TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  maxLength: 50,
                                  onSaved: (String? value) {
                                    address = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.address,
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      helperText: ' ',
                                      fillColor: Color(0xff2b2e83),
                                      filled: true,
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red))),
                                )
                              : TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  key: Key(UserDetail["address"]),
                                  initialValue: UserDetail["address"],
                                  onSaved: (String? value) {
                                    address = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .biography,
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      helperText: ' ',
                                      fillColor: Color(0xff2b2e83),
                                      filled: true,
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red))),
                                )),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Container(
                          height: 60,
                          child: UserDetail["bio"] == null
                              ? TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  maxLength: 50,
                                  onSaved: (String? value) {
                                    bio = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .biography,
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      helperText: ' ',
                                      fillColor: Color(0xff2b2e83),
                                      filled: true,
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red))),
                                )
                              : TextFormField(
                                  style: TextStyle(color: Color(0xffffffff)),
                                  key: Key(UserDetail["bio"]),
                                  initialValue: UserDetail["bio"],
                                  onSaved: (String? value) {
                                    bio = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .biography,
                                          style: TextStyle(
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                      ),
                                      errorStyle:
                                          TextStyle(color: Color(0xffffffff)),
                                      helperText: ' ',
                                      fillColor: Color(0xff2b2e83),
                                      filled: true,
                                      // ignore: prefer_const_constructors

                                      contentPadding: EdgeInsets.all(15.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Color(0xff2b2e83))),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.red))),
                                )),
                    ),
                    const Divider(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          updateUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xffef6328),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.update,
                                style: TextStyle(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ));
  }
}
