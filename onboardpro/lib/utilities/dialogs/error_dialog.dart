import 'package:flutter/material.dart';
import 'package:onboardpro/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: "Error",
    content: text,
    optionsBuilder: () => {
      "Ok": null,
    },
  );
}
