import 'package:flutter/material.dart';
import 'package:smartbecho/utils/app_colors.dart' show AppTheme;
import 'package:smartbecho/utils/app_styles.dart';

class MonthYearDropdown extends StatelessWidget {
  final int? selectedMonth;
  final int? selectedYear;
  final Function(int?) onMonthChanged;
  final Function(int?) onYearChanged;
  final bool showAllOption;
  final String monthLabel;
  final String yearLabel;

  const MonthYearDropdown({
    Key? key,
    this.selectedMonth,
    this.selectedYear,
    required this.onMonthChanged,
    required this.onYearChanged,
    this.showAllOption = true,
    this.monthLabel = 'Month',
    this.yearLabel = 'Year',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Month Dropdown
        Expanded(
          child: Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.greyOpacity02),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: selectedMonth,
                hint: Text(
                  monthLabel,
                  style: AppStyles.custom(size: 14, color: AppTheme.grey500),
                ),
                items: _buildMonthItems(),
                onChanged: onMonthChanged,
                icon: Icon(Icons.keyboard_arrow_down, size: 20),
                isExpanded: true,
                style: AppStyles.custom(size: 14, color: AppTheme.black87),
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        // Year Dropdown
        Expanded(
          child: Container(
            height: 44,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppTheme.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.greyOpacity02),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int?>(
                value: selectedYear,
                hint: Text(
                  yearLabel,
                  style: AppStyles.custom(size: 14, color: AppTheme.grey500),
                ),
                items: _buildYearItems(),
                onChanged: onYearChanged,
                icon: Icon(Icons.keyboard_arrow_down, size: 20),
                isExpanded: true,
                style: AppStyles.custom(size: 14, color: AppTheme.black87),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<int?>> _buildMonthItems() {
    List<DropdownMenuItem<int?>> items = [];

    if (showAllOption) {
      items.add(
        DropdownMenuItem<int?>(
          value: null,
          child: Text('All Months', style: AppStyles.custom(size: 14)),
        ),
      );
    }

    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    for (int i = 0; i < months.length; i++) {
      items.add(
        DropdownMenuItem<int?>(
          value: i + 1,
          child: Text(months[i], style: AppStyles.custom(size: 14)),
        ),
      );
    }

    return items;
  }

  List<DropdownMenuItem<int?>> _buildYearItems() {
    List<DropdownMenuItem<int?>> items = [];

    if (showAllOption) {
      items.add(
        DropdownMenuItem<int?>(
          value: null,
          child: Text('All Years', style: AppStyles.custom(size: 14)),
        ),
      );
    }

    final currentYear = DateTime.now().year;

    // Generate years from 2020 to current year + 2
    for (int year = 2020; year <= currentYear + 2; year++) {
      items.add(
        DropdownMenuItem<int?>(
          value: year,
          child: Text(year.toString(), style: AppStyles.custom(size: 14)),
        ),
      );
    }

    return items.reversed.toList();
  }
}
