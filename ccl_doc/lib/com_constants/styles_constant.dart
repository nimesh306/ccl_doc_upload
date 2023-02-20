import 'package:flutter/material.dart';

import 'color_constant.dart';

var kTextFieldBorderStyle = BoxDecoration(
    border: Border.all(color: kTextFieldBorderColor),
    borderRadius: const BorderRadius.all(
      Radius.circular(10),
    ));

double kHomeIconSize = 100;

String kHomeIcon_help = 'Help';
String kHomeIcon_uploadSummary = 'Upload Summary';
String kHomeIcon_docUpload = 'Doc Upload';

IconData kIcon_help = Icons.live_help_outlined;
IconData kIcon_summary = Icons.summarize_outlined;
IconData kIcon_uploadFile = Icons.upload_file;
