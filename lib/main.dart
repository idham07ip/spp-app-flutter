// ignore_for_file: unused_import
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/service/local_notification.dart';
import 'package:spp_app/shared/pages/home_page.dart';
import 'package:spp_app/shared/pages/login_page.dart';
import 'package:spp_app/shared/pages/notification_page.dart';
import 'package:spp_app/shared/pages/onboarding_page.dart';
import 'package:spp_app/shared/pages/pin_page.dart';
import 'package:spp_app/shared/pages/profile_edit_page.dart';
import 'package:spp_app/shared/pages/profile_edit_pin_page.dart';
import 'package:spp_app/shared/pages/profile_edit_success_page.dart';
import 'package:spp_app/shared/pages/profile_page.dart';
import 'package:spp_app/shared/pages/splash_page.dart';
import 'package:spp_app/shared/theme.dart';
import 'shared/pages/snap_web_view_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationLocal.initialize();
  await NotificationLocal.scheduleNotification();
  await NotificationLocal.scheduleNotificationNews();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
  Timer.periodic(const Duration(minutes: 1), (Timer t) {
    final now = DateTime.now();
    final fifteenMinutesAgo = now.subtract(const Duration(minutes: 60));
    if (lastUserInteraction.isBefore(fifteenMinutesAgo)) {
      // Clear storage and logout user
      clearStorageAndLogout(navigatorKey
          .currentContext); // ubah argumen context menjadi navigatorKey.currentContext
      // Restart app
      runApp(const MyApp());
    }
  });
}

final navigatorKey = GlobalKey<NavigatorState>();
late BuildContext appContext;
DateTime lastUserInteraction = DateTime.now();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    appContext = context; // Store the context in the global variable
    return GestureDetector(
      onTap: () {
        lastUserInteraction = DateTime.now();
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc()..add(AuthGetCurrentUser()),
          ),
        ],
        child: MaterialApp(
          navigatorKey:
              navigatorKey, // tambahkan navigatorKey ke dalam MaterialApp
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: lightBackgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: lightBackgroundColor,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(
                color: blackColor,
              ),
              titleTextStyle: blackTextStyle.copyWith(
                fontSize: 20,
                fontWeight: semiBold,
              ),
            ),
          ),
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding': (context) => const OnboardingPage(),
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
            '/profile': (context) => const ProfilePage(),
            '/pin': (context) => const PinPage(),
            '/profile-edit': (context) => const ProfileEditPage(),
            '/profile-edit-pin': (context) => const ProfileEditPinPage(),
            '/profile-edit-success': (context) =>
                const ProfileEditSuccessPage(),
            '/snap-webview': (context) => const SnapWebViewScreen(),
            '/notification': (context) => const NotificationPage(),
          },
        ),
      ),
    );
  }
}

void clearStorageAndLogout(BuildContext? context) async {
  const storage = FlutterSecureStorage();
  await storage.deleteAll();
  print('Storage cleared!');

  // Navigate to login page
  Navigator.pushNamedAndRemoveUntil(context!, '/login', (route) => false);
}
