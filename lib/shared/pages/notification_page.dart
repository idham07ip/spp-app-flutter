// ignore_for_file: unused_field, unused_import

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/blocs/transaction/transaction_bloc.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/service/payment_method_service.dart';
import 'package:spp_app/shared/helpers.dart';
import 'package:spp_app/shared/pages/detail_payment_page.dart';
import 'package:spp_app/shared/widgets/builder.dart';

import 'package:spp_app/shared/widgets/home_latest_transaction_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class AppAssets {
  static const String transactionIconUrl = 'assets/ic_transaction_cat3.png';
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isFilterApplied = false;
  DateTime? startDate;
  DateTime? endDate;
  String _selectedSortBy = 'Latest';
  bool isSnackbarShown = false;
  final nisController = TextEditingController(text: '');
  bool isConnected = true;
  bool isDataRefreshing = false;
  bool isShowingSnackBar = false;
  bool isLoadingData = false;
  List<TransactionFormModel> filteredTransactions = [];

  void _onFilterPressed() async {
    final selectedDates = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1970),
      lastDate: DateTime(2300),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.green,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? Container(),
        );
      },
    );

    if (selectedDates != null && mounted) {
      setState(() {
        startDate = selectedDates.start;
        endDate = selectedDates.end;
      });

      try {
        final transactions = await PaymentMethodService().getTransactionDate(
          nisController.text,
          startDate!,
          endDate!,
        );

        if (mounted) {
          setState(() {
            filteredTransactions = transactions;
          });
        }

        print('filteredTransactions: $filteredTransactions');

        if (filteredTransactions.isEmpty) {
          showCustomSnackbar(context, 'Data Tidak Ditemukan');
        }
      } catch (e) {
        print('getTransactionDate error: $e');
        if (mounted) {
          showCustomSnackbar(context, 'Data Tidak Ditemukan');
          setState(() {
            filteredTransactions = [];
          });
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nis!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: _onFilterPressed,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          buildFilteredTransactions(filteredTransactions),
        ],
      ),
    );
  }

  Widget buildFilteredTransactions(
      Iterable<TransactionFormModel> filteredTransactions) {
    return Container(
      margin: const EdgeInsets.only(top: 26),
      child: BlocProvider(
        create: (context) =>
            TransactionBloc()..add(TransactionGet(nis: nisController.text)),
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionFailed) {
              return _buildErrorImage();
            } else if (state is TransactionSuccess) {
              List<TransactionFormModel> transactions =
                  filteredTransactions.isNotEmpty
                      ? filteredTransactions.toList()
                      : state.transactions;
              return _buildTransactionList(transactions);
            }
            return Container(
              margin: EdgeInsets.only(top: 200.0),
              child: Center(
                child: Image.asset(
                  'assets/loading.gif',
                  gaplessPlayback: true,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionFormModel> transactions) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Center(
        child: Column(
          children: transactions.map((transaction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: _buildTransactionItem(transaction),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(TransactionFormModel transaction) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: HomeLatestTransactionItem(
              iconUrl: AppAssets.transactionIconUrl,
              title: 'Foto Bukti Transfer Pembayaran',
              transactions: transaction,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetails(
                      nis: nisController.text,
                      transaction: transaction,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

// Constants

  Widget _buildErrorImage() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/no_internet.png',
            width: 500,
            height: 500,
          ),
          Text(
            'Data tidak ditemukan',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
