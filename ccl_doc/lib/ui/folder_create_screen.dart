import 'dart:io';

import 'package:ccl_doc/ui/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../com_constants/value_constant.dart';
import '../model/folder_crete.dart';

class FolderCreateScreen extends StatefulWidget {
  const FolderCreateScreen({Key? key}) : super(key: key);

  @override
  State<FolderCreateScreen> createState() => _FolderCreateScreen();
}

// class _FolderCreateScreen extends State<FolderCreateScreen> {

class _FolderCreateScreen extends State<FolderCreateScreen> {
  final TextEditingController userInputController = TextEditingController();
  String savedImagePath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Image Capture'),
        backgroundColor: Colors.black87,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.redAccent,
            height: 4.0,
          ),
        ),
      ),
      body: Container(
        child: AlertDialog(
          title: Text('Please Enter Document Name'),
          content: TextField(
            onSubmitted: (value) {
              _getTempDir(userInputController.text.toString());
            },
            onChanged: (value) {},
            controller: userInputController,
            decoration: InputDecoration(hintText: "Document Name"),
          ),
        ),
      ),
    );
  }

  void _getTempDir(String userInput) async {
    print('userInput===$userInput');
    var dir = await getApplicationSupportDirectory();

    await FolderSession().saveFolderName(kBaseFolderName, userInput);
    await createTempDir(userInput);

    setState(() {
      savedImagePath = '${dir?.path}/$doc_base_folder/$userInput';
    });
    print('savedImagePath====$savedImagePath');

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CameraScreen()));
  }

  Future createTempDir(String folderName) async {
    try {
      print('folder_creating_screen___folderName==$folderNameß');
      var dir = await getApplicationSupportDirectory();
      print('external storage===$dir');

      if (!Directory("${dir?.path}/$doc_base_folder").existsSync()) {
        print('INNNN');
        Directory("${dir?.path}/$doc_base_folder").createSync(recursive: true);
      } else {
        if (!Directory("${dir?.path}/$doc_base_folder/$folderName")
            .existsSync()) {
          print('INNNN');
          Directory("${dir?.path}/$doc_base_folder/$folderName")
              .createSync(recursive: true);
        }
      }
    } on Exception catch (e) {
      print('folder_creattion_error===$e');
    }
  }
}
