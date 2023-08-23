import 'package:aplicationnn/screens/admin/adminStogre.dart';
import 'package:aplicationnn/screens/admin/users/newUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminHomeeScreen extends StatefulWidget {
  final int? currentIndex;
  const AdminHomeeScreen({Key? key, this.currentIndex}) : super(key: key);

  @override
  State<AdminHomeeScreen> createState() => _AdminHomeeScreenState();
}

class _AdminHomeeScreenState extends State<AdminHomeeScreen>
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
    const AdminStoreScreen(),
    const AddUserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.dry_cleaning),
        label: AppLocalizations.of(context)!.home,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: AppLocalizations.of(context)!.registeredInstitutions,
      ),
    ];
    return Scaffold(
      body: screens[currentIndex!],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        currentIndex: currentIndex!,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.7),
        type: BottomNavigationBarType.fixed,
        onTap: _onTapped,
        items: items,
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