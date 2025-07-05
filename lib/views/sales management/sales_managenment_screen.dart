import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_styles.dart';

class SalesManagenmentScreen extends StatefulWidget {
  const SalesManagenmentScreen({super.key});

  @override
  State<SalesManagenmentScreen> createState() => _SalesManagenmentScreenState();
}

class _SalesManagenmentScreenState extends State<SalesManagenmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Text("Hello World!", style: AppStyles.custom())),
      appBar: AppBar(
        title: Text('Sales Management', style: AppStyles.custom()),
      ),
    );
  }
}
