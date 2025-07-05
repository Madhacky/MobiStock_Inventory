import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/views/setting/setting_screen.dart';
import 'package:smartbecho/views/stock_overview/stock_overview_api.dart';
import 'package:smartbecho/views/stock_overview/stock_overview_model.dart';

class StockOverviwe extends StatefulWidget {
  @override
  State<StockOverviwe> createState() => _OverviweState();
}

class _OverviweState extends State<StockOverviwe> {
  late Future<List<StockOverviewModel>> stockoverviewFuture;
  @override
  void initState() {
    stockoverviewFuture = StockOverviewApi().getStockOverview();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _stockOverviwe(),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  height: 350,
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stockOverviwe() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 5),
      height: 350,
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.add_box_sharp,
                size: 30,
                color: AppTheme.backgroundDark,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Stock Overviwe",
                  style: AppStyles.custom(size: 30, weight: FontWeight.bold),
                ),
              ),
            ],
          ),

          Text(
            "Total Stock: 202 Units",
            style: AppStyles.custom(size: 20, weight: FontWeight.w900),
          ),
          SizedBox(height: 10),
          Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.blueGrey[400]
            ),

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Product List",
                    style: AppStyles.custom(size: 20, weight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: stockoverviewFuture,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 23,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(SettingScreen());
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.deepPurple.withOpacity(.1),
                              ),

                              child: ListTile(
                                leading: Text(
                                  "OnePlus",
                                  style: AppStyles.custom(
                                    size: 20,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                trailing: Text(
                                  "70 Units",
                                  style: AppStyles.custom(
                                    size: 20,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
