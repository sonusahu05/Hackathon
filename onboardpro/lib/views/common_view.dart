import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/enums/menu_action.dart';
import 'package:onboardpro/services/auth/bloc/auth_bloc.dart';
import 'package:onboardpro/services/auth/bloc/auth_event.dart';
import 'package:onboardpro/utilities/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'profile/profile.dart';

class CommonView extends StatefulWidget {
  const CommonView({super.key});

  @override
  State<CommonView> createState() => _CommonViewState();
}

class _CommonViewState extends State<CommonView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingActionButton(
          elevation: 0, backgroundColor: Colors.transparent, onPressed: null),
      backgroundColor: const Color(0xffe7edf2),
      appBar: AppBar(
        backgroundColor: const Color(0xff15001C),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (!mounted) return;
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ];
            },
          )
        ],
        toolbarHeight: 180,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          height: 210,
          padding: const EdgeInsets.only(
            left: 31.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,',
                style: GoogleFonts.jost(
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Welcome to EKYC Portal',
                style: GoogleFonts.dmSans(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            // gradient
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xff15001c),
                  Color(0xff6100ff),
                ],
              ),
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Add Details for eKYC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )),
                        const SizedBox(
                          height: 14,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              onboarding,
                              (route) => true,
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 70,
                            decoration: BoxDecoration(
                              color: const Color(0xffff8c00),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Apply',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/icon/form.png',
                    height: 90,
                    width: 90,
                  ),
                ]),
          ),
          const SizedBox(
            height: 17,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 27.0, bottom: 8, top: 3),
            child: Text('    Complete this steps to Onboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffe4eaef),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffabc2d4),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 0.0,
                          blurRadius: 5.0,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    // height: 100,
                    // width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Image.asset(
                            'assets/images/icon/events3.png',
                            height: 60,
                            width: 60,
                            scale: 0.7,
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('  Step 1',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 2,
                                ),
                                
                              ],
                            ),
                            
                            const Text('Phone Verification',
                                style: TextStyle(
                                  color: Color(0xff656565),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                )),
                                
                          ],
                        ),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffe4eaef),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffabc2d4),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 0.0,
                          blurRadius: 5.0,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    // height: 100,
                    // width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Image.asset('assets/images/icon/notes.png',
                              height: 60, width: 60),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('  Step 2',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 2,
                                ),
                              
                              ],
                            ),
                            const Text('Document Upload and verification',
                                style: TextStyle(
                                  color: Color(0xff656565),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffe4eaef),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffabc2d4),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 0.0,
                          blurRadius: 5.0,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Image.asset('assets/images/icon/onboard.png',
                              height: 60, width: 60),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('  Step 3',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 2,
                                ),
                                
                              ],
                            ),
                            const Text('Face Verification',
                                style: TextStyle(
                                  color: Color(0xff656565),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffe4eaef),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffabc2d4),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 0.0,
                          blurRadius: 5.0,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    // height: 100,
                    // width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Image.asset(
                              'assets/images/icon/notifications.png',
                              height: 60,
                              width: 60),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(' Congrats',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    )),
                                SizedBox(
                                  width: 2,
                                ),
                               
                              ],
                            ),
                            const Text('You are now a verified user',
                                style: TextStyle(
                                  color: Color(0xff656565),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ],
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  List<Widget> tabs = [
    const CommonView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(50),
            color: const Color.fromARGB(255, 255, 255, 255),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: SvgPicture.asset(
                  'assets/images/icon/add.svg',
                  color: const Color(0xff15001C),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: tabs[_currentIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(60),
            topLeft: Radius.circular(60),
          ),
          child: BottomAppBar(
            color: const Color(0xff15001C),
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            child: SizedBox(
              height: kBottomNavigationBarHeight + 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    icon: CircleAvatar(
                      backgroundColor: _currentIndex == 0
                          ? const Color.fromARGB(71, 163, 163, 221)
                          : Colors.transparent,
                      child:
                          const Icon(Icons.home_outlined, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 32,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    icon: CircleAvatar(
                      backgroundColor: _currentIndex == 1
                          ? const Color.fromARGB(71, 163, 163, 221)
                          : Colors.transparent,
                      child: const Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
