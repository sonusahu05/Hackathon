import 'package:onboardpro/services/cloud/onboard/cloud_onboard.dart';
import 'package:onboardpro/services/cloud/onboard/cloud_storage_onboard_constants.dart';
import 'package:onboardpro/services/cloud/cloud_storage_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCloudStorageOnboard {
  final onboard = FirebaseFirestore.instance.collection('onboard');

  Future<void> deleteOnboard({required String documentOnboardId}) async {
    try {
      await onboard.doc(documentOnboardId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateOnboard({
    required String documentOnboardId,
    required String name,
    required String email,
    required String address,
    required String dob,
    required String mobileNumber,
    required String imageUrl,
    required String surname,
    required String gender,
    required String mobileVerified,
    required String docVerified,
    required String faceVerified,
    required String idNum,
  }) async {
    try {
      await onboard.doc(documentOnboardId).update({
        nameField: name,
        genderField: gender,
        emailField: email,
        addressField: address,
        dobField: dob,
        mobileNumberField: mobileNumber,
        imageUrlField: imageUrl,
        surnameField: surname,
        mobileVerifiedField: mobileVerified,
        docVerifiedField: docVerified,
        faceVerifiedField: faceVerified,
        idNumField: idNum,
      });
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudOnboard>> allOnboard({required String userId}) =>
      onboard.snapshots().map(((event) => event.docs
          .map((doc) => CloudOnboard.fromSnapshot(doc))
          .where((onboard) => onboard.userId == userId)));

  // Stream<Iterable<CloudOnboard>> allTrueOnboard({required String userId}) =>
  //     onboard.snapshots().map(((event) => event.docs
  //         .map((doc) => CloudOnboard.fromSnapshot(doc))
  //         .where((concession) =>
  //             concession.receivedStatus == "true" &&
  //             concession.completedStatus == "false")));

  Future<CloudOnboard> createNewOnboard({
    required String userId,
    required String name,
    required String surname,
    required String gender,
    required String email,
    required String address,
    required String dob,
    required String mobileNumber,
    required String key,
    required String iv,
    required String idNum,
  }) async {
    // final document =
    final document = await onboard.add({
      nameField: name,
      genderField: gender,
      emailField: email,
      addressField: address,
      dobField: dob,
      mobileNumberField: mobileNumber,
      imageUrlField: "",
      userIdField: userId,
      surnameField: surname,
      mobileVerifiedField: "false",
      docVerifiedField: "false",
      faceVerifiedField: "false",
      keyField: key,
      ivField: iv,
      idNumField: idNum,
    });
    final fetchedOnboard = await document.get();
    return CloudOnboard(
      documentOnboardId: fetchedOnboard.id,
      mobileVerified: "false",
      surname: surname,
      name: name,
      gender: gender,
      email: email,
      address: address,
      dob: dob,
      mobileNumber: mobileNumber,
      docVerified: "false",
      faceVerified: "false",
      imageUrl: "",
      userId: userId,
      key: key,
      iv: iv,
      idNum: idNum,
    );
  }

  static final FirebaseCloudStorageOnboard _shared =
      FirebaseCloudStorageOnboard._sharedInstance();
  FirebaseCloudStorageOnboard._sharedInstance();
  factory FirebaseCloudStorageOnboard() => _shared;
}
