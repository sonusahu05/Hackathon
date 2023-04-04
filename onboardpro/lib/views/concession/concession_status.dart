import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/cloud/concession/cloud_concession.dart';
import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:onboardpro/utilities/dialogs/generic_dialog.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

DateTime now = DateTime.now();
DateTime _date = DateTime(now.year, now.month, now.day);

class ConcessionStatus extends StatefulWidget {
  const ConcessionStatus({super.key});

  @override
  State<ConcessionStatus> createState() => _ConcessionStatusState();
}

class _ConcessionStatusState extends State<ConcessionStatus> {
  String _nameData = "";
  String _emailData = "";
  String _classValueData = "";
  String _periodValueData = "";
  String _applicationSent = "";
  String _applicationCanBeCollected = "";
  String _applicationDate = "";
  late DateTime dateTime;
  late DateTime lastDate;
  CloudConcession? _concession;

  Future<void> getExistingConcession(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudConcession>();
    _concession = widgetConcession;

    if (widgetConcession != null) {
      _nameData = widgetConcession.name;
      _emailData = widgetConcession.email;
      _classValueData = widgetConcession.trainClass;
      _periodValueData = widgetConcession.period;
      _applicationSent = widgetConcession.receivedStatus;
      _applicationCanBeCollected = widgetConcession.completedStatus;
      _applicationDate = widgetConcession.dateOfApplication;
    }
  }

  Future<bool> waitForAnotherSubmission2(BuildContext context) {
    return showGenericDialog<bool>(
      context: context,
      title: "Wait untill you pass expires",
      content:
          "You can apply after ${lastDate.day}/${lastDate.month}/${lastDate.year}",
      optionsBuilder: () => {
        "Cancel": false,
        "Yes": true,
      },
    ).then(
      (value) => value ?? false,
    );
  }

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, CloudConcession concession) async {
    final result = await Navigator.of(context).pushNamed(
      concessionRequest,
      arguments: concession,
    );
    if (!mounted) return;
    if (result == true) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000028),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getExistingConcession(context),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color(0xfff5f7fa),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              SvgPicture.asset(
                                'assets/images/icon/person.svg',
                                height: 100,
                                width: 100,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                _nameData,
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
                                _emailData,
                                style: const TextStyle(
                                  color: Color(0xff343434),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              ElevatedButton(
                                onPressed: (() {
                                  Navigator.of(context).pushNamed(
                                    student,
                                    arguments: _concession,
                                  );
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
                                    'View Application',
                                    style: TextStyle(
                                      color: Color(0xffffffff),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xff000028),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(100),
                                        bottomRight: Radius.circular(100),
                                      ),
                                      // shape: BoxShape.circle,
                                    ),
                                    width: 39,
                                    height: 78,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 15, bottom: 40),
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 0,
                                            blurRadius: 4,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(43)),
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xff000028),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(43),
                                              topRight: Radius.circular(43),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              150,
                                          child: const Text(
                                            'Details',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Column(
                                              children: <Widget>[
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                if (_classValueData != "")
                                                  Text(
                                                    '$_classValueData Class\n\n $_periodValueData ',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Color(0xff000000),
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                if (_classValueData == "")
                                                  const Text(
                                                    'Welcome!\n\n Apply to see details',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xff000000),
                                                      fontSize: 28,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 30,
                                                ),
                                                if (_applicationCanBeCollected ==
                                                    "true")
                                                  InkWell(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 30,
                                                          vertical: 7),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 10, 198, 16),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(36),
                                                      ),
                                                      child: const Text(
                                                        'Approved',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (_applicationCanBeCollected ==
                                                        "false" &&
                                                    _classValueData != "")
                                                  InkWell(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 30,
                                                          vertical: 7),
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 160, 0, 0),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(36),
                                                      ),
                                                      child: const Text(
                                                        'Pending',
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xffffffff),
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 12,
                                                ),
                                                if (_applicationCanBeCollected ==
                                                    "true")
                                                  const Text(
                                                    'Collect your form from office',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xff343434),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                if (_applicationCanBeCollected ==
                                                        "false" &&
                                                    _classValueData != "")
                                                  const Text(
                                                    'Your application is under process',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Color(0xff343434),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                const SizedBox(
                                                  height: 16,
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xff000028),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(100),
                                        bottomLeft: Radius.circular(100),
                                      ),
                                    ),
                                    width: 39,
                                    height: 78,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: (() {
                                      if (_applicationDate == "") {
                                        _applicationDate = "1/2/2000";
                                      }
                                      var dateDivide =
                                          _applicationDate.split("/");
                                      if (dateDivide[1].length == 1) {
                                        dateDivide[1] = '0${dateDivide[1]}';
                                      }
                                      if (dateDivide[0].length == 1) {
                                        dateDivide[0] = '0${dateDivide[0]}';
                                      }
                                      dateTime = DateTime.parse(
                                          '${dateDivide[2]}-${dateDivide[1]}-${dateDivide[0]}');

                                      if (_periodValueData == "Monthly") {
                                        lastDate = DateTime(dateTime.year,
                                            dateTime.month + 1, dateTime.day);
                                      } else {
                                        lastDate = DateTime(dateTime.year,
                                            dateTime.month + 3, dateTime.day);
                                      }
                                      if (_date.isBefore(lastDate)) {
                                        waitForAnotherSubmission2(context);
                                      } else if ((_applicationCanBeCollected ==
                                                  'false' &&
                                              _applicationSent == 'false') ||
                                          (_applicationSent == 'true' &&
                                              _applicationCanBeCollected ==
                                                  'true')) {
                                        final concession = _concession;
                                        _navigateAndDisplaySelection(
                                            context, concession!);
                                      } else {
                                        waitForAnotherSubmission(context);
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
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title:
                                                  const Text('Important Note'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: const [
                                                  Text(
                                                      '• A fee of 1 Rupee must be paid for the concession certificate if the pass is for single month.'),
                                                  Text(
                                                      '• A fee of 2 Rupees must be paid for the concession certificate if the pass is for quarterly.'),
                                                  Text(
                                                      '• Please collect your pass within 3 days of the date of issue.'),
                                                  Text(
                                                      '• No requests for date changes for the signature will be entertained.'),
                                                  Text(
                                                      '• Please check details in issued railway concession certificate before leaving the counter.'),
                                                ],
                                              ));
                                        },
                                      );
                                    },
                                    icon:
                                        const Icon(Icons.info_outline_rounded),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ));

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
