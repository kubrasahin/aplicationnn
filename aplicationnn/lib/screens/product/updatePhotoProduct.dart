import 'dart:convert';
import 'dart:io';
import 'package:aplicationnn/screens/admin/category/categorySettings.dart';
import 'package:aplicationnn/screens/admin/subcategory/subCategorySettings.dart';
import 'package:aplicationnn/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductPhotoAdd extends StatefulWidget {
  final String productId;
  const ProductPhotoAdd({super.key, required this.productId});

  @override
  State<ProductPhotoAdd> createState() => _ProductPhotoAddState();
}

class _ProductPhotoAddState extends State<ProductPhotoAdd> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int? selectedIndex;
  String url = "http://185.88.175.96:";
  XFile? image;
  String selectedFileName = '';

  int _selectedIndex = 0;

  get id => widget.productId;

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
          print(image!.name);
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
      Uri.parse("http://185.88.175.96:/rest/product-uploadImage/$id"),
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
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.photoSave);
      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeeScreen(
                                    currentIndex: 3,
                                  )));
    } else {
      showMessageInScaffoldTwo(AppLocalizations.of(context)!.errorOccurredOnUpdate);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Column(
            
              children: [
                SizedBox(
                  height: 100,
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
                          Icon(Icons.photo)
                        ],
                      )),
                ),
                Divider(),
                image != null
                    ?  ClipRRect(borderRadius: BorderRadius.circular(30),
                      child: Image.file(
                          //to show image, you type like this.
                          File(image!.path),
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width/2,
                          
                          
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
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      AppLocalizations.of(context)!.save,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    )),
                  ),
                  color: const Color.fromARGB(255, 100, 50, 240),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
