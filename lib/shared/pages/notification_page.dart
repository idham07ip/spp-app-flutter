import 'package:flutter/material.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/home_latest_transaction_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        toolbarHeight: 70,
        title: const Text(
          'Notifikasi',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          buildLatestTransactions(),
        ],
      ),
    );
  }

  Widget buildLatestTransactions() {
    return Container(
      margin: const EdgeInsets.only(
        top: 26,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 2),
            margin: const EdgeInsets.only(
              top: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: HomeLatestTransactionItem(
              iconUrl: 'assets/ic_transaction_cat1.png',
              title: 'SPP',
              time: '19.20',
              value: 'Rp. 300.000;',
              onTap: () {
                Navigator.pushNamed(context, '/detail_payment');
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 2),
            margin: const EdgeInsets.only(
              top: 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: Column(
              children: [
                //Top Up
                HomeLatestTransactionItem(
                  iconUrl: 'assets/ic_transaction_cat2.png',
                  title: 'Tabungan',
                  time: 'Yesterday',
                  value: '+ 550.000',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
