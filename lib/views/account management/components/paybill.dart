import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Paybill extends StatelessWidget {
  const Paybill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: 48, color: Color(0xFF51CF66)),
            SizedBox(height: 16),
            Text(
              'Pay Bill',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Bill payment functionality will be implemented here',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}