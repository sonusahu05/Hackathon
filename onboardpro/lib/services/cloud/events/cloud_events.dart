import 'package:onboardpro/services/cloud/events/cloud_storage_events_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudEvents {
  final String documentEventId;
  final Timestamp dateOfEvent;
  final String eventDetails;
  final String eventName;
  final String imageUrl;
  final String venue;
  final String registrationLink;
  final String committeeName;

  const CloudEvents({
    required this.documentEventId,
    required this.dateOfEvent,
    required this.eventDetails,
    required this.eventName,
    required this.imageUrl,
    required this.venue,
    required this.registrationLink,
    required this.committeeName,
  });

  CloudEvents.fromSnapshot(
    QueryDocumentSnapshot<Map<String, dynamic>> snapshot,
  )   : documentEventId = snapshot.id,
        dateOfEvent = snapshot.data()[dateOfEventField] as Timestamp,
        eventDetails = snapshot.data()[eventDetailsField] as String,
        eventName = snapshot.data()[eventNameField] as String,
        imageUrl = snapshot.data()[imageUrlField] as String,
        venue = snapshot.data()[venueField] as String,
        registrationLink = snapshot.data()[registrationLinkField] as String,
        committeeName = snapshot.data()[committeeNameField] as String;
}
