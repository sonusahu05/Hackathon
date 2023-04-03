import 'package:onboardpro/services/cloud/events/cloud_events.dart';
import 'package:onboardpro/services/cloud/events/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

typedef ConcessionCallBack = void Function(CloudEvents event);

class EventTemplate extends StatelessWidget {
  final Iterable<CloudEvents> events;
  final ConcessionCallBack onTap;

  const EventTemplate({
    super.key,
    required this.events,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    final eventSort = events.toList();
    eventSort
        .sort((a, b) => a.dateOfEvent.seconds.compareTo(b.dateOfEvent.seconds));
    return Column(
      children: [
        ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: eventSort.length,
          itemBuilder: (context, index) {
            final event = eventSort.elementAt(index);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  onTap(event);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffe4eaef),
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
                        blurRadius: 5.0,
                        offset: Offset(-4, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: FutureBuilder(
                            future: storage.downloadUrl(event.imageUrl),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Image.network(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.committeeName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff15001C),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              event.eventName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff15001C),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              "DATE: ${event.dateOfEvent.toDate().day}/${event.dateOfEvent.toDate().month}/${event.dateOfEvent.toDate().year} | TIME: ${event.dateOfEvent.toDate().hour}:${event.dateOfEvent.toDate().minute}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              "VENUE: ${event.venue}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () {
                                launchUrlString(event.registrationLink);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  const Color(0xff15001C),
                                ),
                              ),
                              child: const InkWell(
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
