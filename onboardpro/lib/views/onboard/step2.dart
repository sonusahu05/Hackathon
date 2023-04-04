import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
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
  final _textRecognizer = TextRecognizer();
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
      _nameData = widgetConcession.name;
      _surname = widgetConcession.surname;
      _address = widgetConcession.address;
      _dob = widgetConcession.dob;
      _gender = widgetConcession.gender;
      _mobileVerify = widgetConcession.mobileVerified;
      _faceVerify = widgetConcession.faceVerified;
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
    _textRecognizer.close();
  }

  _getSimilarity(String str1, String str2) {
    final similarity = str1.similarityTo(str2);
    return similarity;
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
          'Step 2 Document Verification',
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
                            "$_nameData $_surname $_docVerify $_imgUrl",
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
                            _address,
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
                            _dob,
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
                            _gender,
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
                            _mobilenumber,
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
                            _emailData,
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
                                height: 50,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
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
                                  final inputImage = InputImage.fromFile(
                                      File(_imageFile!.path));
                                  final recognisedText = await _textRecognizer
                                      .processImage(inputImage);
                                  String text2 =
                                      recognisedText.text.replaceAll('\n', ' ');

                                  final text = text2.toLowerCase();

                                  final splitText =
                                      text.split(RegExp(r'[ .,\/\\-]'));
                                  final List<String> words = splitText.toList();

                                  // Compute percentage of matching words
                                  final name = _nameData.toLowerCase();
                                  final surname = _surname.toLowerCase();
                                  final address = _address.toLowerCase();
                                  final dob = _dob.toLowerCase();
                                  final gender = _gender.toLowerCase();
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

                                  if (percentage > 60) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Verified Successfully Match percentage is ${percentage.toStringAsFixed(2)}%"),
                                    ));
                                    setState(() {
                                      _docVerify = "true";
                                      _imgUrl = _imageUrl;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          "Not Verified percentage is ${percentage.toStringAsFixed(2)}%"),
                                    ));
                                    setState(() {});
                                  }

                                  if (_docVerify == "true") {
                                    _docVerify = "true";
                                    _saveConcessionIfTextNotEmpty();
                                    Navigator.pop(context);
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
                                    'Apply',
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
