import 'package:onboardpro/services/cloud/concession/cloud_storage_constants_concession.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudConcession {
  final String documentConcessionId;
  final String email;
  final String userId;
  final String name;
  final String gender;
  final String nearestStation;
  final String address;
  final String dob;
  final String destinationStation;
  final String trainClass;
  final String period;
  final String dateOfApplication;
  final String receivedStatus;
  final String completedStatus;
  final String mobileNumber;
  final String uid;
  final String caste;
  final String expiryDate;
  final String lane;

  const CloudConcession({
    required this.documentConcessionId,
    required this.email,
    required this.userId,
    required this.name,
    required this.gender,
    required this.nearestStation,
    required this.address,
    required this.dob,
    required this.destinationStation,
    required this.trainClass,
    required this.period,
    required this.dateOfApplication,
    required this.receivedStatus,
    required this.completedStatus,
    required this.mobileNumber,
    required this.uid,
    required this.caste,
    required this.expiryDate,
    required this.lane,
  });

  CloudConcession.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : documentConcessionId = snapshot.id,
        email = snapshot.data()[emailField] as String,
        userId = snapshot.data()[userIdField] as String,
        name = snapshot.data()[nameField] as String,
        gender = snapshot.data()[genderField] as String,
        nearestStation = snapshot.data()[nearestStationField] as String,
        address = snapshot.data()[addressField] as String,
        dob = snapshot.data()[dobField] as String,
        destinationStation = snapshot.data()[destinationStationField] as String,
        trainClass = snapshot.data()[trainClassField] as String,
        period = snapshot.data()[periodField] as String,
        dateOfApplication = snapshot.data()[dateOfApplicationField] as String,
        receivedStatus = snapshot.data()[receivedStatusField] as String,
        completedStatus = snapshot.data()[completedStatusField] as String,
        lane = snapshot.data()[laneField] as String,
        caste = snapshot.data()[casteField] as String,
        expiryDate = snapshot.data()[expiryDateField] as String,
        uid = snapshot.data()[uidField] as String,
        mobileNumber = snapshot.data()[mobileNumberField] as String;
}
