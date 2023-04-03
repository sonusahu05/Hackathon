import 'dart:io';

import 'package:onboardpro/enums/menu_action.dart';
import 'package:onboardpro/extensions/buildcontext/loc.dart';
import 'package:onboardpro/services/auth/bloc/auth_bloc.dart';
import 'package:onboardpro/services/auth/bloc/auth_event.dart';
import 'package:onboardpro/services/cloud/events/cloud_events.dart';
import 'package:onboardpro/services/cloud/events/firebase_cloud_events_storage.dart';
import 'package:onboardpro/services/cloud/events/firebase_storage.dart';
import 'package:onboardpro/utilities/dialogs/logout_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventsAdd extends StatefulWidget {
  const EventsAdd({super.key});

  @override
  State<EventsAdd> createState() => _EventsAddState();
}

class _EventsAddState extends State<EventsAdd> {
  TimeOfDay? _day;
  DateTime? _dob;
  late final TextEditingController _details;
  late final TextEditingController _eventName;
  late final DateTime now;
  late String _imageUrl;
  late final TextEditingController _venue;
  late final TextEditingController _registrationLink;
  late final TextEditingController _committeeName;
  late Timestamp _date;
  File? _imageFile;

  final currentUser = AuthService.firebase().currentUser!;

  CloudEvents? _events;
  late final FirebaseCloudStorageEvents _eventsService;

  @override
  void initState() {
    now = DateTime.now();
    _registrationLink = TextEditingController();
    _venue = TextEditingController();
    _eventsService = FirebaseCloudStorageEvents();
    _eventName = TextEditingController();
    _details = TextEditingController();
    _committeeName = TextEditingController();
    _imageUrl = '';
    super.initState();
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

  Future<CloudEvents> createNewEvent() async {
    final existingEvents = _events;
    if (existingEvents != null) {
      return existingEvents;
    }
    final newEvents = await _eventsService.createNewEvent(
      dateOfEvent: _date,
      eventDetails: _details.text,
      eventName: _eventName.text,
      imageUrl: _imageUrl,
      registrationLink: _registrationLink.text,
      venue: _venue.text,
      committeeName: _committeeName.text,
    );
    _events = newEvents;
    return newEvents;
  }

  @override
  void dispose() {
    _eventName.dispose();
    _details.dispose();
    _venue.dispose();
    _registrationLink.dispose();
    super.dispose();
  }

  final inputTextStyle = const TextStyle(
    color: Color(0xff101828),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
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
          'Welcome Committee',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.visible,
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (!mounted) return;
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ];
            },
          )
        ],
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
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width * 1.5,
                decoration: commonBoxDecoration,
                child: TextField(
                  style: inputTextStyle,
                  controller: _committeeName,
                  decoration: getCommonInputDecoration("Committee Name", null),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width * 1.5,
                decoration: commonBoxDecoration,
                child: TextField(
                  style: inputTextStyle,
                  controller: _eventName,
                  decoration: getCommonInputDecoration("Event Name", null),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width * 1.5,
                decoration: commonBoxDecoration,
                child: TextField(
                  style: inputTextStyle,
                  controller: _details,
                  decoration: getCommonInputDecoration("Event Details", null),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width * 1.5,
                decoration: commonBoxDecoration,
                child: TextField(
                  style: inputTextStyle,
                  controller: _registrationLink,
                  decoration:
                      getCommonInputDecoration("Registration Link", null),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, bottom: 23),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                height: 50,
                width: MediaQuery.of(context).size.width * 1.5,
                decoration: commonBoxDecoration,
                child: TextField(
                  style: inputTextStyle,
                  controller: _venue,
                  decoration: getCommonInputDecoration("Venue", null),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                height: 200, // Set the height of the container.
                width: 200, // Set the width of the container.
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      15), // Add a border radius to the container.
                  color: Colors
                      .grey[300], // Add a background color to the container.
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                            15), // Add a border radius to the image.
                        child: Image(
                          image: FileImage(_imageFile!),
                          fit: BoxFit
                              .cover, // Add a fit property to the image to make it cover the container.
                        ),
                      )
                    : Center(
                        child: Text(
                          'No image selected', // Add a message to display if no image is selected.
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ),
              // Show nothing if no image is selected.
              const SizedBox(
                height: 16,
              ),

              InkWell(
                splashColor: const Color.fromARGB(255, 134, 146, 224),
                onTap: (() async {
                  final results = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowMultiple: false,
                    allowCompression: true,
                    allowedExtensions: ['png', 'jpg', 'jpeg'],
                  );

                  if (results == null) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No File has been picked"),
                    ));
                    return;
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image Uploaded"),
                    ));
                  }
                  final newName = Timestamp.now();
                  final path = results.files.single.path!;
                  final fileName = newName.toString();
                  _imageUrl = fileName;
                  storage.uploadFile(path, fileName);

                  setState(() {
                    _imageFile = File(path);
                    // Set the image file to the selected file.
                  });
                }),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xff000028),
                  ),
                  child: const Text(
                    'Upload',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  DateTime? dob = await showDatePicker(
                    context: context,
                    initialDate: DateTime(now.year, now.month, now.day),
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 2),
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
                  // width: MediaQuery.of(context).size.width * 0.35,
                  // color: Colors.red,
                  decoration: commonBoxDecoration,
                  child: Text(
                    _dob == null
                        ? "Date of Event"
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
              InkWell(
                onTap: () async {
                  TimeOfDay? day = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 10, minute: 30),
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
                  if (day == null) {
                    return;
                  }
                  setState(() => _day = day);
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
                  // width: MediaQuery.of(context).size.width * 0.35,
                  // color: Colors.red,
                  decoration: commonBoxDecoration,
                  child: Text(
                    _day == null
                        ? "Select Time of the event"
                        : "${_day!.hour}:${_day!.minute}",
                    style: TextStyle(
                      color: _day == null
                          ? const Color(0xff979797)
                          : const Color(0xff101828),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(255, 255, 255, 255),
          child: InkWell(
            onTap: () async {
              if (_eventName.text.isEmpty ||
                  _details.text.isEmpty ||
                  _venue.text.isEmpty ||
                  _registrationLink.text.isEmpty ||
                  _committeeName.text.isEmpty ||
                  _dob == null ||
                  _day == null ||
                  _imageUrl == "") {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please fill all the fields"),
                ));
                return;
              } else {
                final DateTime a = DateTime(_dob!.year, _dob!.month, _dob!.day,
                    _day!.hour, _day!.minute);
                _date = Timestamp.fromDate(a);
                createNewEvent();
                await showRegistrationDialog(context);
                if (!mounted) return;
                _eventName.clear();
                _details.clear();
                _venue.clear();
                _registrationLink.clear();
                _committeeName.clear();
                _dob = null;
                _day = null;
                _imageUrl = "";
                _imageFile = null;
              }
            },
            borderRadius: BorderRadius.circular(50),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: SvgPicture.asset(
                'assets/images/icon/add.svg',
                color: const Color(0xff15001C),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
