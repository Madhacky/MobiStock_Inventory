import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartbecho/models/bill%20history/stock_stats_reponse_model.dart';
enum StockWhenAdded{today,thisMonth}
void showStockItemsDialog(BuildContext context, StockStats stockStats,StockWhenAdded query) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.all(20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                "Stock Items",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
             
              const Divider(height: 0),
              Column(
                children: [
                  query==StockWhenAdded.today?
                  _buildItemList(stockStats.todayItems):
                  _buildItemList(stockStats.thisMonthItems),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildItemList(List<StockItemModel> items) {
  if (items.isEmpty) {
    return const Center(child: Text("No items found."));
  }

  return ListView.separated(
    shrinkWrap: true,
    padding: const EdgeInsets.all(12),
    itemCount: items.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final item = items[index];

  String dateFormatted = item.createdDate.isNotEmpty
    ? DateFormat('dd MMM yyyy').format(
        DateTime.parse(item.createdDate),
      )
    : "N/A";

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Text(item.qty.toString(), style: const TextStyle(color: Colors.blue)),
          ),
          title: Text(
            item.model,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${item.company} • ${item.color} • ${item.ram}/${item.rom} GB"),
              Text("Price: ₹${item.sellingPrice.toStringAsFixed(2)}"),
              Text("Date: $dateFormatted"),
            ],
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Optional: Add item detail navigation here
          },
        ),
      );
    },
  );
}
