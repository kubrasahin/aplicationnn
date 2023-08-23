import 'package:aplicationnn/screens/product/productAdd.dart';
import 'package:aplicationnn/tab/search.dart';
import 'package:aplicationnn/tab/myaskim.dart';
import 'package:aplicationnn/tab/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'chat/chatAll.dart';

class HomeeScreen extends StatefulWidget {
  final int? currentIndex;
  const HomeeScreen({Key? key, this.currentIndex}) : super(key: key);

  @override
  State<HomeeScreen> createState() => _HomeeScreenState();
}

class _HomeeScreenState extends State<HomeeScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TabController? tabController;
  int? currentIndex = 0;
  @override
  void initState() {
    if (widget.currentIndex != null) {
      if (mounted) {
        setState(() {
          currentIndex = widget.currentIndex;
        });
      }
    }
    tabController = TabController(length: 5, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    if (tabController != null) tabController!.dispose();
    super.dispose();
  }

  _onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> screens = [
    const StoreScreen(),
    const SearchScreen(),
    const ChatAll(),
    const AskimScreen()
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // İkonun arkasındaki renk
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(153, 51, 69, 82), // Gölge rengi
                spreadRadius: 1.0, // Gölge yayılma miktarı
                blurRadius: 10.0, // Gölgenin bulanıklık miktarı
                offset: Offset(0, 3), // Gölgenin yönü (x, y)
              ),
            ],
          ),
          child: const Icon(
            Icons.home,
            size: 25,
            weight: 10,
          ),
        ),
        label: AppLocalizations.of(context)!.home,
      ),
      BottomNavigationBarItem(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // İkonun arkasındaki renk
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(
                    153, 51, 69, 82), // Gölge rengi// Gölge rengi
                spreadRadius: 1.0, // Gölge yayılma miktarı
                blurRadius: 10.0, // Gölgenin bulanıklık miktarı
                offset: Offset(0, 3), // Gölgenin yönü (x, y)
              ),
            ],
          ),
          child: const Icon(
            Icons.search,
            size: 25,
            weight: 10,
          ),
        ),
        label: AppLocalizations.of(context)!.search,
      ),
      BottomNavigationBarItem(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // İkonun arkasındaki renk
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(153, 51, 69, 82), // Gölge rengi
                spreadRadius: 1.0, // Gölge yayılma miktarı
                blurRadius: 10.0, // Gölgenin bulanıklık miktarı
                offset: Offset(0, 3), // Gölgenin yönü (x, y)
              ),
            ],
          ),
          child: const Icon(
            Icons.chat,
            size: 25,
            weight: 10,
          ),
        ),
        label: AppLocalizations.of(context)!.onMyHanger,
      ),
      BottomNavigationBarItem(
        icon: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              // İkonun arkasındaki renk
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(153, 51, 69, 82), // Gölge rengi
                  spreadRadius: 1.0, // Gölge yayılma miktarı
                  blurRadius: 10.0, // Gölgenin bulanıklık miktarı
                  offset: Offset(0, 3), // Gölgenin yönü (x, y)
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 25,
              weight: 10,
            )),
        label: AppLocalizations.of(context)!.onMyHanger,
      )
    ];
    return Scaffold(
      body: screens[currentIndex!],
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueGrey.withOpacity(0.5),
        child: InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProductAdd()));
            },
            child: Icon(
              Icons.add,
              color: Color(
                0xff2b2e83,
              ),
              size: 50,
              weight: 10,
            )),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black),
        height: 80,
        child: BottomAppBar(
          notchMargin: 20,
          clipBehavior: Clip.antiAlias,
          shape:
              CircularNotchedRectangle(), // ← carves notch for FAB in BottomAppBar
          color: Colors.black,
          child: BottomNavigationBar(
            showSelectedLabels: false, // <-- HERE
            showUnselectedLabels: false,
            backgroundColor: Color.fromARGB(153, 51, 69, 82),
            elevation: 1,
            currentIndex: currentIndex!,
            selectedItemColor: Color(0xffffffff),
            unselectedItemColor: Color(0xffffffff),
            type: BottomNavigationBarType.fixed,
            onTap: _onTapped,
            items: items,
          ),
        ),
      ),
    );
  }
}
/* DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              backgroundColor: Color.fromARGB(255, 85, 53, 231),
              toolbarHeight: 10,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Align(
                  alignment: Alignment.centerLeft, // tabları başta ortalama
                  child: TabBar(
                      labelPadding: const EdgeInsets.only(
                          left: 3, right: 3), // labeller arası paddng özelliği
                      isScrollable: true,
                      indicatorSize:
                          TabBarIndicatorSize.label, // label genişliği
                      indicatorPadding: const EdgeInsets.only(
                        top: 10,
                      ), // tıklanadıgında ki boyut
                      indicator: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          color: Colors.white),
                      onTap: (index) {
                        setState(() {
                          // ilk çalışacak yer
                        });
                      },
                      tabs: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 60,
                              child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: textHeader("Çoçuk", context)),
                                  textHeader("Kliniği", context)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                          ),
                          child: Tab(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              height: 40,
                              width: 60,
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: textHeaderTwo("E-Ticaret", context)),
                            ),
                          ),
                        )
                      ]),
                ),
              )),
          body: const TabBarView(
            children: [Home(), Commerce()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 1,
            currentIndex: currentIndex!,
            type: BottomNavigationBarType.fixed,
            onTap: _onTapped,
            items: items,
          ),
        ));*/
