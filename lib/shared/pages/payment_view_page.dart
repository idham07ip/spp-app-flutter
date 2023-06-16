import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:spp_app/model/pembayaran_form_model.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/shared/helpers.dart';
import 'package:spp_app/shared/pages/payment_page.dart';
import 'package:spp_app/shared/theme.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({Key? key}) : super(key: key);

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = true;
      });

      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        await showCustomSnackbar(context, 'Tidak Ada Koneksi Internet');
      } else {
        await Future.delayed(Duration(seconds: 2));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(
              data: PembayaranFormModel(),
              transactions: TransactionFormModel(),
            ),
          ),
        ).whenComplete(() {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 24,
            ),
            children: [
              // Widget lainnya
            ],
          ),
          Visibility(
            visible: _isLoading,
            child: Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
