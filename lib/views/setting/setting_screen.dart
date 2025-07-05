import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

class SettingScreen extends StatelessWidget {
  List settingList = [
    {"icon": Icons.info_outline_rounded, "title": "About Us"},
    {"icon": Icons.block, "title": "Block Account"},
    {"icon": Icons.notifications_outlined, "title": "notification"},
    {"icon": Icons.privacy_tip_outlined, "title": "Privacy Policy"},
    {"icon": Icons.featured_play_list_sharp, "title": "Terms & Conditions"},
    {"icon": Icons.support_agent, "title": "Support"},
    {"icon": Icons.logout, "title": "log out"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: AppStyles.custom(size: 50, weight: FontWeight.bold),
                ),
                SizedBox(height: 20),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: settingList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (settingList[index]['title'] == 'log out') {
                        } else {
                          Get.to(settinglistinfo(settingList: settingList));
                        }
                      },

                      child: settingslist(
                        icon: settingList[index]["icon"],
                        title: settingList[index]["title"],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//setting list info
class settinglistinfo extends StatelessWidget {
  final List settingList;

  const settinglistinfo({super.key, required this.settingList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setting"),
        centerTitle: true,
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("${settingList[0]["title"]}")],
          ),
        ),
      ),
    );
  }
}

//settingslist
class settingslist extends StatelessWidget {
  final IconData icon;
  final String title;

  const settingslist({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Material(
        color: AppTheme.grey500,
        borderRadius: BorderRadius.circular(20),

        child: InkWell(
          borderRadius: BorderRadius.circular(20),

          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(),
            child: Center(
              child: ListTile(
                leading: Icon(
                  icon,
                  color:
                      title == "log out"
                          ? AppTheme.primaryRed
                          : AppTheme.backgroundDark,
                ),
                title: Text(
                  title,
                  style: AppStyles.custom(
                    weight: FontWeight.bold,
                    size: 20,
                    color:
                        title == "log out"
                            ? AppTheme.primaryRed
                            : AppTheme.backgroundDark,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
