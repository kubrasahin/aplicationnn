import 'package:aplicationnn/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDetailPage extends StatefulWidget {
  final String? userId;
  const UserDetailPage({super.key, this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  final _formKey = GlobalKey<FormState>();
  bool userDetailLoading = false;
  static var UserDetail;
  int _selectedIndex = 0;
  String url = "http://185.88.175.96:";

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  getUserDetail() {
    UserService.getIdUserDetay(widget.userId).then((value) {
      if (mounted) {
        setState(() {
          UserDetail = value;
          print(UserDetail);
          userDetailLoading = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          userDetailLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: UserDetail == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.black)),
                          title: Center(
                            child: Text(
                              AppLocalizations.of(context)!.userInformation,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    const Divider(),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(AppLocalizations.of(context)!.name),
                              )),
                          Expanded(
                            child: TextFormField(
                              key: Key(UserDetail["firstName"]),
                              initialValue: UserDetail["firstName"],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child:
                                    Text(AppLocalizations.of(context)!.surname),
                              )),
                          Expanded(
                            child: TextFormField(
                              key: Key(UserDetail["lastName"]),
                              initialValue: UserDetail["lastName"],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child:
                                    Text(AppLocalizations.of(context)!.email),
                              )),
                          Expanded(
                            child: TextFormField(
                              key: Key(UserDetail["email"].toString()),
                              initialValue: UserDetail["email"].toString(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                    AppLocalizations.of(context)!.mobilePhone),
                              )),
                          Expanded(
                            child: TextFormField(
                              key: Key(UserDetail["mobileNumber"].toString()),
                              initialValue:
                                  UserDetail["mobileNumber"].toString(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    SizedBox(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(AppLocalizations.of(context)!.taxt),
                              )),
                          Expanded(
                            child: TextFormField(
                              key: Key(UserDetail["taxID"].toString()),
                              initialValue: UserDetail["taxID"].toString(),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ));
  }
}
