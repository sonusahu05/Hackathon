import 'package:onboardpro/services/cloud/onboard/cloud_storage_onboard_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudOnboard {
  final String documentOnboardId;
  final String name;
  final String surname;
  final String gender;
  final String email;
  final String mobileNumber;
  final String mobileVerified;
  final String docVerified;
  final String faceVerified;
  final String dob;
  final String address;
  final String imageUrl;
  final String userId;
  final String key;
  final String iv;
  final String idNum;

  const CloudOnboard({
    required this.documentOnboardId,
    required this.name,
    required this.surname,
    required this.gender,
    required this.email,
    required this.mobileNumber,
    required this.mobileVerified,
    required this.docVerified,
    required this.faceVerified,
    required this.dob,
    required this.address,
    required this.imageUrl,
    required this.userId,
    required this.key,
    required this.iv,
    required this.idNum,
  });

  CloudOnboard.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : documentOnboardId = snapshot.id,
        imageUrl = snapshot.data()[imageUrlField] as String,
        name = snapshot.data()[nameField] as String,
        surname = snapshot.data()[surnameField] as String,
        gender = snapshot.data()[genderField] as String,
        email = snapshot.data()[emailField] as String,
        mobileNumber = snapshot.data()[mobileNumberField] as String,
        mobileVerified = snapshot.data()[mobileVerifiedField] as String,
        docVerified = snapshot.data()[docVerifiedField] as String,
        faceVerified = snapshot.data()[faceVerifiedField] as String,
        dob = snapshot.data()[dobField] as String,
        address = snapshot.data()[addressField] as String,
        userId = snapshot.data()[userIdField] as String,
        iv = snapshot.data()[ivField] as String,
        key = snapshot.data()[keyField] as String,
        idNum = snapshot.data()[idNumField] as String;
}
