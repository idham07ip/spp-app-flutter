import 'package:flutter/material.dart';
import 'package:spp_app/shared/pages/notification_page.dart';
import 'package:spp_app/shared/pages/payment_page.dart';
import 'package:spp_app/shared/pages/profile_page.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/buttons.dart';
import 'package:spp_app/shared/widgets/home_latest_transaction_item.dart';
import 'package:spp_app/shared/widgets/home_service_item.dart';
import 'package:spp_app/shared/widgets/home_tips_item.dart';
import 'package:spp_app/shared/widgets/home_user_item.dart';
import 'package:spp_app/shared/pages/content_page.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  int _selectedTabIndex = 0;

  void _onNavbarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _listPage = <Widget>[
      //Beranda Tab 1
      ContentPage(),

      //Pembayaran Tab 2
      PaymentPage(),

      //Notifikasi Tab 3
      NotificationPage(),

      //Setting Profile Tab 4
      ProfilePage(),
    ];

    //
    final _bottomNavbarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Beranda',
      ),

      //payment
      BottomNavigationBarItem(
        icon: Icon(Icons.payment),
        label: 'Pembayaran',
      ),

      //notification

      BottomNavigationBarItem(
        icon: Icon(Icons.notifications_active),
        label: 'Notifikasi',
      ),

      //information
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_suggest),
        label: 'Setting',
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
          child: _listPage.elementAt(_selectedTabIndex),
        ),
      ),
      bottomNavigationBar: _bottomNavbar,
    );
  }
}
