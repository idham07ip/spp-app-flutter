import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spp_app/shared/theme.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();

  List<String> titles = [
    'Pembayaran Mudah',
    'Pemberitahuan Pembayaran',
    'Menghemat Waktu',
  ];

  List<String> subtitles = [
    'Kami terbuka untuk metode pembayaran apapun , untuk membuat anda merasa mudah',
    'Memberitahu kepada pengguna , \n untuk membayar sesuai tanggal yang telah ditetapkan',
    'Bayar tanpa mengantri , dapat diakses dimana saja',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider(
              items: [
                Image.asset(
                  'assets/payment.png',
                  height: MediaQuery.of(context).size.height / 3.5,
                ),

                //2
                Image.asset(
                  'assets/notif.png',
                  height: MediaQuery.of(context).size.height / 3.5,
                ),

                //3
                Image.asset(
                  'assets/hemat.png',
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
              ],
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 3.5,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(
                    () {
                      currentIndex = index;
                    },
                  );
                },
              ),
              carouselController: carouselController,
            ),

            //Keterangan or Quotes
            const SizedBox(
              height: 80,
            ),

            //
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 26,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 22,
              ),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),

              //
              child: Column(
                children: [
                  Text(
                    titles[currentIndex],
                    style: blackTextStyle.copyWith(
                      fontSize: 20,
                      fontWeight: semiBold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Text(
                    subtitles[currentIndex],
                    style: greyTextStyle.copyWith(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: currentIndex == 2 ? 38 : 50,
                  ),
                  currentIndex == 2
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),

                            //
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: MediaQuery.of(context).size.height / 11.5,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/login', (route) => false);
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                                child: Text(
                                  'Login',
                                  style: greenTextStyle.copyWith(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 30,
                              height: MediaQuery.of(context).size.height / 25,
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == 0
                                    ? greenColor
                                    : lightBackgroundColor,
                              ),
                            ),

                            //
                            Container(
                              width: MediaQuery.of(context).size.width / 30,
                              height: MediaQuery.of(context).size.height / 25,
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == 1
                                    ? greenColor
                                    : lightBackgroundColor,
                              ),
                            ),

                            //
                            Container(
                              width: MediaQuery.of(context).size.width / 30,
                              height: MediaQuery.of(context).size.height / 25,
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentIndex == 2
                                    ? greenColor
                                    : lightBackgroundColor,
                              ),
                            ),

                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.height / 19,
                              child: TextButton(
                                onPressed: () {
                                  carouselController.nextPage();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: greenColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(56),
                                  ),
                                ),
                                child: Text(
                                  'Continue',
                                  style: whiteTextStyle.copyWith(
                                    fontSize: 16,
                                    fontWeight: semiBold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
