import 'dart:io';
import 'dart:typed_data';

import 'package:draw_on_image_plugin/draw_on_image_plugin.dart';
import 'package:flutter/material.dart';

import 'camera_screen.dart';

class PreviewScreen extends StatefulWidget {
  late String imgPath;
  late String dirPath;

  PreviewScreen({required this.imgPath, required this.dirPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  DrawOnImage _plugin = DrawOnImage();
  String newImagePath = '';
  @override
  void initState() {
    super.initState();
    newImagePath = widget.imgPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Image Preview'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _cameraPreviewWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  height: 60.0,
                  color: Colors.black,
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          icon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            deleteFile(widget.imgPath);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          _drawTextOncapteredImage(widget.imgPath);
                        },
                      ),
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.delete_forever,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     deleteAllFiles(widget.dirPath);
                      //   },
                      // ),
                      // IconButton(
                      //   icon: const Icon(
                      //     Icons.upload_rounded,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     fileUpload(widget.dirPath);
                      //   },
                      // ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<int> deleteFile(String path) async {
    try {
      final file = await File(path);
      await file.delete();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );

      return 1;
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteAllFiles(String path) async {
    try {
      var listSync = Directory(path).listSync();
      for (var item in listSync) {
        // final file = await File(path);
        await item.delete();
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );

      return 1;
    } catch (e) {
      return 0;
    }
  }

  // Future<int> fileUpload(String path) async {
  //   try {
  //     var listSync = Directory(path).listSync();
  //     // for (var item in listSync) {
  //     // final file = await File(path);
  //     // await item.delete();
  //     // }
  //
  //     var file = File(listSync[0].path);
  //     print('upload calling...');
  //     await drive.uploadFileToGoogleDrive(file);
  //
  //     return 1;
  //   } catch (e) {
  //     return 0;
  //   }
  //
  //   return 0;
  // }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    return Image.file(
      File(newImagePath),
      fit: BoxFit.cover,
    );
  }

  _drawTextOncapteredImage(String imagePath) async {
    try {
      print('sssssssssssss=' + imagePath);

      Uint8List bytes = File(widget.imgPath).readAsBytesSync();
      ByteData imageBytes = ByteData.view(bytes.buffer);

      // copy the file to a new path with current name
      String newFileName = widget.imgPath.split('/').last;
      String dateTime = newFileName.split('.').first;

      // ByteData imageBytes = await rootBundle.load(imagePath);
      String fileName = await _plugin.writeTextOnImage(WriteImageData(
          dateTime, imageBytes,
          left: 10,
          right: 20,
          top: 10,
          bottom: 200,
          color: Colors.red.value,
          fontSize: 50));

      final File newImage = File(fileName);

      // final exif = await Exif.fromPath(newImage!.path);
      // final attributes = await exif.getAttributes();
      // print(attributes);
      // await exif.close();

      setState(() {
        newImagePath = fileName;
        File copySync = newImage.copySync('${widget.dirPath}/$newFileName');
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),
      );
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
