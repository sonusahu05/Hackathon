import 'dart:convert';
import 'dart:ffi';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:image_picker/image_picker.dart';
import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_cloud_onboard_storage.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_storage.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';

class FaceIO extends StatefulWidget {
  const FaceIO({super.key});

  @override
  State<FaceIO> createState() => _FaceIOState();
}

class _FaceIOState extends State<FaceIO> {
  var image1 = Regula.MatchFacesImage();
  var image2 = Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/portrait.png');
  var img2 = Image.asset('assets/images/portrait.png');
  String _similarity = "No data";
  String _liveness = "No data";
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
  String _faceVerify = "false";
  String _match = "false";
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
      _idNum = widgetConcession.idNum;
      _mobileVerify = widgetConcession.mobileVerified;
      _faceVerify = widgetConcession.faceVerified;
      _docVerify = widgetConcession.docVerified;
      _nameData = widgetConcession.name;
      _imgUrl = widgetConcession.imageUrl;
    }
  }
  Future<http.Response> postRequest(String email) async {
    var url = 'https://proud-will-380104.el.r.appspot.com/face';
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
  void dispose() {
    super.dispose();
    // _textRecognizer.close();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _concessionService = FirebaseCloudStorageOnboard();
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      var response = jsonDecode(event);
      String transactionId = response["transactionId"];
      bool success = response["success"];
      print("video_encoder_completion:");
      print("    success: $success");
      print("    transactionId: $transactionId");
    });
  }

  Future<void> initPlatformState() async {
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        print("Init failed: ");
        print(json);
      }
    });
  }

  showAlertDialog(BuildContext context, bool first) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(title: const Text("Select option"), actions: [
            // ignore: deprecated_member_use
            TextButton(
                child: const Text("Use gallery"),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  ImagePicker()
                      .pickImage(source: ImageSource.gallery)
                      .then((value) => {
                            setImage(
                                first,
                                io.File(value!.path).readAsBytesSync(),
                                Regula.ImageType.PRINTED)
                          });
                }),
            // ignore: deprecated_member_use
            TextButton(
                child: const Text("Use camera"),
                onPressed: () {
                  Regula.FaceSDK.presentFaceCaptureActivity().then((result) =>
                      setImage(
                          first,
                          base64Decode(Regula.FaceCaptureResponse.fromJson(
                                  json.decode(result))!
                              .image!
                              .bitmap!
                              .replaceAll("\n", "")),
                          Regula.ImageType.LIVE));
                  Navigator.pop(context);
                })
          ]));

  setImage(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "No data");
    if (first) {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      setState(() {
        img1 = Image.memory(imageFile);
        _liveness = "No data";
      });
    } else {
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      setState(() => img2 = Image.memory(imageFile));
    }
  }

  clearResults() {
    setState(() {
      img1 = Image.asset('assets/images/portrait.png');
      img2 = Image.asset('assets/images/portrait.png');
      _similarity = "No data";
      _liveness = "No data";
    });
    image1 = Regula.MatchFacesImage();
    image2 = Regula.MatchFacesImage();
  }

  matchFaces() {
    if (image1.bitmap == null ||
        image1.bitmap == "" ||
        image2.bitmap == null ||
        image2.bitmap == "") return;
    setState(() => _similarity = "Processing...");
    var request = Regula.MatchFacesRequest();
    request.images = [image1, image2];
    Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
      var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
      Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response!.results), 0.75)
          .then((str) {
        var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
            json.decode(str));
        var num = split!.matchedFaces.isNotEmpty
            ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}%")
            : "No match";
        if (num == "No match") {
          _match = "No match";
        } else {
          _match = num;
        }
        setState(() => _similarity = split.matchedFaces.isNotEmpty
            ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}%")
            : "No match");
      });
    });
  }

  liveness() => Regula.FaceSDK.startLiveness().then((value) {
        var result = Regula.LivenessResponse.fromJson(json.decode(value));
        setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),
            Regula.ImageType.LIVE);
        setState(() => _liveness =
            result.liveness == Regula.LivenessStatus.PASSED
                ? "passed"
                : "unknown");
      });

  Widget createButton(String text, VoidCallback onPress) => Container(
        // ignore: deprecated_member_use
        child: TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0)),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
            ),
            onPressed: onPress,
            child: Text(text)),
        width: 250,
      );

  Widget createImage(image, VoidCallback onPress) => Material(
          child: InkWell(
        onTap: onPress,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image(height: 150, width: 150, image: image),
        ),
      ));
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
            'Step 3 Face Verification',
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              createImage(img1.image,
                                  () => showAlertDialog(context, true)),
                              createImage(img2.image,
                                  () => showAlertDialog(context, false)),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 15)),
                              createButton("Match", () => matchFaces()),
                              createButton("Liveness", () => liveness()),
                              createButton("Clear", () => clearResults()),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Similarity: $_similarity",
                                          style: const TextStyle(fontSize: 18)),
                                      Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              20, 0, 0, 0)),
                                      Text("Liveness: $_liveness",
                                          style: const TextStyle(fontSize: 18))
                                    ],
                                  ))
                            ]);
                      default:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_match != "false")
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text(
                      "Match: $_match",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 22, 230, 3),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                if (_liveness == "passed")
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text(
                      "Liveness: $_liveness",
                      style: const TextStyle(
                        color: Color(0xff000028),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ElevatedButton(
                  onPressed: (() async {
                    if (double.parse(_match.substring(0, _match.length - 1)) >
                            85.0 &&
                        _liveness == "passed") {
                      _faceVerify = "true";
                      _saveConcessionIfTextNotEmpty();
                      postRequest(_emailData);
                      Navigator.of(context).pop(true);
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
            ))));
  }
}
