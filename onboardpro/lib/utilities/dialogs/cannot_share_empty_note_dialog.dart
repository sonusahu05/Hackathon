import 'package:flutter/material.dart';
import 'package:onboardpro/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: "Cannot Share Empty Note",
    content: "Please add some content to your note before sharing",
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}
