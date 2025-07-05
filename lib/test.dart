import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartbecho/utils/app_colors.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(height: 100, width: 100, color: Color(0x0D9E9E9E)),
              Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.all(8),
                    width: 200,
                    height: 200,

                    // color:AppTheme.blue50Opacity30,
                    // color: Colors.black,
                    color: AppTheme.greyOpacity03,
                    // color: Colors.grey.withOpacity(0.03),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 200,
                    height: 200,
                    color: AppTheme.backgroundDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
