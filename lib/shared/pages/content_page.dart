import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/home_latest_transaction_item.dart';
import 'package:spp_app/shared/widgets/home_tips_item.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
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
                      'Selamat Datang,',
                      style: greenTextStyle.copyWith(
                        fontSize: 16,
                      ),
                    ),

                    //
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      state.user.nama_siswa.toString(),
                      style: blackTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: semiBold,
                      ),
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
            width: double.infinity,
            height: 235,
            margin: const EdgeInsets.only(
              top: 30,
            ),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              image: const DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/img_bg_card.png',
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 23,
                ),
                Text(
                  state.user.kategori_sekolah.toString(),
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
                  state.user.nis.toString(),
                  style: whiteTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: bold,
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

  //Build Latest Transaction
  Widget buildLatestTransactions() {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaksi Terakhir',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),

          //
          Container(
            padding: const EdgeInsets.all(22),
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
                  iconUrl: 'assets/ic_transaction_cat1.png',
                  title: 'Top Up',
                  time: 'Yesterday',
                  value: '+ 550.000',
                  onTap: () {},
                ),

                //cashback
                HomeLatestTransactionItem(
                  iconUrl: 'assets/ic_transaction_cat2.png',
                  title: 'Cashback',
                  time: 'Sept 11',
                  value: '+ 25.000',
                  onTap: () {},
                ),

                //withdraw
                HomeLatestTransactionItem(
                  iconUrl: 'assets/ic_transaction_cat3.png',
                  title: 'Withdraw',
                  time: 'Aug 06',
                  value: '- 50.000',
                  onTap: () {},
                ),

                //Transfer
                HomeLatestTransactionItem(
                  iconUrl: 'assets/ic_transaction_cat4.png',
                  title: 'Transfer',
                  time: 'Nov 25',
                  value: '- 90.000',
                  onTap: () {},
                ),

                //Electric
                HomeLatestTransactionItem(
                  iconUrl: 'assets/ic_transaction_cat5.png',
                  title: 'Electric',
                  time: 'Jan 18',
                  value: '- 246.500',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //Build Friendly Tips
  Widget buildFriendlyTips() {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Berita',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 14,
          ),

          //
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 19,
              children: const [
                //
                HomeTipsItem(
                  imageUrl: 'assets/img_tips1.png',
                  title: 'Best Tips for using a credit card',
                  url:
                      'https://www.capitalone.com/learn-grow/money-management/tips-using-credit-responsibly/',
                ),

                //
                HomeTipsItem(
                  imageUrl: 'assets/img_tips2.png',
                  title: 'Spot the good pie of finance model',
                  url:
                      'https://geekflare.com/free-excel-templates-for-personal-budget/',
                ),

                //
                HomeTipsItem(
                  imageUrl: 'assets/img_tips3.png',
                  title: 'Great hack to get better advices',
                  url:
                      'https://www.lifehack.org/articles/lifestyle/100-life-hacks-that-make-life-easier.html',
                ),

                //
                HomeTipsItem(
                  imageUrl: 'assets/img_tips4.png',
                  title: 'Save more penny buy this instead',
                  url: 'https://hasslefreesavings.com/penny-challenge/',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
