import 'dart:convert';

import 'package:aplicationnn/classes/language.constants.dart';
import 'package:aplicationnn/screens/auth/tabController.dart';
import 'package:aplicationnn/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../classes/language.dart';
import '../../id.dart';
import '../../main.dart';
import '../admin/adminHome.dart';
import '../notification/notifications.dart';
import 'forgotpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  String? getMobileNumber, getPassword;

  late AnimationController lottieController;

  @override
  void initState() {
    lottieController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));
    lottieController.repeat(reverse: true);
    setupOneSignal();
    super.initState();
  }

  @override
  void dispose() {
    lottieController.dispose();
    super.dispose();
  }

  setupOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("252114c9-9268-4c06-9841-f7b3bb31c0ab");
    OneSignal.shared
        .promptUserForPushNotificationPermission() // kullanıcıdan izin al
        .then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
    var deviceState = await OneSignal.shared.getDeviceState();
    var pushToken = deviceState!.userId;

    print("OneSignal Push Aboneliği Token: $pushToken");
    SharedPreferences playerId = await SharedPreferences.getInstance();
    playerId.setString('playerId', pushToken!);
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      //kullanıcı bildirime tıkladığında sonuc döndürüyor
      print("vERİİİİİİİİİİİİİİİİİ");
      print(result.notification.androidNotificationId);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotificationPage()));
    });
  }

  sendPlayerId() async {
    SharedPreferences playerId = await SharedPreferences.getInstance();
    String? playerIdd = playerId.getString('playerId');
    Map<String, dynamic> body = {
      "playerId": playerIdd,
    };
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.put(Uri.parse(Id + "/rest/user-setPlayerId"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
          'Authorization': 'Bearer' + tokenn!,
        },
        body: jsonEncode(body));
    var response = json.encode(res.body);
    if (res.statusCode == 200) {
      print("playerIddDDDDDDDDDDDDDDDDDDD");
      print(playerIdd);
    } else {
      showMessageInScaffold(
          " AppLocalizations.of(context)!.errorOccurredOnUpdate");
    }
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '+##########',
      filter: {
        "+": RegExp(r'[0-9]'), // sıfırı etkisiz etme
        "#": RegExp(r'[0-9]'),
      },
      type: MaskAutoCompletionType.lazy);

  signIn(String user, String password) async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> body = {
        "mobileNumber": user,
        "password": password,
      };
      final String auth =
          'Basic ' + base64Encode(utf8.encode('$user:$password'));

      var res = await http.post(Uri.parse(Id + "/api/login"),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Access-Control-Allow-Headers":
            "Access-Control-Allow-Origin, Accept",
          },
          body: jsonEncode(body));
      var response = json.encode(res.body);
      print(res.statusCode);
      if (res.statusCode == 200) {
        SharedPreferences token = await SharedPreferences.getInstance();
        token.setString('token', response);
        SharedPreferences basicAuth = await SharedPreferences.getInstance();
        basicAuth.setString('basic', auth);
        print("TOKENNNNNNN");
        sendPlayerId();
        print(response);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeeScreen()));


      } else {
        showMessageInScaffold(AppLocalizations.of(context)!.userNotFound);
      }
    }
  }

  void showSnackbar(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              message,
              style: const TextStyle(color: Color.fromARGB(255, 230, 36, 102)),
            ),
            actions: <Widget>[
              TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.close))
            ],
          );
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          body: Form(
            child: SingleChildScrollView(
                child: Container(
                  foregroundDecoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0, 1),
                      end: Alignment(-0, 0),
                      colors: <Color>[Color(0xff000000), Color.fromARGB(0, 15, 12, 12)],
                      stops: <double>[0.151, 0.97],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/giris.png',
                      ),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 30),
                                child: DropdownButton<Language>(
                                  underline: const SizedBox(),
                                  icon: const Icon(
                                    Icons.language,
                                    color: Colors.white,
                                  ),
                                  onChanged: (Language? language) async {
                                    if (language != null) {
                                      Locale _locale =
                                      await setLocale(language.languageCode);
                                      MyApp.setLocale(context, _locale);
                                    }
                                  },
                                  items: Language.languageList()
                                      .map<DropdownMenuItem<Language>>(
                                        (e) => DropdownMenuItem<Language>(
                                      value: e,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          Text(
                                            e.flag,
                                            style: const TextStyle(fontSize: 30),
                                          ),
                                          Text(e.name)
                                        ],
                                      ),
                                    ),
                                  )
                                      .toList(),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          // group48kgw (2:25)

                          width: double.infinity,
                          height: 164 * fem,
                          child: Stack(
                            children: [
                              Positioned(
                                // imageT5Z (2:2)

                                child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 202 * fem,
                                    height: 136 * fem,
                                    child: Image.asset(
                                      'assets/image.png',
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                // askdak4f (2:3)
                                left: 54 * fem,
                                top: 125 * fem,
                                child: Align(
                                  child: SizedBox(
                                    width: 94 * fem,
                                    height: 39 * fem,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        buildMobileNumberTextField(),
                        buildPasswordTextField(),
                        buildLoginButton(),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NumberPage()));
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotMyPassword,
                              style: TextStyle(color: Colors.white),
                            )),
                        buildRowRegister()
                      ],
                    ),
                  ),
                )),
          )),
    );
  }

  Widget buildMobileNumberTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff8c8c8c)),
          onSaved: (String? value) {
            getMobileNumber = value
                ?.replaceAll(RegExp(r'-'), '')
                .replaceAll(RegExp(r'\('), '')
                .replaceAll(RegExp(r'\)'), '');
          },
          controller: userController,
          keyboardType: TextInputType.phone,
          validator: (String? value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourPhoneNumber;
            } else if (value.length < 9) {
              return AppLocalizations.of(context)!.notPhoneNumber;
            } else {
              return null;
            }
          },
          inputFormatters: [maskFormatter],
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.white),
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              // ignore: prefer_const_constructors
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: Icon(
                  Icons.phone_android,
                  color: Color(0xff8c8c8c),
                ),
              ),
              contentPadding: EdgeInsets.all(5.0),
              hintText: AppLocalizations.of(context)!.phoneNumber,
              hintStyle:
              const TextStyle(color: Color(0xff8c8c8c), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 224, 224, 226))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 224, 224, 226))),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Container(
        height: 75,
        child: TextFormField(
          style: TextStyle(color: Color(0xff8c8c8c)),
          cursorColor: const Color.fromARGB(255, 230, 36, 102),
          onSaved: (String? value) {
            getPassword = value;
          },
          controller: passwordController,
          validator: (value) {
            if (value!.isEmpty) {
              return AppLocalizations.of(context)!.enterYourPassword;
            }
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
              errorStyle: TextStyle(color: Colors.white),
              helperText: ' ',
              fillColor: Colors.white,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 5),
                child: const Icon(
                  Icons.lock,
                  color: Color(0xff8c8c8c),
                ),
              ),
              contentPadding: EdgeInsets.all(5.0),
              hintText: AppLocalizations.of(context)!.password,
              hintStyle: const TextStyle(color: Color(0xff8c8c8c)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 224, 224, 226))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 224, 224, 226))),
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

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xffef6328),
        ),
        height: 50,
        width: 200,
        child: TextButton(
            onPressed: () async {
              signIn(userController.text, passwordController.text);
            },
            child: Text(
              AppLocalizations.of(context)!.login,
              style: TextStyle(color: Colors.white, fontSize: 22),
            )),
      ),
    );
  }

  Widget buildRowRegister() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabControllerrr()),
            );
          },
          child: Text(AppLocalizations.of(context)!.register,
              style: TextStyle(color: Colors.white, fontSize: 22))),
    );
  }
}
