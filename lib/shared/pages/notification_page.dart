import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/service/payment_method_service.dart';
import 'package:spp_app/shared/helpers.dart';
import 'package:spp_app/shared/pages/detail_payment_page.dart';
import 'package:spp_app/shared/widgets/home_latest_transaction_item.dart';

import '../../blocs/auth/auth_bloc.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class AppAssets {
  static const String transactionIconUrl = 'assets/ic_transaction_cat3.png';
}

class _NotificationPageState extends State<NotificationPage> {
  ScrollController _scrollController = ScrollController();
  int _loadMoreCount = 5;
  List<TransactionFormModel> _notificationList = [];
  bool _isLoadingMore = false;
  int _displayedTransactionsCount = 5;
  bool _isLoadingShowMore = false;
  String? _selectedStatus;
  bool isSearchVisible = false;
  DateTime? startDate;
  DateTime? endDate;
  bool isSnackbarShown = false;
  final nisController = TextEditingController(text: '');
  final status = TextEditingController(text: '');
  final thn_akademik = TextEditingController(text: '');
  bool isConnected = true;
  bool isLoadingData = false;
  List<TransactionFormModel> filteredTransactions = [];
  String searchQuery = '';
  int _initialVisibleTransactionsCount = 5;

  Future<List<TransactionFormModel>> filterStatus(
      String nipd, String status) async {
    try {
      final res = await http.post(
        Uri.parse('https://arrahman.site/spp-web/getpayments'),
        headers: {'Authorization': 'Bearer KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9'},
        body: {'nipd': nipd, 'status': status, 'sort': '-created_at'},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        if (data.isNotEmpty) {
          List<TransactionFormModel> transactions = data
              .map((transaction) => TransactionFormModel.fromJson(transaction))
              .toList();
          return transactions;
        } else {
          throw 'Data tidak ditemukan';
        }
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

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

        if (filteredTransactions.isEmpty) {
          showCustomSnackbar(context, 'Data Tidak Ditemukan');
        }
      } catch (e) {
        if (mounted) {
          showCustomSnackbar(context, 'Data Tidak Ditemukan');
          setState(() {
            filteredTransactions = [];
          });
        }
      }
    }
  }

  Future<void> _getTransactions() async {
    try {
      final transactions =
          await PaymentMethodService().getTransaction(nisController.text);

      if (mounted) {
        setState(() {
          filteredTransactions = [];
        });
      }

      if (transactions.isEmpty) {
        showCustomSnackbar(context, 'Data Tidak Ditemukan');
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(context, 'Data Tidak Ditemukan');
        setState(() {
          filteredTransactions = [];
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nipd!;
    }
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<TransactionFormModel>> _getFilteredTransactions() async {
    try {
      List<TransactionFormModel> transactions = [];
      if (startDate != null && endDate != null) {
        final filteredTransactions =
            await PaymentMethodService().getTransactionDate(
          nisController.text,
          startDate!,
          endDate!,
        );
        transactions.addAll(filteredTransactions);
      } else {
        transactions =
            await PaymentMethodService().getTransaction(nisController.text);
      }

      return transactions;
    } catch (e) {
      print('getFilteredTransactions error: $e');
      throw e;
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
            icon: Icon(Icons.date_range_outlined),
            onPressed: _onFilterPressed,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _selectedStatus = null;
                searchQuery = '';
                startDate = null;
                endDate = null;
                _displayedTransactionsCount = _initialVisibleTransactionsCount;
              });

              _getTransactions();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearchVisible = !isSearchVisible;
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Visibility(
            visible: isSearchVisible,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        hintText: 'Cari Tahun Akademik & Keterangan',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedStatus = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        value: '2',
                        child: Text('Diterima'),
                      ),
                      DropdownMenuItem<String>(
                        value: '0',
                        child: Text('Ditolak'),
                      ),
                      DropdownMenuItem<String>(
                        value: '1',
                        child: Text('Pending'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Cari Status Pengajuan',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildFilteredTransactions(),
        ],
      ),
    );
  }

  Widget buildFilteredTransactions() {
    return Container(
      margin: const EdgeInsets.only(top: 26),
      child: FutureBuilder<List<TransactionFormModel>>(
        future: _getFilteredTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          } else if (snapshot.hasError) {
            return _buildNoData();
          } else if (snapshot.hasData) {
            List<TransactionFormModel> transactions = snapshot.data!;

            if (_selectedStatus != null) {
              transactions = transactions.where((transaction) {
                return transaction.status == _selectedStatus;
              }).toList();
            }

            if (searchQuery.isNotEmpty) {
              transactions = transactions
                  .where((transaction) =>
                      transaction.keterangan!
                          .toLowerCase()
                          .contains(searchQuery) ||
                      transaction.thn_akademik!
                          .toLowerCase()
                          .contains(searchQuery))
                  .toList();
            }

            if (transactions.isEmpty) {
              return _buildNoData();
            }

            return ListView(
              shrinkWrap: true,
              controller: _scrollController,
              children: [
                ...transactions.take(_displayedTransactionsCount).map(
                      (transaction) => Padding(
                        padding: const EdgeInsets.only(bottom: 1.0),
                        child: _buildTransactionItem(transaction),
                      ),
                    ),
                if (transactions.length > _displayedTransactionsCount)
                  TextButton(
                    onPressed: () {
                      if (!_isLoadingMore && !_isLoadingShowMore) {
                        setState(() {
                          _isLoadingMore = true;
                          _displayedTransactionsCount += _loadMoreCount;
                        });
                        _loadMoreTransactions();
                      }
                    },
                    child: Text(
                      'Show More Data...',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            );
          } else {
            return _buildNoData();
          }
        },
      ),
    );
  }

  Widget _buildLoading() {
    return Container(
      margin: EdgeInsets.only(top: 250.0),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          strokeWidth: 3,
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
              title: "Upload Bukti Pembayaran",
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

  void _loadMoreTransactions() async {
    try {
      setState(() {
        _isLoadingMore = true;
        _isLoadingShowMore = true;
      });

      final transactions = await PaymentMethodService().getTransaction(
        nisController.text,
      );

      if (mounted) {
        setState(() {
          _notificationList.addAll(transactions);
          _isLoadingMore = false;
          _isLoadingShowMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _isLoadingShowMore = false;
        });
      }
      showCustomSnackbar(context, 'Failed to load more transactions');
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_isLoadingMore && !_isLoadingShowMore) {
        setState(() {
          _isLoadingMore = true;
          _displayedTransactionsCount += _loadMoreCount;
        });
        _loadMoreTransactions();
      }
    }
  }

  Widget _buildNoData() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/rokets.gif',
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
