import 'package:onboardpro/constants/constants.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/concession/cloud_concession.dart';
import 'package:onboardpro/services/cloud/concession/firebase_cloud_storage_concession.dart';
import 'package:gsheets/gsheets.dart';

class DataStudent extends StatefulWidget {
  const DataStudent({super.key});

  @override
  State<DataStudent> createState() => _DataStudentState();
}

class _DataStudentState extends State<DataStudent> {
  String _nameData = "";
  String _emailData = "";
  String _genderData = "";
  String _nearestStationData = "";
  String _addressData = "";
  String _dobData = "";
  String _classValueData = "";
  String _periodValueData = "";
  String _applicationDateData = "";
  String _applicationSent = "";
  String _applicationCanBeCollected = "";
  String _destinationStationData = "";
  String _mobileNumberData = "";
  String _uidData = "";
  String _casteData = "";
  String _expiryDateData = "";
  String _laneData = "";
  DateTime _date = DateTime.now();
  late DateTime dateTime;
  String _dateString = "";
  late final TextEditingController _newBook;

  static Worksheet? _userSheet;
  static const _credentials = cred;
  static const _spreadsheetId = spreadId;
  static final _gsheets = GSheets(_credentials);

  Future<void> writeToSheet() async {
    final doc = await _gsheets.spreadsheet(_spreadsheetId);
    _userSheet = await _getWorksheet(doc, title: title);
    List<String> headers = [
      "Sr.No.",
      "Sex",
      "Age",
      "Name of the student",
      "Address",
      "Period",
      "From",
      "To",
      "Class",
      "Date of Issue",
      "Date Of Birth",
    ];
    _userSheet!.values.insertRow(1, headers);
  }

  Future insert(List<Map<String, dynamic>> data) async {
    if (_userSheet == null) {
      return;
    }
    _userSheet!.values.map.appendRows(data);
  }

  Future<Worksheet> _getWorksheet(Spreadsheet doc,
      {required String title}) async {
    try {
      return await doc.addWorksheet(title);
    } catch (e) {
      return doc.worksheetByTitle(title)!;
    }
  }

  // final sheet = doc.sheets.values;

  // await sheet.append(values);

  CloudConcession? _concession;
  late final FirebaseCloudStorageConcession _concessionService;

  final currentUser = AuthService.firebase().currentUser!;
  @override
  void initState() {
    _concessionService = FirebaseCloudStorageConcession();
    _newBook = TextEditingController();
    _newBook.text = "";
    writeToSheet();
    super.initState();
  }

  @override
  void dispose() {
    _newBook.dispose();
    super.dispose();
  }

  Future<void> getExistingConcession(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudConcession>();
    _concession = widgetConcession;

    if (widgetConcession != null) {
      _nameData = widgetConcession.name;
      _emailData = widgetConcession.email;
      _genderData = widgetConcession.gender;
      _nearestStationData = widgetConcession.nearestStation;
      _addressData = widgetConcession.address;
      _dobData = widgetConcession.dob;
      _classValueData = widgetConcession.trainClass;
      _periodValueData = widgetConcession.period;
      _applicationDateData = widgetConcession.dateOfApplication;
      _applicationSent = widgetConcession.receivedStatus;
      _applicationCanBeCollected = widgetConcession.completedStatus;
      _destinationStationData = widgetConcession.destinationStation;
      _mobileNumberData = widgetConcession.mobileNumber;
      _uidData = widgetConcession.uid;
      _casteData = widgetConcession.caste;
      _expiryDateData = widgetConcession.expiryDate;
      _laneData = widgetConcession.lane;
    }
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null) {
      await _concessionService.updateConcession(
        documentConcessionId: concession.documentConcessionId,
        trainClass: _classValueData,
        period: _periodValueData,
        dateOfApplication: _applicationDateData,
        receivedStatus: _applicationSent,
        completedStatus: _applicationCanBeCollected,
        expiryDate: _expiryDateData,
        lane: _laneData,
      );
    }
  }

  String _calcDate() {
    var dateDivide = _dobData.split("/");
    if (dateDivide[1].length == 1) {
      dateDivide[1] = '0${dateDivide[1]}';
    }
    if (dateDivide[0].length == 1) {
      dateDivide[0] = '0${dateDivide[0]}';
    }
    dateTime =
        DateTime.parse('${dateDivide[2]}-${dateDivide[1]}-${dateDivide[0]}');
    final Duration difference = _date.difference(dateTime);
    int totalDays = difference.inDays;

    int years = (totalDays / 365).floor();
    int months = ((totalDays - years * 365) / 30).floor();

    String result = '$years years $months months';
    return result;
  }

  final commonBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    // color: Color(0xffe4eaef),
    // color: Colors.red,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xfff5f7fa),
        Color(0xffe7edf2),
      ],
    ),

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
        blurRadius: 6.0,
        offset: Offset(-4, -4),
      ),
    ],
  );
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
          'Student Details',
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
        actions: <Widget>[
          if (currentUser.email == adminConcession ||
              currentUser.email == adminConcession2)
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text("Enter Unique Id of new Book"),
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 23),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerLeft,
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.37,
                          decoration: commonBoxDecoration,
                          child: TextField(
                            controller: _newBook,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter Unique Id',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 165, 163, 170),
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle submission of unique ID
                                Navigator.pop(context);
                              },
                              child: const Text("Submit"),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(
                Icons.add,
              ),
            ),
          const SizedBox(
            width: 20,
          ),
        ],
        flexibleSpace: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(
            left: 31.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: getExistingConcession(context),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 0, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Name',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_nameData)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Age',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_calcDate())),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 23,
                              left: 30,
                              right: 30,
                              bottom: 23,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            // color: Colors.red,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Date of Birth',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_dobData),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 30),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                height: 50,
                                alignment: Alignment.centerLeft,
                                width: MediaQuery.of(context).size.width * 0.37,
                                decoration: commonBoxDecoration,
                                child: Row(
                                  children: [
                                    const Text('Class',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_classValueData),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 30),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                alignment: Alignment.centerLeft,
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.37,
                                decoration: commonBoxDecoration,
                                child: Row(
                                  children: [
                                    const Text('Period',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_periodValueData),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 30,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                alignment: Alignment.centerLeft,
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.37,
                                // color: Colors.red,
                                decoration: commonBoxDecoration,
                                child: Row(
                                  children: [
                                    const Text('From',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_nearestStationData),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 30),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                alignment: Alignment.centerLeft,
                                height: 50,
                                width: MediaQuery.of(context).size.width * 0.37,
                                // color: Colors.red,
                                decoration: commonBoxDecoration,
                                child: Row(
                                  children: [
                                    const Text('To',
                                        style: TextStyle(
                                          color: Color(0xff311b61),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_destinationStationData),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Category',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_casteData)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                              top: 23,
                              left: 30,
                              right: 30,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Application Date',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_applicationDateData),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Lane',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_laneData)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Gender',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_genderData),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('UID',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_uidData)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Mobile Number',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_mobileNumberData)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 0),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Previous Pass Expiry Date',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(_expiryDateData)),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 23, left: 30, right: 30, bottom: 23),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            alignment: Alignment.centerLeft,
                            height: 50,
                            width: MediaQuery.of(context).size.width * 3.37,
                            decoration: commonBoxDecoration,
                            child: Row(
                              children: [
                                const Text('Email',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(_emailData),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 30, right: 30, bottom: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              alignment: Alignment.centerLeft,
                              // reduce the width to fit within the available space
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: commonBoxDecoration,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Address',
                                    style: TextStyle(
                                      color: Color(0xff311b61),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    // wrap the Text widget in an Expanded widget to allow it to take up remaining space
                                    child: Text(
                                      _addressData,
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              ),
              if (currentUser.email == adminConcession ||
                  currentUser.email == adminConcession2)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () async {
                        final complete = await completed(context);
                        if (complete == true) {
                          _applicationCanBeCollected = "true";
                          _saveConcessionIfTextNotEmpty();

                          String _id = "";
                          if (_newBook.text != "") {
                            _id = _newBook.text;
                          } else {
                            final lastRow = await _userSheet?.values.lastRow();

                            if (lastRow != null) {
                              String result = (lastRow.first)
                                  .substring(0, (lastRow.first).length - 3);
                              final int increment = int.parse(lastRow.first
                                      .substring(lastRow.first.length - 3)) +
                                  1;
                              final String incrementString =
                                  increment.toString();
                              if (incrementString.length != 3) {
                                if (incrementString.length == 1) {
                                  _id = "${result}00$incrementString";
                                } else if (incrementString.length == 2) {
                                  _id = "${result}0$incrementString";
                                } else {
                                  _id = "$result$incrementString";
                                }
                              } else {
                                _id = "$result$incrementString";
                              }
                            }
                          }

                          final user = {
                            "Sr.No.": _id,
                            "Sex": _genderData.substring(0, 1),
                            "Age": _calcDate().substring(0, 2),
                            "Name of the student": _nameData,
                            "Address": _addressData,
                            "Period": _periodValueData,
                            "From": _nearestStationData,
                            "To": _destinationStationData,
                            "Class": _classValueData,
                            "Date of Issue": _applicationDateData,
                            "Date Of Birth": _dobData,
                          };

                          await insert([user]);
                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xff000028),
                        ),
                        child: const Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
