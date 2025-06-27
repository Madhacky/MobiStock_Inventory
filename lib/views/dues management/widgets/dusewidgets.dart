import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart';

class DuesWidget {
 

  static Widget container({required Widget child, double? height}) {
    return Container(
      height: height,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black, // Change to your desired color
          width: 2, // Change to your desired border width
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Center(child: child),
    );
  }

  static Widget card({
    required String title,
    required String amount,
    Color? amountColor = AppTheme.backgroundLight,
  }) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black, // Change to your desired color
          width: 2, // Change to your desired border width
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: TextStyle(color: AppTheme.backgroundDark)),
          SizedBox(height: 8),
          Text(amount, style: TextStyle(fontSize: 24, color: amountColor)),
        ],
      ),
    );
  }

  static Widget button({
    required text,
    required Function() onTap,
    IconData? icon,
    Color? backgroundColor = Colors.transparent,
    Color? textColor,
    Color? borderside,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: textColor),
        label: Text(text, style: TextStyle(color: textColor)),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: BorderSide(
            color: borderside ?? Colors.transparent,
            width: 2,
          ), // Set border color and width here
        ),
      ),
    );
  }

  static Widget linearProgresbar() {
    return Container(
      padding: EdgeInsets.all(8),
      child: LinearPercentIndicator(
        // center: Text("sfsf"),
        // width: 100.0,
        animation: true,
        animationDuration: 1000,
        lineHeight: 20,
        percent: 0.5,
        backgroundColor: Colors.grey,
        progressColor: AppTheme.primaryLight,
        barRadius: Radius.circular(20),
      ),
    );
  }

  static Widget circularProgresbar() {
    return Container(
      padding: EdgeInsets.all(8),
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: 0.4,
        center: Text("100%"),
        progressColor: AppTheme.primaryLight,
        backgroundColor: Colors.grey,
      ),
    );
  }

  static Widget dateShow({
    required String title,
    required String date,
    required IconData icon,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppTheme.backgroundDark,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppTheme.backgroundDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
