import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:onboardpro/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_cloud_onboard_storage.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'package:http/http.dart' as http;

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  String _nameData = "";
  String _emailData = "";
  String _surname = "";
  String _mobilenumber = "";
  String _gender = "";
  String _address = "";
  String _docVerify = "false";
  String _imgUrl = "";
  String _dob = "";
  String _mobileVerify = "";
  String _faceVerify = "";
  String _mob = "";
  String _idNum = "";
  late final FirebaseCloudStorageOnboard _onboardingService;
  CloudOnboard? _concession;

  Future<http.Response> postRequest(String email) async {
    var url = 'https://proud-will-380104.el.r.appspot.com/phone';
    Map data = {'email': email};
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed(verify);
    if (!mounted) return;
    if (result == true) {
      _mobileVerify = "true";
      _saveConcessionIfTextNotEmpty();
      postRequest(_emailData);
      Navigator.of(context).pop(true);
    }
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      await _onboardingService.updateOnboard(
        documentOnboardId: concession.documentOnboardId,
        email: _emailData,
        name: _nameData,
        surname: _surname,
        mobileNumber: _mob,
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

  Future<void> getExistingOnboard(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudOnboard>();
    _concession = widgetConcession;

    if (widgetConcession != null) {
      _emailData = widgetConcession.email;
      _nameData = widgetConcession.name;
      _surname = widgetConcession.surname;
      _address = widgetConcession.address;
      _dob = widgetConcession.dob;
      _mob = widgetConcession.mobileNumber;
      _gender = widgetConcession.gender;
      _mobileVerify = widgetConcession.mobileVerified;
      _faceVerify = widgetConcession.faceVerified;
      _idNum = widgetConcession.idNum;
      final keyBytes2 = base64.decode(widgetConcession.key);
      final ivBytes2 = base64.decode(widgetConcession.iv);

      final key2 = encrypt.Key(keyBytes2);
      final iv2 = encrypt.IV(ivBytes2);
      final encrypter2 = encrypt.Encrypter(encrypt.AES(key2));
      _mobilenumber =
          encrypter2.decrypt64(widgetConcession.mobileNumber, iv: iv2);
    }
  }

  @override
  void initState() {
    _onboardingService = FirebaseCloudStorageOnboard();

    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getExistingOnboard(context),
            builder: ((context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon/img1.png',
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const Text(
                        "Phone Verification",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "We need to register your phone without getting started!",
                        style: TextStyle(
                            fontSize: 16, backgroundColor: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: countryController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const Text(
                              "|",
                              style: TextStyle(
                                  fontSize: 33,
                                  color: Colors.grey,
                                  backgroundColor: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(child: Text(_mobilenumber)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            onPressed: () async {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber:
                                    countryController.text + _mobilenumber,
                                verificationCompleted:
                                    (PhoneAuthCredential credential) {},
                                verificationFailed:
                                    (FirebaseAuthException e) {},
                                codeSent:
                                    (String verificationId, int? resendToken) {
                                  MyPhone.verify = verificationId;
                                  _navigateAndDisplaySelection(context);
                                },
                                codeAutoRetrievalTimeout:
                                    (String verificationId) {},
                              );
                            },
                            child: const Text("Send the code")),
                      )
                    ],
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }),
          ),
        ),
      ),
    );
  }
}
