import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/shared/pages/detail_payment_page.dart';
import 'package:spp_app/shared/pages/home_page.dart';
import 'package:spp_app/shared/pages/login_page.dart';
import 'package:spp_app/shared/pages/onboarding_page.dart';
import 'package:spp_app/shared/pages/payment_amount_page.dart';
import 'package:spp_app/shared/pages/payment_page.dart';
import 'package:spp_app/shared/pages/payment_success.dart';
import 'package:spp_app/shared/pages/pin_page.dart';
import 'package:spp_app/shared/pages/profile_edit_page.dart';
import 'package:spp_app/shared/pages/profile_edit_pin_page.dart';
import 'package:spp_app/shared/pages/profile_edit_success_page.dart';
import 'package:spp_app/shared/pages/profile_page.dart';
import 'package:spp_app/shared/pages/splash_page.dart';
import 'package:spp_app/shared/theme.dart';

import 'shared/pages/snap_web_view_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => AuthBloc()..add(AuthGetCurrentUser())),
      ],
      child: MaterialApp(
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
          '/profile-edit-success': (context) => const ProfileEditSuccessPage(),
          '/payment': (context) => const PaymentPage(),
          '/payment-success': (context) => const PaymentSuccessPage(),
          '/detail_payment': (context) => const PaymentDetails(),
          '/snap-webview': (context) => const SnapWebViewScreen(),
        },
      ),
    );
  }
}
