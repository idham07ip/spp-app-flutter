// ignore_for_file: unused_field, unused_import

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/model/pembayaran_form_model.dart';
import 'package:spp_app/model/quotes_form_model.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/model/user_model.dart';
import 'package:spp_app/service/kata_motivasi.dart';
import 'package:spp_app/shared/pages/notification_page.dart';
import 'package:spp_app/shared/pages/payment_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spp_app/shared/pages/profile_page.dart';
import 'package:spp_app/shared/pages/statistic_page.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/pages/content_page.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final namaController = TextEditingController(text: '');
  final kelasController = TextEditingController(text: '');
  TextEditingController nisController = TextEditingController();
  TextEditingController tingkatController = TextEditingController();
  int _selectedTabIndex = 0;
  bool _hasInternetConnection = true;
  late StreamSubscription<InternetConnectionStatus> _connectionSubscription;
  Future<KataMotivasiFormModel>? _motivasiFuture;
  KataMotivasiFormModel? _cachedMotivasiData;

  @override
  void initState() {
    super.initState();
    _connectionSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      setState(() {
        _hasInternetConnection = status == InternetConnectionStatus.connected;
      });
    });

    _loadCachedData();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nipd ?? '';
      namaController.text = authState.user.nama_siswa ?? '';
      tingkatController.text = authState.user.instansi ?? '';
      kelasController.text = authState.user.kelas ?? '';
    }
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  void _onNavbarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      if (index == 0) {
        _loadCachedData();
      }
    });
  }

  void _loadCachedData() {
    if (_cachedMotivasiData != null) {
      _motivasiFuture = Future.value(_cachedMotivasiData);
      print('Cached data: $_cachedMotivasiData');
    } else {
      _motivasiFuture = KataMotivasi.getMotivasi();
      _motivasiFuture!.then((data) {
        _cachedMotivasiData = data;
        print('New data fetched: $_cachedMotivasiData');
      });
    }
  }

  final payment = PembayaranFormModel();
  final transactions = TransactionFormModel();
  final user = UserModel();

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[
      // Beranda Tab 1
      ContentPage(
        isFuture: _motivasiFuture, // Pass the future to ContentPage
      ),
      // Pembayaran Tab 2

      // PaymentChekout(),
      PaymentPage(
        data: payment,
        transactions: transactions,
      ),
      // // Notifikasi Tab 3
      // NotificationPage(),
      PieChartSample1(),
      // Setting Profile Tab 4
      ProfilePage(),
    ];

    final _bottomNavbarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Beranda',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.camera),
        label: 'Upload',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.graphic_eq_outlined),
        label: 'Statistic',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    final _bottomNavbar = BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: whiteColor,
      elevation: 0,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: _bottomNavbarItems,
      currentIndex: _selectedTabIndex,
      selectedItemColor: greenColor,
      unselectedItemColor: blackColor,
      onTap: _onNavbarTapped,
      selectedLabelStyle: greenTextStyle.copyWith(
        fontSize: 10,
        fontFamily: 'Poppins',
        fontWeight: medium,
      ),
      unselectedLabelStyle: blackTextStyle.copyWith(
        fontSize: 10,
        fontFamily: 'Poppins',
        fontWeight: medium,
      ),
    );

    // Cek Apabila Koneksi Tidak Tersedia
    if (!_hasInternetConnection) {
      return Scaffold(
        backgroundColor: greenColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/no_internet.png',
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 20),
              Text(
                'Tidak Ada Koneksi Internet \n Periksa Konektivitas Anda',
                style: TextStyle(fontSize: 20, color: whiteColor),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text(
            'Ketuk tombol sekali lagi untuk keluar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: const Duration(milliseconds: 1500),
          backgroundColor: Color(0xff22B07D),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.fromLTRB(60, 0, 60, 5),
          shape: StadiumBorder(),
        ),
        child: Center(
          child: _listPage[_selectedTabIndex],
        ),
      ),
      bottomNavigationBar: _bottomNavbar,
    );
  }
}
