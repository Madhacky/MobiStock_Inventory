import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/inventory%20controllers/inventory_stock_comtroller.dart';
import 'package:smartbecho/utils/app_styles.dart';

class LowStockAlertsCard extends StatelessWidget {
  final InventorySalesStockController controller = Get.find<InventorySalesStockController>();

  @override
  Widget build(BuildContext context) {
      final alerts = controller.lowStockAlerts.value;

    return
   

       Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  'Low Stock Alerts',
                  style: AppStyles.custom(  color: Color(0xFF1A1A1A),
                size: 20,
                weight: FontWeight.w600,),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.totalAlerts}',
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Critical Alerts
            if (alerts!.payload.critical.isNotEmpty) ...[
              ...alerts.payload.critical.map((alert) => _buildAlertItem(
                alert,
                const Color(0xFFEF4444),
                'Critical:',
                Icons.error_outline,
              )),
              const SizedBox(height: 8),
            ],

            // Low Stock Alerts
            if (alerts.payload.low.isNotEmpty) ...[
              ...alerts.payload.low.map((alert) => _buildAlertItem(
                alert,
                const Color(0xFFF59E0B),
                'Low:',
                Icons.warning_amber_outlined,
              )),
              const SizedBox(height: 8),
            ],

            // Out of Stock Alerts
            if (alerts.payload.outOfStock.isNotEmpty) ...[
              ...alerts.payload.outOfStock.map((alert) => _buildAlertItem(
                'Out of Stock: $alert',
                const Color(0xFFEF4444),
                '',
                Icons.cancel_outlined,
              )),
            ],

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'See Restock Reminder',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    
  }

  Widget _buildAlertItem(String text, Color color, String prefix, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$prefix $text',
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}