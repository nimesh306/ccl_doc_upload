import 'dart:io';

import 'package:camera/camera.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../com_constants/value_constant.dart';
import '../model/folder_crete.dart';
import '../service/google_drive.dart';
import '../ui/home_screen.dart';
import '../utils/common_functions.dart';
import 'loading_indicator_dialog.dart';
import 'preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreen createState() => _CameraScreen();
}

class _CameraScreen extends State {
  CameraController? controller;
  TextEditingController userInputController = TextEditingController();
  List cameras = [];
  int selectedCameraIndex = 0;
  String imagePath = '';
  String savedImagePath = '';
  final drive = GoogleDrive();

  void _getPermissions() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();

    print(statuses[Permission.location]);
  }

  @override
  void initState() {
    super.initState();
    // _getPermissions();
    // _createTempDir();
    _getTempDir();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.isNotEmpty) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No Camera available');
      }
    }).catchError((err) {
      print('11111Error :${err.code}Error message : ${err.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: _cameraPreviewWidget(),
            ),
            Align(
              //captered images list
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                color: Colors.black,
                child: _showSavedImagesList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Flex(direction: Axis.horizontal, children: [
                Expanded(
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    color: Colors.black,
                    child: Row(
                      children: <Widget>[
                        _cameraToggleRowWidget(),
                        _cameraControlWidget(context),
                        _imagesUploadButtonWidget(context),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller?.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        print('Camera error ${controller?.value.errorDescription}');
      }
    });
    try {
      await controller?.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller!.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: CameraPreview(controller!),
    );
  }

  /// show saved images list
  Widget _showSavedImagesList() {
    // print('hhhhhhhhhhhhhhhh=====' + savedImagePath.isNotEmpty.toString());
    if (_getSavedImagesList().isNotEmpty && savedImagePath.isNotEmpty) {
      return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _getSavedImagesList().length,
          itemBuilder: (BuildContext buildContext, int index) {
            return GestureDetector(
              onLongPress: () => {
                _eventDeleteFile(_getSavedImagesList()[index], buildContext)
              },
              child: Image.file(
                File(_getSavedImagesList()[index].path),
              ),
            );
          });
    } else {
      return const Text(
        'No saved images',
        style: TextStyle(color: Colors.white),
      );
    }
  }

  _eventDeleteFile(File file, BuildContext buildContext) async {
    if (await confirm(
      buildContext,
      title: const Text('Confirm'),
      content: const Text('Would you like to remove?'),
      textOK: const Text('Yes'),
      textCancel: const Text('No'),
    )) {
      CommonFunctions().deleteFile(file.path);
      setState(() {
        _getSavedImagesList();
      });
      return print('pressedOK');
    }
    return print('pressedCancel');
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return const Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: _onSwitchCamera,
          icon: Icon(
            _getCameraLensIcon(lensDirection),
            color: Colors.white,
            size: 30,
          ),
          label: Text(
            lensDirection
                .toString()
                .substring(lensDirection.toString().indexOf('.') + 1)
                .toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _onCapturePressed(context);
              },
              child: const Icon(
                Icons.camera,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _imagesUploadButtonWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                _onUploadPressed(context);
              },
              child: const Icon(
                Icons.upload_rounded,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  void _getTempDir() async {
    var dir = await getApplicationSupportDirectory();

    var newFolder = await FolderSession().getFolderName(kBaseFolderName);

    setState(() {
      savedImagePath = '${dir?.path}/$doc_base_folder/$newFolder';
    });
    print('savedImagePath====$savedImagePath');
  }

  void _onCapturePressed(context) async {
    try {
      var dir = await getExternalStorageDirectory();

      // _dataRequiredForBuild = await FolderSession().getFolderName(kBaseFolderName);

      print(kBaseFolderName);

      var folderName = FolderSession().getFolderName(kBaseFolderName);
      print(folderName);
      final path = join(savedImagePath, '${DateTime.now()}.png');

      print('Image saving path====' + path);

      await controller?.takePicture(path);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewScreen(
                  imgPath: path,
                  dirPath: savedImagePath,
                )),
      );
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void _onUploadPressed(context) async {
    // CommonUI()
    //     .showConfirmAlertDialog(context, "Do you want capture new Images ?")
    //     .then((isConfirm) => {
    //           if (isConfirm) {
    //
    //
    //           } else {Navigator.pop(context)}
    //         });

    print('upload calling to drive...');
    try {
      LoadingIndicatorDialog loading = LoadingIndicatorDialog();
      loading.show(context);

      print('savedImagePath=====$savedImagePath');
      await drive.allImagesUpload(savedImagePath);
      loading.dismiss();

      showInfoAlertx(context, 'Upload is completed.');
    } catch (e) {
      print('getting files... error===$e');
    }
  }

  // void savedImagesUpload(BuildContext buildContext) async {
  //   print('upload calling to drive...');
  //   try {
  //     // await drive.uploadx(savedImagePath).whenComplete(() => () {
  //     //       showInfoAlertx(buildContext, 'Upload is completed.');
  //     //     });
  //
  //     // var listSync = Directory(savedImagePath).listSync();
  //     // for (var item in listSync) {
  //     // print('upload calling to drive...');
  //     await drive.allImagesUpload(savedImagePath);
  //
  //     // await drive.uploadFileToGoogleDrive();
  //     // }
  //     showInfoAlertx(buildContext, 'Upload is completed.');
  //   } catch (e) {
  //     print('getting files... error===$e');
  //   }
  // }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }

  List _getSavedImagesList() {
    if (savedImagePath.isNotEmpty) {
      late List listSync;
      listSync = Directory(savedImagePath).listSync();
      print('Images files count==========' + listSync.length.toString());

      if (listSync.length == 0) {
        return [];
      }

      return listSync;
    }
    return [];
  }

  showInfoAlertx(BuildContext context, String message) {
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
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
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
