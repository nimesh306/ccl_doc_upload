import 'dart:io';

import 'package:ccl_doc/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as ppath;
import 'package:path_provider/path_provider.dart';

import '../com_constants/value_constant.dart';
import '../model/Image_detail.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({Key? key}) : super(key: key);

  @override
  State<SummaryView> createState() => _SummaryView();
}

class _SummaryView extends State<SummaryView> {
  getGoogleHttpClient() {}
  var dirPath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: Text('title'),
      ),
      body: Container(
        child: getTableRowxxx(),
      ),
    );
    ;
  }

  Table getTableRowxxx() {
    List<ImageDetail> tableData = getTableData();

    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FractionColumnWidth(.05),
        1: FractionColumnWidth(.2),
        2: FractionColumnWidth(.1),
        3: FractionColumnWidth(.2),
        4: FractionColumnWidth(.2),
      },
      children: [
        TableRow(children: [
          Text('#'),
          Text('Create Date/Time'),
          Text('Upload'),
          Text('Folder Name'),
          Text('Upload Date/Time'),
        ]),
        for (var imageDetail in tableData)
          TableRow(children: [
            Text((tableData.indexOf(imageDetail) + 1).toString()),
            Text(imageDetail.createDateTime),
            Text(imageDetail.isUpload),
            Text(imageDetail.folderName),
            Text(imageDetail.uploadDateTime),
          ])
      ],
    );
  }

  void initData() async {
    dirPath = await getApplicationSupportDirectory();
    String all_images_folder_path = "${dirPath?.path}/$doc_base_folder";
    await CommonFunctions().deleteEmptyImageFolder(all_images_folder_path);
  }

  List<ImageDetail> getTableData() {
    try {
      List<ImageDetail> dataList = [];

      String all_images_folder_path = "${dirPath?.path}/$doc_base_folder";

      var all_folders = Directory(all_images_folder_path).listSync();
      for (var xfolder in all_folders) {
        var one_folder = Directory(xfolder.path).listSync();
        for (var imges in one_folder) {
          String image_name = ppath.basename(imges.path);
          print('imageName======$image_name'); //2023-02-04 15:20:05.126348.png

          dataList.add(ImageDetail(
              createDateTime: image_name.split('.')[0],
              isUpload: 'No',
              folderName: ppath.basename(one_folder.toString()),
              uploadDateTime: '-'));
        }
      }

      return dataList;
    } on Exception catch (e) {
      print('folder_creattion_error===$e');
      return [];
    }
  }
}
