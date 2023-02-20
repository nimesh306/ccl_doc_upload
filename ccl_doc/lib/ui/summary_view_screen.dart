import 'dart:io';

import 'package:ccl_doc/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as ppath;
import 'package:path_provider/path_provider.dart';

import '../com_constants/value_constant.dart';
import '../model/Image_detail.dart';
import '../service/google_drive.dart';
import 'loading_indicator_dialog.dart';

class SummaryViewScreen extends StatefulWidget {
  const SummaryViewScreen({Key? key}) : super(key: key);

  @override
  State<SummaryViewScreen> createState() => _SummaryViewScreen();
}

class _SummaryViewScreen extends State<SummaryViewScreen> {
  getGoogleHttpClient() {}
  final googleDrive = GoogleDrive();
  var dirPath;
  List<ImageDetail> tableData = [];
  List<ImageDetail> tableDataList = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  DateTimeRange? _selectedDateRange;

  // This function will be triggered when the floating button is pressed
  void _show() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2022, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      currentDate: DateTime.now(),
      saveText: 'Search',
    );

    if (result != null) {
      // Rebuild the UI
      print(result.start.toString());
      setState(() {
        _selectedDateRange = result;
      });

      searchDataaa(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Document Status'),
            backgroundColor: Colors.black87,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.redAccent,
                height: 4.0,
              ),
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Start date
                    Text(
                      "Start date: ${_selectedDateRange == null ? 'YYYY-MM-DD' : _selectedDateRange?.start.toString().split(' ')[0]}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    // End date
                    Text(
                        "End Date : ${_selectedDateRange == null ? 'YYYY-MM-DD' : _selectedDateRange?.end.toString().split(' ')[0]}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  fixedSize: const Size(90, 25),
                  side: const BorderSide(
                    width: 6,
                    color: Colors.red,
                    style: BorderStyle.solid,
                  ),
                ),
                onPressed: () => {_show()},
                child: const Text(
                  'Date',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                    alignment: Alignment.topCenter, child: getTableRow()),
              ),
            ],
          )),
    );
  }

  void searchDataaa(BuildContext context) async {
    // setState(() {
    tableData = await getAllTableData(context);
    // });
  }

  Table getTableRow() {
    // List<ImageDetail> tableData = getTableData();

    print('tableData size==${tableData.length}');

    return Table(
      border: TableBorder.all(),
      columnWidths: const {
        0: FractionColumnWidth(.05),
        1: FractionColumnWidth(.25),
        2: FractionColumnWidth(0.15),
        3: FractionColumnWidth(.25),
        4: FractionColumnWidth(.25),
      },
      children: [
        TableRow(children: [
          tableCell('#'),
          tableCell('Create Date/Time'),
          tableCell('Upload'),
          tableCell('Folder Name'),
          tableCell('Upload Date/Time'),
        ]),
        for (var imageDetail in tableData)
          TableRow(children: [
            tableCell((tableData.indexOf(imageDetail) + 1).toString()),
            tableCell(imageDetail.createDateTime),
            tableCell(imageDetail.isUpload),
            tableCell(imageDetail.folderName),
            tableCell(imageDetail.uploadDateTime),
          ])
      ],
    );
  }

  void initData() async {
    dirPath = await getApplicationSupportDirectory();
    String all_images_folder_path = "${dirPath?.path}/$doc_base_folder";
    CommonFunctions().deleteEmptyImageFolder(all_images_folder_path);
    // setState(() {
    //   searchDataaa();
    // });
  }

  Future<List<ImageDetail>> getAllTableData(BuildContext context) async {
    try {
      LoadingIndicatorDialog loading = LoadingIndicatorDialog();
      loading.show(context);
      List<ImageDetail> dataList = [];

      String all_images_folder_path = "${dirPath?.path}/$doc_base_folder";
      print('all_images_folder_path======$all_images_folder_path');
      var client = await googleDrive.getNewHttpClient();
      var driveApi = drive.DriveApi(client);

      var all_folders = Directory(all_images_folder_path).listSync();
      for (var xfolder in all_folders) {
        var one_folder = Directory(xfolder.path).listSync();
        for (var imges in one_folder) {
          String image_name = ppath.basename(imges.path);
          print('imageName======$image_name'); //2023-02-04 15:20:05.126348.png

          String lastFolder =
              xfolder.path.split('/')[xfolder.path.split('/').length - 1];

          print('last folder===$lastFolder');

          var googleDriveImgesNamesList =
              await googleDrive.googleDriveImgesNamesList(driveApi, lastFolder);

          if (googleDriveImgesNamesList != null) {
            for (drive.File item in googleDriveImgesNamesList!) {
              print(
                  'FileN1122212221112122222sme====FileN1122212221112122222sme${item.name}');

              if (image_name.toString() == item.name) {
                String formattedDate = '';
                if (item.createdTime != null) {
                  formattedDate = DateFormat('yyyy-MM-dd – HH:mm:ss')
                      .format(item.createdTime!);
                }

                dataList.add(ImageDetail(
                    createDateTime: image_name.split('.')[0],
                    isUpload: 'Yes',
                    folderName: lastFolder,
                    uploadDateTime: formattedDate));
              } else {
                dataList.add(ImageDetail(
                    createDateTime: image_name.split('.')[0],
                    isUpload: 'No',
                    folderName: lastFolder,
                    uploadDateTime: '-'));
              }
            }
          }
        }
      }

      client.close();

      setState(() {
        tableDataList = dataList;
      });
      loading.dismiss();

      return dataList;
    } on Exception catch (e) {
      print('folder_creattion_error===$e');
      return [];
    }
  }

  Widget tableCell(String name) {
    return Text(
      name,
      textAlign: TextAlign.center,
    );
  }
}
