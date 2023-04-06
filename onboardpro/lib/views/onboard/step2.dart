import 'dart:convert';
import 'package:http/http.dart' as http;
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

class Step2 extends StatefulWidget {
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
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
  String _docVerify = "false";
  String _imgUrl = "";
  String _dob = "";
  String _mobileVerify = "";
  String _faceVerify = "";
  String _mobilenumber2 = "";
  String _nameData2 = "";
  String _surname2 = "";
  String _address2 = "";
  String _gender2 = "";
  String _dob2 = "";
  String _idType = "";
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

      _mobileVerify = widgetConcession.mobileVerified;
      _faceVerify = widgetConcession.faceVerified;

      _nameData = widgetConcession.name;
      final keyBytes2 = base64.decode(widgetConcession.key);
      final ivBytes2 = base64.decode(widgetConcession.iv);

      final key2 = encrypt.Key(keyBytes2);
      final iv2 = encrypt.IV(ivBytes2);
      final encrypter2 = encrypt.Encrypter(encrypt.AES(key2));
      _idNum = encrypter2.decrypt64(widgetConcession.idNum, iv: iv2);
      _mobilenumber2 =
          encrypter2.decrypt64(widgetConcession.mobileNumber, iv: iv2);
      _nameData2 = encrypter2.decrypt64(widgetConcession.name, iv: iv2);
      _surname2 = encrypter2.decrypt64(widgetConcession.surname, iv: iv2);
      _address2 = encrypter2.decrypt64(widgetConcession.address, iv: iv2);
      _dob2 = encrypter2.decrypt64(widgetConcession.dob, iv: iv2);
      _gender2 = encrypter2.decrypt64(widgetConcession.gender, iv: iv2);
    }
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

  Future<http.Response> postRequest(String email) async {
    var url = 'https://proud-will-380104.el.r.appspot.com/doc';
    Map data = {'email': email};
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      print(_docVerify);
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
          'Document Verification',
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
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Name: $_nameData2 $_surname2",
                            style: const TextStyle(
                              color: Color(0xff1e1e1e),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Address : $_address2",
                            style: const TextStyle(
                              color: Color(0xff1e1e1e),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Date of Birth : $_dob2",
                            style: const TextStyle(
                              color: Color(0xff343434),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Gender : $_gender2",
                            style: const TextStyle(
                              color: Color(0xff343434),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "ID : $_idNum",
                            style: const TextStyle(
                              color: Color(0xff343434),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Mobile Number : $_mobilenumber2",
                            style: const TextStyle(
                              color: Color(0xff343434),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Email : $_emailData",
                            style: const TextStyle(
                              color: Color(0xff343434),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Select document type ",
                            style: TextStyle(
                              color: Color(0xff343434),
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _idType = "Aadhar";
                                  });
                                },
                                child: Row(
                                  children: [
                                    _idType == "Aadhar"
                                        ? SvgPicture.asset(
                                            'assets/images/icon/checked.svg',
                                            width: 17,
                                            height: 17,
                                          )
                                        : Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: const Color(0xff000028),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Aadhar',
                                      style: TextStyle(
                                        color: Color(0xff311b61),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _idType = "Pancard";
                                  });
                                },
                                child: Row(
                                  children: [
                                    _idType == "Pancard"
                                        ? SvgPicture.asset(
                                            'assets/images/icon/checked.svg',
                                            width: 17,
                                            height: 17,
                                          )
                                        : Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: const Color(0xff000028),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Pancard',
                                      style: TextStyle(
                                        color: Color(0xff311b61),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _idType = "Other";
                                  });
                                },
                                child: Row(
                                  children: [
                                    _idType == "Other"
                                        ? SvgPicture.asset(
                                            'assets/images/icon/checked.svg',
                                            width: 17,
                                            height: 17,
                                          )
                                        : Container(
                                            width: 17,
                                            height: 17,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                color: const Color(0xff000028),
                                                width: 1,
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Other',
                                      style: TextStyle(
                                        color: Color(0xff311b61),
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 50,
                              right: 50,
                            ),
                            child: Container(
                              height: 200, // Set the height of the container.
                              width: 200, // Set the width of the container.
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    15), // Add a border radius to the container.
                                color: Colors.grey[
                                    300], // Add a background color to the container.
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          15), // Add a border radius to the image.
                                      child: Image(
                                        image: FileImage(_imageFile!),
                                        fit: BoxFit
                                            .cover, // Add a fit property to the image to make it cover the container.
                                      ),
                                    )
                                  : Center(
                                      child: Text(
                                        'No image selected', // Add a message to display if no image is selected.
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          // Show nothing if no image is selected.
                          const SizedBox(
                            height: 16,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 100,
                              right: 100,
                            ),
                            child: InkWell(
                              splashColor:
                                  const Color.fromARGB(255, 134, 146, 224),
                              onTap: (() async {
                                final results =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowMultiple: false,
                                  allowCompression: true,
                                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                                );

                                if (results == null) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("No File has been picked"),
                                  ));
                                  return;
                                } else {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Image Uploaded"),
                                  ));
                                }
                                final newName = Timestamp.now();
                                final path = results.files.single.path!;
                                final fileName = newName.toString();
                                _imageUrl = fileName;
                                storage.uploadFile(path, fileName);

                                setState(() {
                                  _imageFile = File(path);
                                  // Set the image file to the selected file.
                                });
                              }),
                              child: Container(
                                alignment: Alignment.center,
                                height: 45,
                                width: 145,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xff000028),
                                ),
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                onPressed: (() async {
                                  AadharValidator aadharValidator =
                                      AadharValidator();
                                  PANValidator pancardValidator =
                                      PANValidator();
                                  late final isAadharNum;
                                  late final isPancardNum;
                                  if (_idType == "Pancard") {
                                    isPancardNum =
                                        pancardValidator.validate(_idNum);
                                  } else if (_idType == "Aadhar") {
                                    isAadharNum =
                                        aadharValidator.validate(_idNum);
                                  }

                                  if (_idType == "Aadhar") {
                                    FirebaseVisionImage visionImage =
                                        FirebaseVisionImage.fromFile(
                                            File(_imageFile!.path));

                                    FirebaseVision firebaseVision =
                                        FirebaseVision.instance;

                                    TextRecognizer textRecognizer =
                                        firebaseVision.textRecognizer();
                                    VisionText visionText = await textRecognizer
                                        .processImage(visionImage);
                                    String recognizedText = visionText.text;
                                    // List<TextBlock> blocks = visionText.blocks;
                                    // print(recognizedText);
                                    // print(blocks);

                                    String text2 =
                                        recognizedText.replaceAll('\n', ' ');

                                    final text = text2.toLowerCase();

                                    final splitText =
                                        text.split(RegExp(r'[ .,\/\\-]'));
                                    final List<String> words =
                                        splitText.toList();

                                    // Compute percentage of matching words
                                    final name = _nameData2.toLowerCase();
                                    final surname = _surname2.toLowerCase();
                                    final address = _address2.toLowerCase();
                                    final dob = _dob2.toLowerCase();
                                    final gender = _gender2.toLowerCase();
                                    final str =
                                        "$name $surname $address $dob $gender";
                                    final splitText2 =
                                        str.split(RegExp(r'[ .,\/\\-]'));
                                    final List<String> words2 =
                                        splitText2.toList();
                                    print(words2);
                                    print(words);
                                    double totalSimilarity = 0;
                                    bool check = false;

                                    for (String word2 in words2) {
                                      double maxSimilarity = 0;
                                      for (String word in words) {
                                        final double similarity =
                                            _getSimilarity(word2, word);
                                        if (word
                                            .contains(_idNum.toLowerCase())) {
                                          check = true;
                                        }
                                        if (similarity > maxSimilarity) {
                                          maxSimilarity = similarity;
                                        }
                                      }
                                      totalSimilarity += maxSimilarity;
                                    }
                                    final double percentage =
                                        (totalSimilarity / words2.length) * 100;

                                    if (percentage > 75 &&
                                        words.isNotEmpty &&
                                        words2.isNotEmpty &&
                                        isAadharNum == true &&
                                        check == true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Verified Successfully Match percentage is ${percentage.toStringAsFixed(2)}%"),
                                      ));
                                      setState(() {
                                        _docVerify = "true";
                                        _imgUrl = _imageUrl;
                                      });
                                    } else if (words.isEmpty ||
                                        words2.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("No text found 0% "),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Not Verified percentage is ${percentage.toStringAsFixed(2)}%"),
                                      ));
                                    }

                                    if (_docVerify == "true") {
                                      _saveConcessionIfTextNotEmpty();
                                      postRequest(_emailData);
                                      Navigator.of(context).pop(true);
                                      ;
                                    }
                                  } else if (_idType == "Pancard") {
                                    FirebaseVisionImage visionImage =
                                        FirebaseVisionImage.fromFile(
                                            File(_imageFile!.path));

                                    FirebaseVision firebaseVision =
                                        FirebaseVision.instance;

                                    TextRecognizer textRecognizer =
                                        firebaseVision.textRecognizer();
                                    VisionText visionText = await textRecognizer
                                        .processImage(visionImage);
                                    String recognizedText = visionText.text;
                                    // List<TextBlock> blocks = visionText.blocks;
                                    // print(recognizedText);
                                    // print(blocks);

                                    String text2 =
                                        recognizedText.replaceAll('\n', ' ');

                                    final text = text2.toLowerCase();

                                    final splitText =
                                        text.split(RegExp(r'[ .,\/\\-]'));
                                    final List<String> words =
                                        splitText.toList();

                                    // Compute percentage of matching words
                                    final name = _nameData2.toLowerCase();
                                    final surname = _surname2.toLowerCase();
                                    final address = _address2.toLowerCase();
                                    final dob = _dob2.toLowerCase();
                                    final gender = _gender2.toLowerCase();
                                    final str =
                                        "$name $surname $address $dob $gender";
                                    final splitText2 =
                                        str.split(RegExp(r'[ .,\/\\-]'));
                                    final List<String> words2 =
                                        splitText2.toList();
                                    print(words2);
                                    print(words);
                                    double totalSimilarity = 0;
                                    bool check = false;
                                    for (String word2 in words2) {
                                      double maxSimilarity = 0;
                                      for (String word in words) {
                                        final double similarity =
                                            _getSimilarity(word2, word);
                                        if (word
                                            .contains(_idNum.toLowerCase())) {
                                          check = true;
                                        }
                                        if (similarity > maxSimilarity) {
                                          maxSimilarity = similarity;
                                        }
                                      }
                                      totalSimilarity += maxSimilarity;
                                    }
                                    final double percentage =
                                        (totalSimilarity / words2.length) * 100;

                                    if (percentage > 75 &&
                                        words.isNotEmpty &&
                                        words2.isNotEmpty &&
                                        isPancardNum == true &&
                                        check == true) {
                                      print(isPancardNum);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Verified Successfully Match percentage is ${percentage.toStringAsFixed(2)}%"),
                                      ));
                                      setState(() {
                                        _docVerify = "true";
                                        _imgUrl = _imageUrl;
                                      });
                                    } else if (words.isEmpty ||
                                        words2.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("No text found 0% "),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Not Verified percentage is ${percentage.toStringAsFixed(2)}%"),
                                      ));
                                    }

                                    if (_docVerify == "true") {
                                      _saveConcessionIfTextNotEmpty();
                                      postRequest(_emailData);
                                      Navigator.of(context).pop(true);
                                      
                                    }
                                  } else {
                                    FirebaseVisionImage visionImage =
                                        FirebaseVisionImage.fromFile(
                                            File(_imageFile!.path));

                                    FirebaseVision firebaseVision =
                                        FirebaseVision.instance;

                                    TextRecognizer textRecognizer =
                                        firebaseVision.textRecognizer();
                                    VisionText visionText = await textRecognizer
                                        .processImage(visionImage);
                                    String recognizedText = visionText.text;
                                    // List<TextBlock> blocks = visionText.blocks;
                                    // print(recognizedText);
                                    // print(blocks);

                                    String text2 =
                                        recognizedText.replaceAll('\n', ' ');

                                    final text = text2.toLowerCase();

                                    final splitText =
                                        text.split(RegExp(r'[ .,\/\\-]'));
                                    final List<String> words =
                                        splitText.toList();

                                    // Compute percentage of matching words
                                    final name = _nameData2.toLowerCase();
                                    final surname = _surname2.toLowerCase();
                                    final address = _address2.toLowerCase();
                                    final dob = _dob2.toLowerCase();
                                    final gender = _gender2.toLowerCase();
                                    final str =
                                        "$name $surname $address $dob $gender";
                                    final splitText2 =
                                        str.split(RegExp(r'[ .,\/\\-]'));
                                    final List<String> words2 =
                                        splitText2.toList();
                                    double totalSimilarity = 0;
                                    for (String word2 in words2) {
                                      double maxSimilarity = 0;
                                      for (String word in words) {
                                        final double similarity =
                                            _getSimilarity(word2, word);
                                        if (similarity > maxSimilarity) {
                                          maxSimilarity = similarity;
                                        }
                                      }
                                      totalSimilarity += maxSimilarity;
                                    }
                                    final double percentage =
                                        (totalSimilarity / words2.length) * 100;

                                    if (percentage > 75 &&
                                        words.isNotEmpty &&
                                        words2.isNotEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Verified Successfully Match percentage is ${percentage.toStringAsFixed(2)}%"),
                                      ));
                                      setState(() {
                                        _docVerify = "true";
                                        _imgUrl = _imageUrl;
                                      });
                                    } else if (words.isEmpty ||
                                        words2.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("No text found 0% "),
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            "Not Verified percentage is ${percentage.toStringAsFixed(2)}%"),
                                      ));
                                    }

                                    if (_docVerify == "true") {
                                      _saveConcessionIfTextNotEmpty();
                                      postRequest(_emailData);
                                      Navigator.of(context).pop(true);
                                    }
                                  }
                                }),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff000028),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: const Text(
                                    'Verify',
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                        ],
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
