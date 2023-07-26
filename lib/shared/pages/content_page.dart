// ignore_for_file: unused_field, unused_import, unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/model/news_form_model.dart';
import 'package:spp_app/model/quotes_form_model.dart';
import 'package:spp_app/service/article_service.dart';
import 'package:spp_app/service/kata_motivasi.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/builder.dart';
import 'package:spp_app/shared/widgets/home_tips_item.dart';

class ContentPage extends StatefulWidget {
  final Future<KataMotivasiFormModel>? isFuture;
  ContentPage({required this.isFuture});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

String getGreeting() {
  DateTime now = DateTime.now();
  int currentHour = now.hour;

  if (currentHour >= 0 && currentHour < 10) {
    return 'Selamat Pagi,';
  } else if (currentHour >= 10 && currentHour < 15) {
    return 'Selamat Siang,';
  } else if (currentHour >= 15 && currentHour < 18) {
    return 'Selamat Sore,';
  } else {
    return 'Selamat Malam,';
  }
}

class _ContentPageState extends State<ContentPage> {
  bool hasDataLoaded = false;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          buildProfile(context),
          buildWalletCard(),
          buildLatestTransactions(),
          buildFriendlyTips(),
        ],
      ),
    );
  }

  // Build Profile Icon
  Widget buildProfile(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          String namaSiswa = state.user.nama_siswa.toString();
          List<String> words = namaSiswa.split(' ');

          String line1 = '';
          String line2 = '';

          for (int i = 0; i < words.length; i++) {
            if (line1.length + words[i].length <= 17) {
              line1 += words[i] + ' ';
            } else {
              line2 += words[i] + ' ';
            }
          }
          return Container(
            margin: const EdgeInsetsDirectional.only(
              top: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${getGreeting()}',
                      style: greenTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        final maxWidth = constraints.maxWidth;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line1.trim(),
                              style: blackTextStyle.copyWith(
                                fontSize: 20,
                                fontWeight: semiBold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (line2.trim().isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                line2.trim(),
                                style: blackTextStyle.copyWith(
                                  fontSize: 20,
                                  fontWeight: semiBold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/ic_user_profile.png',
                        ),
                      ),
                    ),

                    //check_icon
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: whiteColor,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: greenColor,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  //Build Wallet Cart
  Widget buildWalletCard() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Container(
            width: MediaQuery.of(context).size.width / 10,
            height: MediaQuery.of(context).size.height / 3.5,
            margin: const EdgeInsets.only(
              top: 30,
            ),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: greyColor,
                  blurRadius: 5.0,
                  offset: Offset(0, 4),
                ),
              ],
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/img_bg_card.png',
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 23,
                  ),
                  Text(
                    state.user.instansi.toString(),
                    style: whiteTextStyle.copyWith(
                      fontSize: 18,
                      fontWeight: extraBold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'NISN',
                    style: whiteTextStyle,
                  ),
                  Text(
                    state.user.nipd.toString(),
                    style: whiteTextStyle.copyWith(
                      fontSize: 22,
                      fontWeight: bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  //Build Latest Transaction
  Widget buildLatestTransactions() {
    return QuoteWidget(
      isFuture: widget.isFuture, // Pass the future to QuoteWidget
    );
  }

  //Build Friendly Tips
  Widget buildFriendlyTips() {
    return FriendlyTipsWidget(
      shouldRefresh: true, // Berikan nilai yang sesuai
      onRefreshComplete: () {
        true;
      },
    );
  }
}
