import 'dart:convert';
import 'dart:ffi';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:govt_documents_validator/govt_documents_validator.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_cloud_onboard_storage.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_storage.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:string_similarity/string_similarity.dart';

class Good extends StatefulWidget {
  const Good({super.key});

  @override
  State<Good> createState() => _GoodState();
}

class _GoodState extends State<Good> {
  bool textScanning = false;
  late String _imageUrl;
  File? _imageFile;
  String scannedText = "";
  // final _textRecognizer = TextRecognizer();
  String _idNum = "";
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
  String _nameData2 = "";
  String _surname2 = "";
  late DateTime dateTime;
  late DateTime lastDate;
  CloudOnboard? _concession;
  late final FirebaseCloudStorageOnboard _concessionService;
  Future<void> getExistingOnboard(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudOnboard>();
    _concession = widgetConcession;

    if (widgetConcession != null) {
      _emailData = widgetConcession.email;
      _mobilenumber = widgetConcession.mobileNumber;
      _surname = widgetConcession.surname;
      _address = widgetConcession.address;
      _dob = widgetConcession.dob;
      _gender = widgetConcession.gender;
      _docVerify = widgetConcession.docVerified;
      _mobileVerify = widgetConcession.mobileVerified;
      _faceVerify = widgetConcession.faceVerified;
      _imgUrl = widgetConcession.imageUrl;
      _nameData = widgetConcession.name;
      final keyBytes2 = base64.decode(widgetConcession.key);
      final ivBytes2 = base64.decode(widgetConcession.iv);
      _idNum = widgetConcession.idNum;
      final key2 = encrypt.Key(keyBytes2);
      final iv2 = encrypt.IV(ivBytes2);
      final encrypter2 = encrypt.Encrypter(encrypt.AES(key2));
      _nameData2 = encrypter2.decrypt64(widgetConcession.name, iv: iv2);
      _surname2 = encrypter2.decrypt64(widgetConcession.surname, iv: iv2);
    }
    print(_nameData);
  }

  @override
  void initState() {
    super.initState();
    _concessionService = FirebaseCloudStorageOnboard();
  }

  @override
  void dispose() {
    super.dispose();
    // _textRecognizer.close();
  }

  _getSimilarity(String str1, String str2) {
    final similarity = str1.similarityTo(str2);
    return similarity;
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      await _concessionService.updateOnboard(
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

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      backgroundColor: Colors.white,
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
          'Welcome to OnboardPro!',
          style: TextStyle(
            color: Color(0xff2af6ff),
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getExistingOnboard(context),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              "Hello $_nameData2 $_surname2",
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "Good to have you onboard",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      );

                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
