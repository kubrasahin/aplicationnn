import 'package:aplicationnn/screens/auth/register.dart';
import 'package:aplicationnn/screens/auth/registerInstitutional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabControllerrr extends StatefulWidget {
  const TabControllerrr({super.key});

  @override
  State<TabControllerrr> createState() => _TabControllerrrState();
}

class _TabControllerrrState extends State<TabControllerrr>
    with SingleTickerProviderStateMixin {
  TabController? tabcontroller;

  @override
  void initState() {
    tabcontroller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabcontroller?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    double baseWidth = 390;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Color(0xff030116)),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: 30,),
              Container(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'assets/askida.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: Container(
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 48, 11, 151),
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TabBar(
                          labelStyle: TextStyle(fontSize: 18),
                          unselectedLabelColor: Colors.white,
                          labelColor: Colors.black,
                          indicatorColor: Colors.white,
                          indicatorWeight: 2,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          controller: tabcontroller,
                          tabs: [
                            Tab(
                              text: AppLocalizations.of(context)!.individual,
                            ),
                            Tab(
                              text: AppLocalizations.of(context)!.institutional,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabcontroller,
                  children: [
                    RegisterScreen(),
                    KurumsalUser(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
