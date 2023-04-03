import 'package:onboardpro/services/cloud/cloud_storage_exceptions.dart';
import 'package:onboardpro/services/cloud/events/cloud_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onboardpro/services/cloud/events/cloud_storage_events_constants.dart';

class FirebaseCloudStorageEvents {
  final events = FirebaseFirestore.instance.collection('events');

  Future<void> deleteEvent({required String documentEventId}) async {
    try {
      await events.doc(documentEventId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Stream<Iterable<CloudEvents>> allEvents() => events
      .snapshots()
      .map(((event) => event.docs.map((doc) => CloudEvents.fromSnapshot(doc))));

  Future<CloudEvents> createNewEvent({
    required Timestamp dateOfEvent,
    required String eventDetails,
    required String eventName,
    required String imageUrl,
    required String venue,
    required String registrationLink,
    required String committeeName,
  }) async {
    final document = await events.add({
      dateOfEventField: dateOfEvent,
      eventDetailsField: eventDetails,
      eventNameField: eventName,
      imageUrlField: imageUrl,
      venueField: venue,
      registrationLinkField: registrationLink,
      committeeNameField: committeeName,
    });
    final fetchedEvent = await document.get();
    return CloudEvents(
      documentEventId: fetchedEvent.id,
      dateOfEvent: dateOfEvent,
      eventDetails: eventDetails,
      eventName: eventName,
      imageUrl: imageUrl,
      venue: venue,
      registrationLink: registrationLink,
      committeeName: committeeName,
    );
  }

  static final FirebaseCloudStorageEvents _shared =
      FirebaseCloudStorageEvents._sharedInstance();
  FirebaseCloudStorageEvents._sharedInstance();
  factory FirebaseCloudStorageEvents() => _shared;
}
