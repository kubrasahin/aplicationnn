import 'dart:convert';
import 'package:aplicationnn/screens/auth/login.dart';
import 'package:aplicationnn/screens/dropdown/settings.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpMobileNumber extends StatefulWidget {
  const OtpMobileNumber({super.key});

  @override
  State<OtpMobileNumber> createState() => _OtpMobileNumberState();
}

class _OtpMobileNumberState extends State<OtpMobileNumber> {
  OtpFieldController otpController = OtpFieldController();
  static String url = "http://185.88.175.96:";
  var otp;

  Send() async {
    SharedPreferences number = await SharedPreferences.getInstance();
    String? numberNo = number.getString('number');
    print(numberNo);
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    print(token);
    Map body = {
      "otp": otp,
    };
    var res = await http.put(
        Uri.parse(url + "/rest/user-verified?mobileNumber=$numberNo"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + tokenn!,
        },
        body: jsonEncode(body));
    var response = json.encode(res.body);
    print(res);
    if (res.body == "The code is not found!") {
      showMessageInScaffoldTwo(
          AppLocalizations.of(context)!.enteredCodeIncorrect);
    } else if (res.body ==
        "Your phone number has been successfully verified! ") {
      showMessageInScaffold(
          AppLocalizations.of(context)!.mobileNumberUpdatedSuccessfully);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.error);

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
    }
  }

  void showMessageInScaffoldTwo(messagee) {
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
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
          }),
    ));
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 48, 46, 46)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: 55,
                      fieldStyle: FieldStyle.box,
                      outlineBorderRadius: 15,
                      style: TextStyle(fontSize: 17),
                      onCompleted: (pin) {
                        print("Complated:" + pin);
                        setState(() {
                          otp = pin;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            buildRegisterButton()
          ],
        ),
      ),
    );
  }

  Widget buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 100, 50, 240),
            borderRadius: BorderRadius.circular(15)),
        child: TextButton(
          style: const ButtonStyle(),
          onPressed: () async {
            Send();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.send,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
