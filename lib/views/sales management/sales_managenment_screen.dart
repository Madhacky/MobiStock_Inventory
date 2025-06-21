import 'package:flutter/material.dart';

class SalesManagenmentScreen extends StatefulWidget {
  const SalesManagenmentScreen({super.key});

  @override
  State<SalesManagenmentScreen> createState() => _SalesManagenmentScreenState();
}

class _SalesManagenmentScreenState extends State<SalesManagenmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
      appBar: AppBar(title: Text('Sales Management')),
    );
  }
}
