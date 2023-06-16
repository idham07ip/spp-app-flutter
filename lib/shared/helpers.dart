import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showCustomSnackBar(BuildContext context, String message, {Widget? icon}) {
  Future.delayed(Duration(milliseconds: 500)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) icon,
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  });
}

Future<void> showCustomSnackbar(BuildContext context, String message,
    {Widget? icon}) async {
  Future.delayed(Duration(milliseconds: 500)).then((_) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  });
}

String formatCurrency(num number) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  ).format(number);
}

String dateToMonthDate(DateTime date) {
  return DateFormat('MMMM dd').format(date);
}

String formatTransactionCurrency(num number) {
  return NumberFormat.currency(
    locale: 'id',
    symbol: '',
    decimalDigits: 0,
  ).format(number);
}
