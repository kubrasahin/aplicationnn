import 'dart:convert';
import 'package:aplicationnn/screens/auth/login.dart';
import 'package:aplicationnn/screens/auth/otp.dart';
import 'package:http/http.dart' as http;
import 'package:aplicationnn/screens/auth/start.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../id.dart';

class KurumsalUser extends StatefulWidget {
  const KurumsalUser({Key? key}) : super(key: key);

  @override
  State<KurumsalUser> createState() => _KurumsalUserState();
}

class _KurumsalUserState extends State<KurumsalUser> {
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var selectedCountryValue, currentLocale;

  final firsController = TextEditingController();
  final lastController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false,
      registerationLoading = false,
      rememberMe = false,
      value = false,
      passwordVisible = true,
      isChecked = false,
      obscureText = true,
      isCuntryLoading = false;
  String? email, password, firstName, lastName, mobileNumber, taxNumber;
  var maskFormatter = MaskTextInputFormatter(
      mask: '+##########',
      filter: {
        "+": RegExp(r'[0-9]'), // sıfırı etkisiz etme
        "#": RegExp(r'[0-9]'),
      },
      type: MaskAutoCompletionType.lazy);
  List listt = ["Kadın", "Erkek"];

  void singnin() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      Map<String, dynamic> body = {
        "firstName": firstName,
        "lastName": lastName,
        "mobileNumber": mobileNumber,
        "email": email,
        "password": password,
        "taxID": taxNumber,
        "institutional": true,
        "followers": {},
        "following": {},
        "followerIds": [],
        "followingIds": []
      };
      var res = await http.post(Uri.parse(Id + "/registration/user-create"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept",
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      print(res);
      if (res.body == "Your account has been successfully created!") {
        SharedPreferences mobile = await SharedPreferences.getInstance();
        mobile.setString('mobileNumber', mobileNumber.toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OtpScreen()));
      } else if (res.body == "Please confirm your account!") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.userRegistrationNotActive);
      } else if (res.body == "There is already an account!") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.userNumberAlreadyRegistered);
      } else if (res.body == "There is no such number!") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.thereIsNoSuchNumber);
      } else {
        showMessageInScaffold(
            AppLocalizations.of(context)!.userRegistrationfailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: Color(0xff030116)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildFirstNameTextField(),
                      buildLastNameTextField(),
                      vergiNumber(),
                      buildMobileNumberTextField(),
                      buildEmailTextField(),
                      buildPasswordTextField(),
                      buildRegisterButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildFirstNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2b2e83)),
          onSaved: (String? value) {
            firstName = value;
          },
          keyboardType: TextInputType.text,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourName;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.person,
                  color: Color(0xff2b2e83),
                ),
              ),
              hintText: AppLocalizations.of(context)!.name,
              hintStyle:
                  const TextStyle(color: Color(0xff2b2e83), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget buildLastNameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2b2e83)),
          onSaved: (String? value) {
            lastName = value;
          },
          keyboardType: TextInputType.text,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourLastname;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.person,
                  color: Color(0xff2b2e83),
                ),
              ),
              contentPadding: EdgeInsets.all(5.0),
              hintText: AppLocalizations.of(context)!.surname,
              hintStyle:
                  const TextStyle(color: Color(0xff2b2e83), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget buildMobileNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2b2e83)),
          onSaved: (String? value) {
            mobileNumber = value;
          },
          controller: null,
          inputFormatters: [maskFormatter],
          keyboardType: TextInputType.number,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourPhoneNumber;
            } else if (value.length < 11) {
              return AppLocalizations.of(context)!.notPhoneNumber;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.phone_android,
                  color: Color(0xff2b2e83),
                ),
              ),
              contentPadding: EdgeInsets.all(5.0),
              hintText: AppLocalizations.of(context)!.phoneNumber,
              hintStyle:
                  const TextStyle(color: Color(0xff2b2e83), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget vergiNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2b2e83)),
          onSaved: (String? value) {
            taxNumber = value;
          },
          controller: null,
          keyboardType: TextInputType.number,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enteryourTaxNumber;
            } else if (value.length < 11) {
              return AppLocalizations.of(context)!
                  .youEnteredYourTaxNumberIncorrectly;
            } else {
              return null;
            }
          },
          inputFormatters: [maskFormatter],
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.confirmation_num,
                  color: Color(0xff2b2e83),
                ),
              ),
              contentPadding: EdgeInsets.all(5.0),
              hintText: AppLocalizations.of(context)!.taxt,
              hintStyle:
                  const TextStyle(color: Color(0xff2b2e83), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget buildEmailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2b2e83)),
          onSaved: (String? value) {
            email = value;
          },
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourEmail;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.email,
                  color: Color(0xff2b2e83),
                ),
              ),
              hintText: AppLocalizations.of(context)!.email,
              hintStyle:
                  const TextStyle(color: Color(0xff2b2e83), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2b2e83)),
          onSaved: (String? value) {
            password = value;
          },
          keyboardType: TextInputType.text,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourPassword;
            } else {
              return null;
            }
          },
          obscureText: true,
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.lock,
                  color: Color(0xff2b2e83),
                ),
              ),
              hintText: AppLocalizations.of(context)!.password,
              hintStyle:
                  const TextStyle(color: Color(0xff2b2e83), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2b2e83),
                  )),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red)),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.red))),
        ),
      ),
    );
  }

  Widget buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Color(0xff2b2e83),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 3, color: Colors.white)),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: TextButton(
            style: const ButtonStyle(),
            onPressed: () async {
              singnin();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations.of(context)!.register,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
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
          disabledTextColor: Colors.white,
          label: AppLocalizations.of(context)!.close,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          }),
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
                color: const Color.fromARGB(255, 100, 50, 240),
                child: TextButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StartScreen()));
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  void showSnackbar2(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
            ),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          );
        });
  }
}
