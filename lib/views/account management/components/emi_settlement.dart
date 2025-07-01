import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smartbecho/views/account%20management/widgets/header_widget.dart';

class EmiSettlement extends StatelessWidget {
  const EmiSettlement({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('EMI Settlements'),
          SizedBox(height: 16),
        //  _buildEmiSummaryCards(),
          SizedBox(height: 24),
          _buildEmiTransactionsList(),
        ],
      ),
    );
  }
   Widget _buildEmiTransactionsList() {
    final emiTransactions = [
      {
        'bank': 'HDFC Bank',
        'amount': '₹5,000',
        'date': '2024-01-15',
        'status': 'Completed',
        'color': Color(0xFF51CF66),
      },
      {
        'bank': 'ICICI Bank',
        'amount': '₹3,500',
        'date': '2024-01-10',
        'status': 'Pending',
        'color': Color(0xFFFF9500),
      },
      {
        'bank': 'SBI Bank',
        'amount': '₹4,200',
        'date': '2024-01-05',
        'status': 'Completed',
        'color': Color(0xFF51CF66),
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Recent EMI Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...emiTransactions.map((transaction) => _buildEmiTransactionCard(
            transaction['bank'] as String,
            transaction['amount'] as String,
            transaction['date'] as String,
            transaction['status'] as String,
            transaction['color'] as Color,
          )).toList(),
        ],
      ),
    );
  }
  
  Widget _buildEmiTransactionCard(String bank, String amount, String date, String status, Color statusColor) {
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF9C27B0).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.account_balance,
              color: Color(0xFF9C27B0),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}