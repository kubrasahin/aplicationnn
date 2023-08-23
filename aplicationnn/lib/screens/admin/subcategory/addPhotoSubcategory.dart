import 'dart:io';
import 'package:aplicationnn/screens/admin/subcategory/subCategorySettings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubcategoryPhotoAdd extends StatefulWidget {
  final String subCategoryId;
  const SubcategoryPhotoAdd({super.key, required this.subCategoryId});

  @override
  State<SubcategoryPhotoAdd> createState() => _SubcategoryPhotoAddState();
}

class _SubcategoryPhotoAddState extends State<SubcategoryPhotoAdd> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? selectedIndex;
  String url = "http://185.88.175.96:";
  XFile? image;
  String selectedFileName = '';

  int _selectedIndex = 0;

  get id => widget.subCategoryId;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
  }

  PickImage(ImageSource source) async {
    try {
      image = await ImagePicker().pickImage(
        source: source,
      );
      if (image != null) {
        setState(() {
          selectedFileName = image!.name;
        });
      }
      ;

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
      Uri.parse("http://185.88.175.96:/rest/subcategory-uploadImage/$id"),
    );
    request.headers.addAll(headers);
    Uint8List data = await this.image!.readAsBytes();
    List<int> list = data.cast();

    var multipartFile =
        http.MultipartFile.fromBytes('file', list, filename: "myProfil.png");
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      showSnackbar(AppLocalizations.of(context)!.photoSave);
    } else {
      showSnackbar(AppLocalizations.of(context)!.errorOccurredOnUpdate);
    }
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
                              builder: (context) =>
                                  const SubCategorySettingScreen()));
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
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    PickImage(ImageSource.gallery);
                  },
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 1.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!
                              .selectCategoryPhoto),
                          const Icon(Icons.photo)
                        ],
                      )),
                ),
                const Divider(),
                image != null
                    ? SizedBox(
                        height: 100,
                        width: 100,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(image!.path),
                        ),
                      )
                    : Expanded(child: Container()),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {
                imageSave();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 100, 50, 240),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.save,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
