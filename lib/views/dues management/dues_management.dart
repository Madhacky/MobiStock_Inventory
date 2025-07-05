import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/views/dues%20management/widgets/dusewidgets.dart';

class DuesManagement extends StatefulWidget {
  const DuesManagement({super.key});

  @override
  State<DuesManagement> createState() => _DuesManagementState();
}

class _DuesManagementState extends State<DuesManagement> {
  List<Map<String, dynamic>> duesList = [
    {
      "value": "₹4356",
      "icon": Icons.check_box,
      "color": Color(0xff28C76F),
      "titel": "Total Collected",
    },
    {
      "value": "₹4356",
      "icon": Icons.warning_rounded,
      "color": Color(0xffFF4C51),
      "titel": "Total Remaining",
    },

    {
      "value": "₹4356",
      "icon": Icons.supervisor_account,
      "color": Color(0xffFF9F43),
      "titel": "Today's Retrieval",
    },
    {
      "value": "₹4356",
      "icon": Icons.date_range,
      "color": Color(0xff00BAD1),
      "titel": "Today's Retrieval",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: duesList.length,
                  itemBuilder: (context, index) {
                    final item = duesList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 180,
                        child: _buildcard(
                          title: item['titel'],
                          iconData: item['icon'] as IconData,
                          color: item['color'] as Color,
                          value: item['value'],
                        ),
                      ),
                    );
                  },
                ),
              ),

              ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(dusecoustomerdetailscard());
                    },
                    child: dusecoustomerlist(),
                  );
                },
                // Add this to prevent ListView.builder from having unbounded height inside SingleChildScrollView
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),

              // dusecoustomerdetailscard(),
              SizedBox(height: 10),
              // dusecoustomerlist(),
            ],
          ),
        ),
      ),
    );
  }
}

class dusecoustomerdetailscard extends StatelessWidget {
  const dusecoustomerdetailscard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  // color: Color(0xff2F3349),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Customer Details
                          DuesWidget.container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: Text(
                                    "DK",
                                    style: AppStyles.custom(
                                      size: 20,
                                      color: AppTheme.backgroundDark,
                                    ),
                                  ),
                                ),

                                Column(
                                  children: [
                                    Text(
                                      "Default name",
                                      style: AppStyles.custom(
                                        size: 25,
                                        color: AppTheme.backgroundDark,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.blinds_closed,
                                          color: AppTheme.backgroundDark,
                                          size: 16.0,
                                        ),
                                        Text(
                                          " Bill  #",
                                          style: AppStyles.custom(
                                            size: 16,
                                            color: AppTheme.backgroundDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                DuesWidget.button(
                                  text: "Mark Paid",
                                  onTap: () {},
                                  // icon: Icons.check,
                                  // backgroundColor: AppTheme.successDark,
                                  // textColor: AppTheme.onSecondaryDark,
                                ),
                              ],
                            ),
                          ),

                          DuesWidget.container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Payment Progress",
                                      style: AppStyles.custom(
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "100.0%",
                                      style: AppStyles.custom(
                                        weight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                // DuesWidget.linearProgresbar(),
                              ],
                            ),
                          ),

                          Wrap(
                            children: [
                              DuesWidget.card(
                                title: "Total",
                                amount: "₹4356",
                                amountColor: AppTheme.backgroundDark,
                              ),
                              DuesWidget.card(
                                title: "Remaining",
                                amount: "₹ -4356",
                                amountColor: AppTheme.errorLight,
                              ),
                              DuesWidget.card(
                                title: "Collected",
                                amount: "₹4356",
                                amountColor: AppTheme.successDark,
                              ),
                            ],
                          ),
                          DuesWidget.container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                              children: [
                                DuesWidget.dateShow(
                                  title: "Due Date",
                                  date: "9/09/2025",
                                  icon: Icons.date_range,
                                  color: Color(0xff7367F0),
                                ),
                                DuesWidget.dateShow(
                                  title: "Retrieval",
                                  date: "9/09/2025",
                                  icon: Icons.timelapse_outlined,
                                  color: Color(0xff3498db),
                                ),
                              ],
                            ),
                          ),

                          DuesWidget.container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    DuesWidget.button(
                                      text: "Mark Paid",
                                      onTap: () {},
                                      icon: Icons.check,
                                      backgroundColor: AppTheme.successDark,
                                      textColor: AppTheme.onSecondaryDark,
                                    ),
                                    DuesWidget.button(
                                      text: "Partial",
                                      onTap: () {},
                                      icon: Icons.paid_outlined,
                                      backgroundColor: AppTheme.warningLight,
                                      textColor: AppTheme.onSecondaryDark,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    DuesWidget.button(
                                      text: "Call",
                                      onTap: () {},
                                      icon: Icons.call,
                                      //  backgroundColor: AppTheme.successDark,
                                      textColor: Color(0xff00BAD1),
                                      borderside: Color(0xff00BAD1),
                                    ),
                                    DuesWidget.button(
                                      text: "Notify",
                                      onTap: () {},
                                      icon: Icons.notifications_active,
                                      textColor: Color(0xff7367F0),
                                      borderside: Color(0xff7367F0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(height: 10),
                    // Text("Transaction History",style: AppStyles.custom(size: 20, weight:FontWeight.bold ,color:AppTheme.backgroundDark),),
                    // Divider(),
                    // ListView.builder(
                    //   itemCount: 12,
                    //   itemBuilder: (context, index) {
                    //   return dusepaymenthistorylist();
                    // },),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Payment History",
                style: AppStyles.custom(
                  size: 20,
                  weight: FontWeight.bold,
                  color: AppTheme.backgroundDark,
                ),
              ),
              Divider(),

              // ListView.builder(
              //   itemCount: 24,
              //   itemBuilder: (context, index) {
              //   return  dusepaymenthistorylist();
              // },),
              ListTile(
                leading: Text(
                  "Payment",
                  style: AppStyles.custom(
                    size: 20,
                    color: AppTheme.backgroundDark,
                    weight: FontWeight.bold,
                  ),
                ),
                trailing: Flexible(
                  child: Text(
                    "Name",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: AppStyles.custom(
                      size: 20,
                      color: AppTheme.backgroundDark,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  "Date",
                  style: AppStyles.custom(
                    size: 20,
                    color: AppTheme.backgroundDark,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                itemCount: 56,
                itemBuilder: (context, index) {
                  return dusepaymenthistorylist();
                },
                // Add this to prevent ListView.builder from having unbounded height inside SingleChildScrollView
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class dusepaymenthistorylist extends StatelessWidget {
  const dusepaymenthistorylist({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        "4000",
        style: AppStyles.custom(
          size: 25,
          color: AppTheme.successDark,
          weight: FontWeight.bold,
        ),
      ),
      trailing: Flexible(
        child: Text(
          "Suraj",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,

          style: AppStyles.custom(
            size: 20,
            color: AppTheme.backgroundDark,
            weight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        "20/06/2025",
        style: AppStyles.custom(
          color: AppTheme.backgroundDark,
          weight: FontWeight.bold,
        ),
      ),
    );
  }
}

class dusecoustomerlist extends StatelessWidget {
  const dusecoustomerlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50.0)),
        border: Border.all(color: AppTheme.backgroundDark),
      ),
      child: ListTile(
        leading: CircleAvatar(radius: 30, child: Text("DK")),
        title: Text(
          "Customer Name",
          style: AppStyles.custom(size: 20, weight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [Icon(Icons.date_range, size: 20), Text("Bill #")],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Remaining",
              style: AppStyles.custom(size: 15, color: AppTheme.backgroundDark),
            ),
            SizedBox(height: 8),
            Text(
              "₹ -4356",
              style: AppStyles.custom(
                size: 24,
                weight: FontWeight.bold,
                color: AppTheme.errorLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _buildcard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final String value;

  const _buildcard({
    // super.key,
    required this.title,
    required this.iconData,
    required this.color,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 140,
      // width: 140,
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity01,
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon(iconData, color: color, size: 50),
                Flexible(
                  child: Text(
                    title,
                    style: AppStyles.custom(
                      size: 12,
                      weight: FontWeight.bold,
                      color: AppTheme.grey600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(iconData, color: color, size: 18),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: AppStyles.custom(
                size: 20,
                weight: FontWeight.bold,
                color: AppTheme.grey600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "subtitle",
              style: AppStyles.custom(size: 10, color: AppTheme.grey500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
