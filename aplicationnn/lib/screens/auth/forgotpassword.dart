import 'dart:convert';
import 'package:aplicationnn/screens/auth/login.dart';
import 'package:aplicationnn/screens/auth/otpTwo.dart';
import 'package:aplicationnn/screens/auth/start.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../id.dart';

class NumberPage extends StatefulWidget {
  const NumberPage({super.key});

  @override
  State<NumberPage> createState() => _NumberPageState();
}

class _NumberPageState extends State<NumberPage> {
  OtpFieldController otpController = OtpFieldController();

  var otp;
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  String? getMobileNumber, getPassword, mobileNumber;
  final _formKey = GlobalKey<FormState>();

  Send() async {
    final form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
      form.save();
      SharedPreferences mobile = await SharedPreferences.getInstance();
      mobile.setString('mobileNumber', mobileNumber.toString());
      print(mobile);

      Map body = {
        "mobileNumber": mobileNumber,
      };
      var res = await http.put(Uri.parse(Id + "/registration/user-senderCode"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept",
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      if (res.body == "Code sent!") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OtpScreenTwo()));
      } else if (res.body == "This number is not registered!") {
        showMessageInScaffold(" Numara kayıtlı degil");
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
                              builder: (context) => const LoginScreen()));
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
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 48, 46, 46)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildMobileNumberTextField(),
              SizedBox(
                height: 20,
              ),
              buildRegisterButton()
            ],
          ),
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

  Widget buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 48, 11, 151),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 3, color: Colors.white)),
        child: TextButton(
          style: const ButtonStyle(),
          onPressed: () async {
            Send();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.send,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
