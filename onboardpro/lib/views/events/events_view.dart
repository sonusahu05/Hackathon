import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/services/cloud/events/cloud_events.dart';
import 'package:onboardpro/services/cloud/events/firebase_cloud_events_storage.dart';
import 'package:onboardpro/services/cloud/events/firebase_storage.dart';
import 'package:onboardpro/views/events/event_template.dart';
import 'package:flutter/material.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  late final FirebaseCloudStorageEvents _eventsService;
  String get userId => AuthService.firebase().currentUser!.id;
  String get userEmail => AuthService.firebase().currentUser!.email;
  final DateTime today = DateTime.now();
  late final TextEditingController _searchEvent;

  @override
  void initState() {
    _eventsService = FirebaseCloudStorageEvents();
    _searchEvent = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchEvent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
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
          'Events',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _searchEvent,
                decoration: InputDecoration(
                  hintText: 'Search by event name',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xff15001C)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color(0xff15001C),
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: _eventsService.allEvents(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allEvents =
                            snapshot.data as Iterable<CloudEvents>;
                        final filteredEvents = allEvents.where((events) =>
                            events.eventName.contains(_searchEvent.text));
                        if (filteredEvents.isNotEmpty) {
                          for (var i in filteredEvents) {
                            if (i.dateOfEvent.toDate().isBefore(today)) {
                              _eventsService.deleteEvent(
                                  documentEventId: i.documentEventId);
                              storage.deleteImage(i.imageUrl);
                            }
                          }
                          return Column(
                            children: [
                              EventTemplate(
                                events: filteredEvents,
                                onTap: (event) {
                                  Navigator.of(context).pushNamed(
                                    eventsDetails,
                                    arguments: event,
                                  );
                                },
                              ),
                            ],
                          );
                        } else {
                          return const Text("No Event To Show");
                        }
                      } else {
                        return const Text("No Event To Show");
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
