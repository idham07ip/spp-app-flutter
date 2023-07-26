// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/shared/theme.dart';

class HomeLatestTransactionItem extends StatelessWidget {
  final String iconUrl;
  final String title;
  final VoidCallback? onTap;
  final TransactionFormModel transactions;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const HomeLatestTransactionItem({
    Key? key,
    required this.iconUrl,
    required this.title,
    required this.transactions,
    this.onTap,
    this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createdAt = transactions.created_at ?? DateTime.now();
    final now = DateTime.now();
    String keterangan;
    String formattedDate;

    String _getKeterangan() {
      if (transactions.keterangan == null || transactions.keterangan!.isEmpty) {
        return "No keterangan";
      } else if (transactions.keterangan!.length < 20) {
        return transactions.keterangan!;
      } else {
        return '${transactions.keterangan!.substring(0, 20)}...';
      }
    }

    if (isToday(createdAt, now)) {
      formattedDate = "Hari ini";
    } else if (isYesterday(createdAt, now)) {
      formattedDate = "Kemarin";
    } else {
      formattedDate = DateFormat('dd MMMM yyyy').format(createdAt);
    }

    formattedDate += " " + DateFormat('HH.mm').format(createdAt);

    return TextButton(
      onPressed: onTap,
      child: Container(
        padding: padding,
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Image.asset(iconUrl, width: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: blackTextStyle.copyWith(
                      fontSize: 15,
                      fontWeight: medium,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formattedDate,
                    style: greyTextStyle.copyWith(fontSize: 10),
                  ),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            // Text(
            //   '${transactions.total_amount != null ? NumberFormat.currency(locale: 'id_ID', decimalDigits: 0, symbol: 'Rp ').format(double.parse(transactions.total_amount!)) : 'Rp0'}',
            //   style: blackTextStyle.copyWith(fontSize: 16, fontWeight: medium),
            // ),
          ],
        ),
      ),
    );
  }

  bool isToday(DateTime createdAt, DateTime now) {
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day;
  }

  bool isYesterday(DateTime createdAt, DateTime now) {
    return createdAt.year == now.year &&
        createdAt.month == now.month &&
        createdAt.day == now.day - 1;
  }
}
