import 'dart:convert';
import 'package:aplicationnn/screens/settings/otpMobileNumber.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../id.dart';
import '../../services/userService.dart';
import '../dropdown/settings.dart';

class IphoneSettingScreen extends StatefulWidget {
  const IphoneSettingScreen({super.key});

  @override
  State<IphoneSettingScreen> createState() => _IphoneSettingScreenState();
}

class _IphoneSettingScreenState extends State<IphoneSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? mobileNumber;
  bool isProductLoading = false, isCategoryLoading = false;
  static var UserDetail;
  int _selectedIndex = 0;
  var maskFormatter = MaskTextInputFormatter(
      mask: '+###########',
      filter: {
        "+": RegExp(r'[0-9]'), // sıfırı etkisiz etme
        "#": RegExp(r'[0-9]'),
      },
      type: MaskAutoCompletionType.lazy);
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
      Map<String, dynamic> body = {"mobileNumber": mobileNumber};
      SharedPreferences basicAuth = await SharedPreferences.getInstance();
      String? basic = basicAuth.getString('basic');
      SharedPreferences token = await SharedPreferences.getInstance();
      String? tokenn = token.getString('token');
      var res = await http.put(Uri.parse(Id + "/rest/user-upMobileNumber"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
                "Access-Control-Allow-Origin, Accept",
            'Authorization': 'Bearer' + tokenn!,
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      if (res.body == "Message has been sent!") {
        SharedPreferences number = await SharedPreferences.getInstance();
        number.setString('number', mobileNumber.toString());
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const OtpMobileNumber()));
      } else if (res.body == "There is no such number!") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.enteredNumberIncorrect);
      } else if (res.body == "There is already an account!") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.thisNumberIsAlreadyRegistered);
      } else if (res.body == "Something went wrong!") {
        showMessageInScaffold(
            AppLocalizations.of(context)!.errorOccurredWhileSendingSms);
      } else {
        showMessageInScaffold(AppLocalizations.of(context)!.error);
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
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsScreen()));
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
                child: ListView(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .cellPhoneInformation,
                              style: TextStyle(
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        )),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          style: TextStyle(color: Color(0xffffffff)),
                          key: Key(UserDetail["mobileNumber"].toString()),
                          initialValue: UserDetail["mobileNumber"].toString(),
                          onSaved: (String? value) {
                            mobileNumber = value;
                          },
                          controller: null,
                          inputFormatters: [maskFormatter],
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  AppLocalizations.of(context)!.mobilePhone,
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
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Color(0xff2b2e83))),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      const BorderSide(color: Colors.red)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      const BorderSide(color: Colors.red))),
                        ),
                      ),
                    ),
                    Divider(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          updateUser();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
