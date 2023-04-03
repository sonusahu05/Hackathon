import 'package:flutter/material.dart';
import 'package:onboardpro/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete Application?",
    content: "If you delete you'll have to register again!",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showDeleteDialogConcession(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete Concession?",
    content: "If you delete you'll have to register again!",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showDeleteDialogOnboard(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete KYC?",
    content: "If you delete you'll have to register again!",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showRegistrationDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Registration Successful!",
    content: "You can go back to the application process now",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> applicationSentDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Application Sent!",
    content: "Keep checking your Application Status",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> waitForAnotherSubmission(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Can not create Application",
    content: "Looks Like you have already have an open Application",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> completed(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Is the form ready?",
    content: "Once submitted studtend may come to collect the form",
    optionsBuilder: () => {
      "Cancel": false,
      "Submit": true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showFieldsNecessary(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Form Incomplete!",
    content: "All fields are necessary.",
    optionsBuilder: () => {
      "Cancel": false,
      "Yes": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
