import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_cloud_onboard_storage.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OnboardingSteps extends StatefulWidget {
  const OnboardingSteps({super.key});

  @override
  State<OnboardingSteps> createState() => _OnboardingStepsState();
}

class _OnboardingStepsState extends State<OnboardingSteps> {
  late final FirebaseCloudStorageOnboard _onboardingService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;
  String _nameData = "";
  String _emailData = "";
  String _surname = "";
  String _mobilenumber = "";
  String _gender = "";
  String _address = "";
  String _docVerify = "";
  String _imgUrl = "";
  String _dob = "";
  String _mobileVerify = "";
  String _faceVerify = "";
  String _idNum = "";
  CloudOnboard? _concession;
  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      await _onboardingService.updateOnboard(
        documentOnboardId: concession.documentOnboardId,
        email: _emailData,
        name: _nameData,
        surname: _surname,
        mobileNumber: _mobilenumber,
        dob: _dob,
        address: _address,
        docVerified: _docVerify,
        imageUrl: _imgUrl,
        gender: _gender,
        mobileVerified: _mobileVerify,
        faceVerified: _faceVerify,
        idNum: _idNum,
      );
    }
  }

  Future<void> _navigateAndDisplaySelection1(
      BuildContext context, CloudOnboard concession) async {
    final result = await Navigator.of(context).pushNamed(
      eventView,
      arguments: concession,
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.pop(context);
    }
  }

  Future<void> _navigateAndDisplaySelection2(
      BuildContext context, CloudOnboard concession) async {
    final result = await Navigator.of(context).pushNamed(
      step2,
      arguments: concession,
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.pop(context);
    }
  }

  Future<void> _navigateAndDisplaySelection3(
      BuildContext context, CloudOnboard concession) async {
    // final result = await Navigator.of(context).pushNamed(
    //   step3,
    //   arguments: concession,
    // );
    final result = await Navigator.of(context).pushNamed(
      face,
      arguments: concession,
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.pop(context);
    }
  }

  Future<void> _navigateAndDisplaySelection4(
      BuildContext context, CloudOnboard concession) async {
    postRequest(_emailData);
    final result = await Navigator.of(context).pushNamed(
      good,
      arguments: concession,
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.pop(context);
    }
  }

  Future<http.Response> postRequest(String email) async {
    var url = 'https://proud-will-380104.el.r.appspot.com/onboard';
    Map data = {'email': email};
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<void> getExistingOnboard(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudOnboard>();
    _concession = widgetConcession;
    if (widgetConcession != null) {
      _emailData = widgetConcession.email;
      _mobilenumber = widgetConcession.mobileNumber;
      _nameData = widgetConcession.name;
      _surname = widgetConcession.surname;
      _address = widgetConcession.address;
      _dob = widgetConcession.dob;
      _gender = widgetConcession.gender;
      _mobileVerify = widgetConcession.mobileVerified;
      _faceVerify = widgetConcession.faceVerified;
      _docVerify = widgetConcession.docVerified;
      _imgUrl = widgetConcession.imageUrl;
    }
  }

  @override
  void initState() {
    _onboardingService = FirebaseCloudStorageOnboard();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getExistingOnboard(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xfff1f4f8),
        appBar: AppBar(
          backgroundColor: const Color(0xff15001C),
          toolbarHeight: 115,
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          title: const Text(
            'Onboarding Steps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(
              left: 31.0,
            ),
          ),
        ),
        body: FutureBuilder(
          future: getExistingOnboard(context),
          builder: ((context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 27.0, bottom: 8, top: 20),
                      child: Text('Complete this steps to Onboard',
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
                          onTap: () {
                            if (_docVerify == "false" &&
                                _mobileVerify == "false" &&
                                _faceVerify == "false") {
                              _navigateAndDisplaySelection1(
                                  context, _concession!);
                            }
                          },
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
                                children: <Widget>[
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (_mobileVerify == "true")
                                    Center(
                                      child: Image.asset(
                                        'assets/images/icon/done.png',
                                        height: 60,
                                        width: 60,
                                        scale: 0.7,
                                      ),
                                    ),
                                  if (_mobileVerify == "false")
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('Step 1',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 19,
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
                          onTap: () {
                            if (_docVerify == "false" &&
                                _mobileVerify == "true" &&
                                _faceVerify == "false") {
                              _navigateAndDisplaySelection2(
                                  context, _concession!);
                            }
                          },
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
                                children: <Widget>[
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (_docVerify == "true")
                                    Center(
                                      child: Image.asset(
                                        'assets/images/icon/done.png',
                                        height: 60,
                                        width: 60,
                                        scale: 0.7,
                                      ),
                                    ),
                                  if (_docVerify == "false")
                                    Center(
                                      child: Image.asset(
                                          'assets/images/icon/notes.png',
                                          height: 60,
                                          width: 60),
                                    ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('Step 2',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 19,
                                          ),
                                        ],
                                      ),
                                      const Text('Document verification',
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
                          onTap: () {
                            if (_docVerify == "true" &&
                                _mobileVerify == "true" &&
                                _faceVerify == "false") {
                              _navigateAndDisplaySelection3(
                                  context, _concession!);
                            }
                          },
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
                                children: <Widget>[
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  if (_faceVerify == "true")
                                    Center(
                                      child: Image.asset(
                                        'assets/images/icon/done.png',
                                        height: 60,
                                        width: 60,
                                        scale: 0.7,
                                      ),
                                    ),
                                  if (_faceVerify == "false")
                                    Center(
                                      child: Image.asset(
                                          'assets/images/icon/onboard.png',
                                          height: 60,
                                          width: 60),
                                    ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('Step 3',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 19,
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
                          onTap: () {
                            if (_docVerify == "true" &&
                                _mobileVerify == "true" &&
                                _faceVerify == "true") {
                              _saveConcessionIfTextNotEmpty();
                              _navigateAndDisplaySelection4(
                                  context, _concession!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please complete all steps'),
                                ),
                              );
                            }
                          },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text('Congrats',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              )),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            size: 19,
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
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
        ));
  }
}
