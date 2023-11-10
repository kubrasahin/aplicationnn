import 'dart:convert';

import 'package:aplicationnn/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../id.dart';
import '../../services/userService.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../dropdown/settings.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _formKey = GlobalKey<FormState>();
  String? password, newPassword, newPasswordTwo;
  bool isProductLoading = false, isCategoryLoading = false;
  static var UserDetail;
  int _selectedIndex = 0;


  UpdatePassword() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      Map<String, dynamic> body = {
        "password": newPassword,
      };
      SharedPreferences mobile = await SharedPreferences.getInstance();
      String? mobileNumber = mobile.getString('mobileNumber');
      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      print(mobileNumber);
      var res = await http.put(
          Uri.parse(Id +
              "/registration/user-resetPassword?mobileNumber=$mobileNumber&passwordAgain=$newPasswordTwo"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept",
            'Authorization': 'Bearer' + tokenn!,
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      print(res);
      if (res.body == "Your password has been successfully changed") {
        showMessageInScaffold(AppLocalizations.of(context)!.updateYourPassword);
      } else if (res.body == "Passwords do not match") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.passwordsDoNotMatch);
      } else {
        showMessageInScaffold(
            AppLocalizations.of(context)!.couldntUpdateYourPassword);
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
                              builder: (context) => LoginScreen()));
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
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Center(
                      child: Text(
                        AppLocalizations.of(context)!.resetPassword,
                        style: TextStyle(
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  )),
              const Divider(),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Container(
                  height: 60,
                  child: TextFormField(
                    style: TextStyle(color: Color(0xffffffff)),
                    onSaved: (String? value) {
                      newPassword = value;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Color(0xffffffff)),
                        helperText: ' ',
                        fillColor: Color(0xff2b2e83),
                        filled: true,
                        // ignore: prefer_const_constructors

                        contentPadding: EdgeInsets.all(15.0),
                        hintText: AppLocalizations.of(context)!.newPassword,
                        hintStyle: TextStyle(
                          color: Color(0xffffffff),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xff2b2e83))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xff2b2e83))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red))),
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                child: Container(
                  height: 60,
                  child: TextFormField(
                    style: TextStyle(color: Color(0xffffffff)),
                    onSaved: (String? value) {
                      newPasswordTwo = value;
                    },
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(color: Color(0xffffffff)),
                        helperText: ' ',
                        fillColor: Color(0xff2b2e83),
                        filled: true,
                        // ignore: prefer_const_constructors

                        contentPadding: EdgeInsets.all(15.0),
                        hintText: AppLocalizations.of(context)!.reenterPassword,
                        hintStyle: TextStyle(
                          color: Color(0xffffffff),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xff2b2e83))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Color(0xff2b2e83))),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red))),
                  ),
                ),
              ),
              Divider(),
              Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () {
                    UpdatePassword();
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
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
