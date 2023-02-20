import 'package:ccl_doc/ui/summary_view_screen.dart';
import 'package:flutter/material.dart';

import '../com_constants/color_constant.dart';
import '../com_constants/styles_constant.dart';
import '../ui/folder_create_screen.dart';
import '../utils/common_ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.black87,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.redAccent,
            height: 4.0,
          ),
        ),
      ),
      body: Center(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [
                CommonUI().homeScreenIcon(() {}, kIcon_help, kHomeIcon_help),
                CommonUI().homeScreenIcon(
                  () {
                    _onDocHistory(context);
                  },
                  kIcon_summary,
                  kHomeIcon_uploadSummary,
                ),
              ]),
              Column(children: [
                CommonUI().homeScreenIcon(
                  () {
                    _onDocUpload(context);
                  },
                  kIcon_uploadFile,
                  kHomeIcon_docUpload,
                ),
              ])
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black87,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.manage_accounts,
                    size: 70,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'CCLK App',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'malithm',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: kIconColor,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.upload_file,
                color: kIconColor,
              ),
              title: Text(kHomeIcon_docUpload),
              onTap: () {
                _onDocUpload(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.summarize_outlined,
                color: kIconColor,
              ),
              title: Text(kHomeIcon_uploadSummary),
              onTap: () {
                _onDocHistory(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.live_help_outlined,
                color: kIconColor,
              ),
              title: Text(kHomeIcon_help),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: kIconColor,
              ),
              title: const Text('Log Out'),
              onTap: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  _onDocUpload(BuildContext context) {
    CommonUI()
        .showConfirmAlertDialog(context, "Do you want capture new Images ?")
        .then((isConfirm) => {
              if (isConfirm)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FolderCreateScreen()))
                }
              else
                {Navigator.pop(context)}
            });
  }

  _onDocHistory(BuildContext context) {
    CommonUI()
        .showConfirmAlertDialog(context, "Do you want view Doc Status history?")
        .then((isConfirm) => {
              if (isConfirm)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SummaryViewScreen()))
                }
              else
                {Navigator.pop(context)}
            });
  }
}
