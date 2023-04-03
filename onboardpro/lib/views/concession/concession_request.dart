import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/concession/cloud_concession.dart';
import 'package:onboardpro/services/cloud/concession/firebase_cloud_storage_concession.dart';
import 'package:flutter_svg/flutter_svg.dart';

DateTime now = DateTime.now();
DateTime _date = DateTime(now.year, now.month, now.day);

class ConcessionRequest extends StatefulWidget {
  const ConcessionRequest({super.key});

  @override
  State<ConcessionRequest> createState() => _ConcessionRequestState();
}

class _ConcessionRequestState extends State<ConcessionRequest> {
  String _received = "false";
  String _completed = "false";
  String _classValue = "First";
  String _periodValue = "Monthly";
  String _lane = "Central";
  DateTime? _expiryDate;
  final _dateOfApplication = "${_date.day}/${_date.month}/${_date.year}";

  CloudConcession? _concession;
  late final FirebaseCloudStorageConcession _concessionService;

  @override
  void initState() {
    _concessionService = FirebaseCloudStorageConcession();
    super.initState();
  }

  Future<void> getExistingConcession(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudConcession>();

    if (widgetConcession != null) {
      _concession = widgetConcession;
    }
  }

  void _saveConcessionIfTextNotEmpty() async {
    final concession = _concession;
    if (concession != null && _expiryDate != null) {
      await _concessionService.updateConcession(
        documentConcessionId: concession.documentConcessionId,
        trainClass: _classValue,
        period: _periodValue,
        dateOfApplication: _dateOfApplication,
        receivedStatus: _received,
        completedStatus: _completed,
        expiryDate:
            "${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}",
        lane: _lane,
      );
    } else if (concession != null && _expiryDate == null) {
      await _concessionService.updateConcession(
        documentConcessionId: concession.documentConcessionId,
        trainClass: _classValue,
        period: _periodValue,
        dateOfApplication: _dateOfApplication,
        receivedStatus: _received,
        completedStatus: _completed,
        expiryDate: "No Previous Pass",
        lane: _lane,
      );
    }
  }

  void classCallBack(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _classValue = selectedvalue;
      });
    }
  }

  void periodCallBack(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _periodValue = selectedvalue;
      });
    }
  }

  void laneCallBack(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _lane = selectedvalue;
      });
    }
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
          'Application Request',
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
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 23, left: 30, right: 30, bottom: 23),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.35,
            decoration: commonBoxDecoration,
            child: Row(
              children: [
                const Text('Date of Application',
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
                Text(_dateOfApplication),
              ],
            ),
          ),
          InkWell(
            onTap: () async {
              DateTime? dob = await showDatePicker(
                context: context,
                initialDate: DateTime(now.year, now.month, now.day),
                firstDate: DateTime(2021),
                lastDate: DateTime(now.year, now.month, now.day),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xff000028),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (dob == null) {
                return;
              }
              setState(() => _expiryDate = dob);
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 23,
                left: 30,
                right: 30,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),
              alignment: Alignment.centerLeft,
              height: 50,
              decoration: commonBoxDecoration,
              child: Text(
                _expiryDate == null
                    ? "Previous Pass expiry date"
                    : "${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}",
                style: TextStyle(
                  color: _expiryDate == null
                      ? const Color(0xff979797)
                      : const Color(0xff101828),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 23,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 18),
            child: Text('Class',
                style: TextStyle(
                  color: Color(0xff311b61),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _classValue = "First";
                  });
                },
                child: Row(
                  children: [
                    _classValue == "First"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'First',
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
                    _classValue = "Second";
                  });
                },
                child: Row(
                  children: [
                    _classValue == "Second"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'Second',
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
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 18),
            child: Text('Period',
                style: TextStyle(
                  color: Color(0xff311b61),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _periodValue = "Monthly";
                  });
                },
                child: Row(
                  children: [
                    _periodValue == "Monthly"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'Monthly',
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
                    _periodValue = "Quaterly";
                  });
                },
                child: Row(
                  children: [
                    _periodValue == "Quaterly"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'Quaterly',
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
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 30.0, bottom: 18),
            child: Text('Lane',
                style: TextStyle(
                  color: Color(0xff311b61),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
                overflow: TextOverflow.visible),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _lane = "Central";
                  });
                },
                child: Row(
                  children: [
                    _lane == "Central"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'Central',
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
                    _lane = "Western";
                  });
                },
                child: Row(
                  children: [
                    _lane == "Western"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'Western',
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
                    _lane = "Harbour";
                  });
                },
                child: Row(
                  children: [
                    _lane == "Harbour"
                        ? SvgPicture.asset(
                            'assets/images/icon/checked.svg',
                            width: 17,
                            height: 17,
                          )
                        : Container(
                            width: 17,
                            height: 17,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
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
                      'Harbour',
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
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  if (_classValue != "" && _lane != "" && _periodValue != "") {
                    _received = "true";
                    _completed = "false";
                    getExistingConcession(context);
                    _saveConcessionIfTextNotEmpty();
                    await applicationSentDialog(context);
                    if (!mounted) return;
                    Navigator.of(context).pop(true);
                  } else {
                    await showFieldsNecessary(context);
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
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          )
        ],
      ),
    );
  }
}
