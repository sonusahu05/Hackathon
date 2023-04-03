import 'package:onboardpro/services/cloud/events/cloud_events.dart';
import 'package:onboardpro/services/cloud/events/firebase_storage.dart';
import 'package:onboardpro/utilities/generics/get_arguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late String _eventName;
  late Timestamp _eventDate;
  late String _eventDetails;
  late String _imgUrl;
  late String _eventVenue;
  late String _registrationLink;

  Future<void> getExistingEvents(BuildContext context) async {
    final widgetConcession = context.getArgument<CloudEvents>();
    if (widgetConcession != null) {
      _eventName = widgetConcession.eventName;
      _eventDate = widgetConcession.dateOfEvent;
      _eventDetails = widgetConcession.eventDetails;
      _imgUrl = widgetConcession.imageUrl;
      _eventVenue = widgetConcession.venue;
      _registrationLink = widgetConcession.registrationLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: getExistingEvents(context),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      return Column(
                        children: [
                          FutureBuilder(
                              future: storage.downloadUrl(_imgUrl),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.hasData) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(50),
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 400,
                                      child: Image.network(
                                        snapshot.data!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                }
                                if (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    !snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                return Container();
                              }),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(50),
                                ),
                              ),
                              margin: const EdgeInsets.only(top: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const SizedBox(width: 40),
                                      Expanded(
                                        child: Text(
                                          _eventName,
                                          style: const TextStyle(
                                            fontSize: 34,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${_eventDate.toDate().day}/${_eventDate.toDate().month}/${_eventDate.toDate().year}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff15001C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),
                                            Row(
                                              children: [
                                                const Icon(Icons.schedule),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "${_eventDate.toDate().hour}:${_eventDate.toDate().minute}",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff15001C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Color(0xFFFF8C00),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  _eventVenue,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff15001C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 26,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: ExpandableText(
                                      text: _eventDetails,
                                      maxLines: 10,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 26,
                                  ),
                                  ElevatedButton(
                                    onPressed: (() {
                                      launchUrlString(_registrationLink);
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
                                        'Register Now',
                                        style: TextStyle(
                                          color: Color(0xffffffff),
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 26,
                                  ),
                                ],
                              )),
                        ],
                      );

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

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({required this.text, required this.maxLines});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: _isExpanded ? null : widget.maxLines,
          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xff15001C),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'Read less' : 'Read more',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFFFF8C00),
            ),
          ),
        ),
      ],
    );
  }
}
