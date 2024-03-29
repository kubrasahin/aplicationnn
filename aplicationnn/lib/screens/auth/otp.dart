import 'dart:convert';

import 'package:aplicationnn/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../id.dart';

class OtpScreen extends StatefulWidget {
  final bool? institutional;
  const OtpScreen({super.key, this.institutional});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpFieldController otpController = OtpFieldController();
  var otp, mobileNumber;

  Send() async {
    SharedPreferences mobile = await SharedPreferences.getInstance();
    String? mobileNumber = mobile.getString('mobileNumber');
    print(mobileNumber);

    Map body = {
      "otp": otp,
    };
    var res = await http.put(
        Uri.parse(
            Id + "/registration/user-verified?mobileNumber=$mobileNumber"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        },
        body: jsonEncode(body));
    var response = json.encode(res.body);
    if (res.body == "Your phone number has been successfully verified! " &&
        widget.institutional == true) {
      showMessageInScaffold(
          "Admine kayıtınız iletilmiştir Onayını Beklemelisiniz");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else if (res.body ==
            "Your phone number has been successfully verified! " ||
        widget.institutional == false) {
      showMessageInScaffold(
          AppLocalizations.of(context)!.userRegistrationSuccessful);
    } else if (res.body == "The code is not found!") {
      showMessageInScaffold(
          AppLocalizations.of(context)!.userRegistrationNotActive);
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Color.fromARGB(255, 48, 46, 46)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(mobileNumber.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                Text(
                  AppLocalizations.of(context)!.messageVerification,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
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
