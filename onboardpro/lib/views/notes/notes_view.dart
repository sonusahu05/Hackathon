import 'package:flutter/material.dart';
import 'package:onboardpro/constants/routes.dart';
import 'package:onboardpro/extensions/buildcontext/loc.dart';
import 'package:onboardpro/services/auth/auth_service.dart';
import 'package:onboardpro/services/cloud/notes/cloud_note.dart';
import 'package:onboardpro/services/cloud/notes/firebase_cloud_storage.dart';
import 'package:onboardpro/views/notes/notes_list_view.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  late final TextEditingController _searchController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              final text = "Notes ($noteCount)";
              return Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              );
            } else {
              return const Text('');
            }
          },
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
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by notes',
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
                stream: _notesService.allNotes(ownerUserId: userId),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as Iterable<CloudNote>;
                        final filteredEvents = allNotes.where((notes) =>
                            notes.text.contains(_searchController.text));
                        return NotesListView(
                          notes: filteredEvents,
                          onDeleteNote: (note) async {
                            await _notesService.deleteNote(
                                documentId: note.documentId);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                },
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
            onTap: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
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
