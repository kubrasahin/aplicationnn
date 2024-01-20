import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../id.dart';
import '../../services/userService.dart';
import '../auth/login.dart';
import '../home.dart';
import '../settings/phoneSettings.dart';
import '../settings/security.dart';
import '../settings/userSettings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? image;
  String selectedFileName = '';
  bool isPicUploading = false;
  bool isProductLoading = false, isCategoryLoading = false;
  static var UserDetail;

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

  getLogouth() async {
    SharedPreferences token = await SharedPreferences.getInstance();
    String? tokenn = token.getString('token');
    var res = await http.post(
      Uri.parse(Id + "/logout"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer' + tokenn!,
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    );
    var response = json.encode(res.body);
    print("msdddddddddddddds");
    print(response);

    if (res.statusCode == 200) {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.exitSuccessful);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.notSignedOut);
      Navigator.pop(context);
    }
  }

  PickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(
        source: source,
      );
      if (image != null) {
        setState(() {
          selectedFileName = image!.path;
        });
      }
    } on PlatformException catch (e) {}
  }

  Future imageSave() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');

    var headers = {
      'Authorization': basic!,
    };

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse(Id + "/rest/image/upload"),
    );
    request.headers.addAll(headers);
    Uint8List data = await this.image!.readAsBytes();
    List<int> list = data.cast();
    print(image!.path);
    var multipartFile =
        http.MultipartFile.fromBytes('file', list, filename: "myProfil.png");
    request.files.add(multipartFile);
    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      showMessageInScaffoldTwo(
        AppLocalizations.of(context)!.updateYourProfil,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeeScreen(
                    currentIndex: 3,
                  )));
    } else {
      showMessageInScaffoldTwo(
        AppLocalizations.of(context)!.errorOccurredOnUpdate,
      );
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeeScreen(
                    currentIndex: 3,
                  )));
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
          onPressed: () {}),
    ));
  }

  void showSnackbar3(message) {
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
                              builder: (context) => const LoginScreen()));
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
                              builder: (context) => HomeeScreen(
                                    currentIndex: 3,
                                  )));
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
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
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 650;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeeScreen(
                      currentIndex: 3,
                    )));
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xff030116),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff030116),
          title: Container(
            height: 80,
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
                    child: Text(
                      AppLocalizations.of(context)!.hanging,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]),
          ),
        ),
        body: UserDetail == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff030116),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          image == null
                              ? UserDetail["imageUrl"] == null
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                          radius: 90.0,
                                          backgroundImage: NetworkImage(
                                              "https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8&w=1000&q=80"),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 5,
                                                bottom: 5,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        PickImage(ImageSource
                                                            .gallery);
                                                      });
                                                    },
                                                    icon:
                                                        Icon(Icons.camera_alt),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    )
                                  : Align(
                                      alignment: Alignment.center,
                                      child: CircleAvatar(
                                          radius: 90.0,
                                          backgroundImage: NetworkImage(
                                              UserDetail["imageUrl"]),
                                          backgroundColor: Color(0xffffffff),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                right: 5,
                                                bottom: 5,
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        PickImage(ImageSource
                                                            .gallery);
                                                      });
                                                    },
                                                    icon:
                                                        Icon(Icons.camera_alt),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    )
                              : Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 90,
                                    backgroundImage: FileImage(
                                      File(image!.path),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade500,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.0)),
                                            child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  PickImage(
                                                      ImageSource.gallery);
                                                });
                                              },
                                              icon: Icon(Icons.camera_alt),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          image != null
                              ? Center(
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          imageSave();
                                        });
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.save)),
                                )
                              : Container(),
                          const Divider(
                            color: Colors.white,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserSettingScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff2b2e83),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  selectedColor: Colors.red,
                                  leading: Icon(
                                    Icons.person,
                                    color: Color(0xffffffff),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .myUserInformation,
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SecurityScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff2b2e83),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  selectedColor: Colors.red,
                                  leading: Icon(
                                    Icons.lock,
                                    color: Color(0xffffffff),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .changePassword,
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const IphoneSettingScreen()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff2b2e83),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  selectedColor: Colors.red,
                                  leading: Icon(
                                    Icons.phone,
                                    color: Color(0xffffffff),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .cellPhoneUpdate,
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () {
                              getLogouth();
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff2b2e83),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  selectedColor: Colors.red,
                                  leading: Icon(
                                    Icons.exit_to_app,
                                    color: Color(0xffffffff),
                                  ),
                                  title: Text(
                                    AppLocalizations.of(context)!.exit,
                                    style: TextStyle(color: Color(0xffffffff)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    )),
              ),
      ),
    );
  }

  Widget buildTextField(BuildContext context, valuee, name, desct) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
      child: Container(
        height: 70,
        child: TextFormField(
          style: TextStyle(color: Color(0xff2daae1)),
          onSaved: (String? value) {
            valuee = value;
          },
          keyboardType: TextInputType.text,
          validator: (String? value) {
            if (value!.isEmpty) {
              return desct;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              helperText: ' ',
              fillColor: Color(0xff030116),
              filled: true,
              contentPadding: EdgeInsets.all(5.0),
              hintText: name,
              hintStyle:
                  const TextStyle(color: Color(0xffffffff), fontSize: 16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2daae1),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Color(0xff2daae1),
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

/*import 'dart:convert';
import 'dart:io';
import 'package:aplicationnn/screens/auth/login.dart';
import 'package:aplicationnn/screens/settings/phoneSettings.dart';
import 'package:aplicationnn/screens/settings/security.dart';
import 'package:aplicationnn/screens/settings/userSettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/userService.dart';
import '../home.dart';

class SettingsScreen extends StatefulWidget {
  final String? categoryId;
  const SettingsScreen({super.key, this.categoryId});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String url = "http://185.88.175.96:";
  XFile? image;
  String selectedFileName = '';
  bool isPicUploading = false;
  bool isProductLoading = false, isCategoryLoading = false;
  static var UserDetail;
  @override
  void initState() {
    getUserDetail();

    super.initState();
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

  getLogouth() async {
    String url = "http://185.88.175.96:";
    var res = await http.post(
      Uri.parse(url + "/logout"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
      },
    );
    var response = json.encode(res.body);
    print("msdddddddddddddds");
    print(response);

    if (res.statusCode == 200) {
      showSnackbar3(AppLocalizations.of(context)!.exitSuccessful);
    } else {
      showSnackbar(AppLocalizations.of(context)!.notSignedOut);
    }
  }

  PickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(
        source: source,
      );
      if (image != null) {
        setState(() {
          selectedFileName = image!.name;
          print(image!.name);
        });
      }

      final imageTempo = File(image!.path);
      setState(() => this.image = imageTempo as XFile?);
    } on PlatformException catch (e) {}
  }

  Future imageSave() async {
    SharedPreferences basicAuth = await SharedPreferences.getInstance();
    String? basic = basicAuth.getString('basic');

    var headers = {
      'Authorization': basic!,
    };

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("http://185.88.175.96:/rest/image/upload"),
    );
    request.headers.addAll(headers);
    Uint8List data = await this.image!.readAsBytes();
    List<int> list = data.cast();

    var multipartFile =
        http.MultipartFile.fromBytes('file', list, filename: "myProfil.png");
    request.files.add(multipartFile);

    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      showSnackbar2(
        AppLocalizations.of(context)!.updateYourProfil,
      );
    } else {
      showSnackbar2(
        AppLocalizations.of(context)!.errorOccurredOnUpdate,
      );
    }
  }

  void showSnackbar3(message) {
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
                              builder: (context) => const LoginScreen()));
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
                              builder: (context) => HomeeScreen(
                                    currentIndex: 3,
                                  )));
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
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
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.close)),
              )
            ],
          );
        });
  }

  selectImage() async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(
                new Radius.circular(24.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    AppLocalizations.of(context)!.login,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        decoration: TextDecoration.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(
                          255, 100, 50, 240), // Background color
                    ),
                    onPressed: () {
                      PickImage(ImageSource.camera);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.camera,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.camera_alt),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(
                          255, 100, 50, 240), // Background color
                    ),
                    onPressed: () {
                      PickImage(ImageSource.gallery);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            AppLocalizations.of(context)!.selectFromGallery,
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.photo),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff030116),
      appBar: AppBar(
        backgroundColor: Color(0xff030116),
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
      ),
      body: UserDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color(0xff030116),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: image != null
                          ? CircleAvatar(
                              radius: 90.0,
                              backgroundImage: NetworkImage(image!.path),
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 5,
                                    bottom: 5,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade500,
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: IconButton(
                                        onPressed: () {
                                          PickImage(ImageSource.gallery);
                                        },
                                        icon: Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          : CircleAvatar(
                              radius: 90.0,
                              backgroundImage:
                                  NetworkImage(UserDetail["imageUrl"]),
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 5,
                                    bottom: 5,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade500,
                                          borderRadius:
                                              BorderRadius.circular(30.0)),
                                      child: IconButton(
                                        onPressed: () {
                                          PickImage(ImageSource.gallery);
                                        },
                                        icon: Icon(Icons.camera_alt),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                    ),
                    image != null
                        ? Center(
                            child: TextButton(
                                onPressed: () {
                                  imageSave();
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.save)),
                          )
                        : Container(),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserSettingScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2b2e83),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            selectedColor: Colors.red,
                            leading: Icon(
                              Icons.person,
                              color: Color(0xffffffff),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.myUserInformation,
                              style: TextStyle(color: Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SecurityScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2b2e83),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            selectedColor: Colors.red,
                            leading: Icon(
                              Icons.lock,
                              color: Color(0xffffffff),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.changePassword,
                              style: TextStyle(color: Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const IphoneSettingScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2b2e83),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            selectedColor: Colors.red,
                            leading: Icon(
                              Icons.phone,
                              color: Color(0xffffffff),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.cellPhoneUpdate,
                              style: TextStyle(color: Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        getLogouth();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xff2b2e83),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            selectedColor: Colors.red,
                            leading: Icon(
                              Icons.exit_to_app,
                              color: Color(0xffffffff),
                            ),
                            title: Text(
                              AppLocalizations.of(context)!.exit,
                              style: TextStyle(color: Color(0xffffffff)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
    );
  }*/
}
