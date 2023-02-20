import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

import '../com_constants/styles_constant.dart';

class CommonUI {
  Future<bool> showConfirmAlertDialog(
      BuildContext buildContext, String message) async {
    return await confirm(
      buildContext,
      title: Row(children: const [
        Icon(
          Icons.question_mark_outlined,
          color: Colors.black87,
        ),
        Text(' Confirmation'),
      ]),
      content: Text(message),
      textOK: const Text('OK'),
    );
  }

  Widget homeScreenIcon(
      final VoidCallback? onPressed, IconData icon, final String iconLabel) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black87)),
        onPressed: onPressed,
        child: Column(
          children: [
            Icon(
              icon,
              size: kHomeIconSize,
              color: Colors.white,
            ),
            Text(iconLabel),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  Widget isValidIcon(IconData icon, String iconLabel) {
    if (Icons.abc == icon) {
      return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade900)),
        onPressed: null,
        child: Column(
          children: [
            Icon(
              icon,
              size: kHomeIconSize,
              color: Colors.grey,
            ),
            Text(iconLabel),
          ],
        ),
      );
    } else {
      return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade900)),
        onPressed: () {},
        child: Column(
          children: [
            Icon(
              icon,
              size: kHomeIconSize,
              color: Colors.black87,
            ),
            Text(iconLabel),
          ],
        ),
      );
    }
  }

  showFailureAlert(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(children: const [
        Icon(
          Icons.warning,
          color: Colors.redAccent,
        ),
        Text(' Failure'),
      ]),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text(
            "OK",
            style: TextStyle(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showInfoAlert(BuildContext context, String message) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Row(children: const [
        Icon(
          Icons.info,
          color: Colors.green,
        ),
        Text('Success'),
      ]),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text(
            "OK",
            style: TextStyle(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
