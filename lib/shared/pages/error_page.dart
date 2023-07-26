// ignore_for_file: unused_field, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/login');
        return false;
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _animation,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: _animation,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/so_far.gif',
                      width: 300,
                      height: 300,
                    ),
                    Text(
                      'Akses Ditolak, Silahkan Coba Lagi Nanti',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 26,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: 183,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.chat_bubble,
          backgroundColor: Colors.green,
          children: [
            SpeedDialChild(
              child: Icon(Icons.call),
              label: 'Telepon',
              backgroundColor: Colors.green,
              onTap: () {
                String phoneNumber = '+62 813 10653558';

                openPhoneCall(phoneNumber);
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.sms),
              label: 'SMS',
              backgroundColor: Colors.green,
              onTap: () {
                String phoneNumber = '+62 813 10653558';
                String message = 'Halo, ini pesan dari Flutter!';

                openSMS(phoneNumber, message);
              },
            ),
          ],
        ),
      ),
    );
  }
}

void openPhoneCall(String phoneNumber) async {
  String url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Tidak dapat melakukan panggilan telepon';
  }
}

void openSMS(String phoneNumber, String message) async {
  String url = 'sms:$phoneNumber?body=${Uri.encodeComponent(message)}';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Tidak dapat membuka aplikasi SMS';
  }
}
