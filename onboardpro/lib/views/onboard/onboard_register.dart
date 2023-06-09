import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/firebase_cloud_onboard_storage.dart';
import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

class OnboardRegister extends StatefulWidget {
  const OnboardRegister({super.key});

  @override
  State<OnboardRegister> createState() => _OnboardRegisterState();
}

class _OnboardRegisterState extends State<OnboardRegister> {
  DateTime? _dob;
  late final TextEditingController _address;
  late final TextEditingController _name;
  late final TextEditingController _lastName;
  late final TextEditingController _idNum;
  late final String _email;
  String _gender = "Male";
  late final DateTime now;
  late final TextEditingController _mobileNumber;
  final currentUser = AuthService.firebase().currentUser!;

  CloudOnboard? _concession;
  late final FirebaseCloudStorageOnboard _concessionService;

  @override
  void initState() {
    now = DateTime.now();

    _concessionService = FirebaseCloudStorageOnboard();
    _name = TextEditingController();
    _lastName = TextEditingController();
    _address = TextEditingController();
    _email = currentUser.email;
    _idNum = TextEditingController();
    _mobileNumber = TextEditingController();

    _name.text = '';
    _lastName.text = '';
    _address.text = '';
    _mobileNumber.text = '';
    super.initState();
  }

  Future<http.Response> insertData(Map<String, dynamic> data) async {
    var url = 'http://10.0.2.2:5000/api/nation';
    print(data);
    var body = json.encode(data);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  }

  Future<CloudOnboard> createNewOnboard() async {
    final key = encrypt.Key.fromLength(32);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(AES(key));
    final encryptedName = encrypter.encrypt(_name.text, iv: iv);
    final encryptedSurname = encrypter.encrypt(_lastName.text, iv: iv);
    final encryptedAddress = encrypter.encrypt(_address.text, iv: iv);
    final encryptedMobileNumber = encrypter.encrypt(_mobileNumber.text, iv: iv);
    final encryptedGender = encrypter.encrypt(_gender, iv: iv);
    final encryptedDob =
        encrypter.encrypt("${_dob!.day}/${_dob!.month}/${_dob!.year}", iv: iv);
    final encryptedId = encrypter.encrypt(_idNum.text, iv: iv);
    final keyBytes = key.bytes;
    final ivBytes = iv.bytes;

    final keyString = base64.encode(keyBytes);
    final ivString = base64.encode(ivBytes);

    final existingConcession = _concession;
    if (existingConcession != null) {
      return existingConcession;
    }
    final userId = currentUser.id;
    final newConcession = await _concessionService.createNewOnboard(
      userId: userId,
      name: encryptedName.base64,
      surname: encryptedSurname.base64,
      address: encryptedAddress.base64,
      mobileNumber: encryptedMobileNumber.base64,
      dob: encryptedDob.base64,
      email: _email,
      gender: encryptedGender.base64,
      key: keyString,
      iv: ivString,
      idNum: encryptedId.base64,
    );
    _concession = newConcession;
    return newConcession;
  }

  @override
  void dispose() {
    _name.dispose();
    _lastName.dispose();
    _address.dispose();
    _mobileNumber.dispose();
    _idNum.dispose();
    super.dispose();
  }

  void gender(String? selectedvalue) {
    if (selectedvalue is String) {
      setState(() {
        _gender = selectedvalue;
      });
    }
  }

  InputDecoration getCommonInputDecoration(String text, Widget? prefixIcon) {
    return InputDecoration(
      hintText: text,
      prefixIcon: prefixIcon,
      hintStyle: const TextStyle(
        color: Color(0xff979797),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      contentPadding: const EdgeInsets.all(10),
    );
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

  final inputTextStyle = const TextStyle(
    color: Color(0xff101828),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
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
          'KYC Form',
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
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
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
                child: TextField(
                  style: inputTextStyle,
                  controller: _name,
                  decoration: getCommonInputDecoration("First Name", null),
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
                child: TextField(
                  style: inputTextStyle,
                  controller: _lastName,
                  decoration: getCommonInputDecoration("Last Name", null),
                ),
              )
            ],
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 23, left: 30, right: 30, bottom: 23),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.37,
            decoration: commonBoxDecoration,
            child: Text(currentUser.email, style: inputTextStyle),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.37,
            decoration: commonBoxDecoration,
            child: TextField(
              style: inputTextStyle,
              controller: _mobileNumber,
              decoration: getCommonInputDecoration("Mobile Nubmer", null),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            alignment: Alignment.centerLeft,
            height: 50,
            width: MediaQuery.of(context).size.width * 0.37,
            decoration: commonBoxDecoration,
            child: TextField(
              style: inputTextStyle,
              controller: _idNum,
              decoration: getCommonInputDecoration("Unique Id Number", null),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32.0, bottom: 18),
            child: Text('Gender',
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
                    _gender = "Male";
                  });
                },
                child: Row(
                  children: [
                    _gender == "Male"
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
                      'Male',
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
                    _gender = "Female";
                  });
                },
                child: Row(
                  children: [
                    _gender == "Female"
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
                      'Female',
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
                    _gender = "Other";
                  });
                },
                child: Row(
                  children: [
                    _gender == "Other"
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
          InkWell(
            onTap: () async {
              DateTime? dob = await showDatePicker(
                context: context,
                initialDate: DateTime(2002, 01, 01),
                firstDate: DateTime(1900),
                lastDate: DateTime(now.year),
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
              setState(() => _dob = dob);
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
                _dob == null
                    ? "Date of Birth"
                    : "${_dob!.day}/${_dob!.month}/${_dob!.year}",
                style: TextStyle(
                  color: _dob == null
                      ? const Color(0xff979797)
                      : const Color(0xff101828),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 23, left: 30, right: 30, bottom: 40),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.35,
            // color: Colors.red,
            decoration: commonBoxDecoration,
            child: TextField(
              style: inputTextStyle,
              controller: _address,
              maxLines: 5,
              minLines: 3,
              decoration: getCommonInputDecoration(
                  "Add your residential address", null),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  if (_name.text != "" &&
                      _lastName.text != "" &&
                      _address.text != "" &&
                      _gender != "" &&
                      _dob != null &&
                      _mobileNumber.text != "") {
                    createNewOnboard();

                    final data = {
                      'address': _address.text,
                      'dob': _dob!.toString(),
                      'docVerified': "false",
                      'email': _email,
                      'faceVerified': "false",
                      'gender': _gender,
                      'id': _idNum.text,
                      'imageUrl': "",
                      'iv': '',
                      'key': "",
                      'mobileNumber': _mobileNumber.text,
                      'mobileVerified': "false",
                      'name': _name.text,
                      'surname': _lastName.text,
                      'userId': "1",
                    };
                    insertData(data);
                    // print("data insertedddddd");
                    await showRegistrationDialog(context);
                    if (!mounted) return;
                    Navigator.pop(context);
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
            ],
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
