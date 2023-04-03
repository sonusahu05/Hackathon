import 'package:flutter/material.dart';
import 'package:onboardpro/services/cloud/notes/cloud_note.dart';
import 'package:onboardpro/utilities/dialogs/delete_dialog.dart';
import 'package:intl/intl.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notesSort = notes.toList();
    notesSort.sort((a, b) => b.noteDate.seconds.compareTo(a.noteDate.seconds));
    return Column(
      children: [
        ListView.builder(
          primary: false,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: notesSort.length,
          itemBuilder: (context, index) {
            final note = notesSort.elementAt(index);
            final date = note.noteDate.toDate();
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xffabc2d4),
                    spreadRadius: 0.0,
                    blurRadius: 6.0,
                    offset: Offset(4, 4),
                  ),
                  BoxShadow(
                    color: Color.fromARGB(255, 235, 233, 233),
                    spreadRadius: 0.0,
                    blurRadius: 2.0,
                    offset: Offset(-4, -4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                onTap: () {
                  onTap(note);
                },
                title: Text(
                  note.text,
                  maxLines: 3,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(note);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
                subtitle: Text(
                  DateFormat.yMMMMEEEEd().format(date),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
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
