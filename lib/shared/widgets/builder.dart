// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/model/news_form_model.dart';
import 'package:spp_app/model/price.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:spp_app/model/quotes_form_model.dart';
import 'package:spp_app/service/article_service.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/home_tips_item.dart';

class FuturePriceWidget extends StatefulWidget {
  final TextEditingController instansi;

  const FuturePriceWidget({required this.instansi});

  @override
  State<FuturePriceWidget> createState() => _FuturePriceWidgetState();
}

class _FuturePriceWidgetState extends State<FuturePriceWidget> {
  final instansi = TextEditingController(text: '');
  late String instansiTEST;
  late Future<DataPriceModel>? _dataPriceFuture;
  DataPriceModel? _cachedDataPrice;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final authUserNIS = authState.user.instansi!;
      instansi.text = authUserNIS;
      instansiTEST = authUserNIS;
    }
    _dataPriceFuture = fetchData();
  }

  @override
  void didUpdateWidget(FuturePriceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.instansi.text != instansiTEST) {
      instansiTEST = widget.instansi.text;
      _dataPriceFuture = fetchData();
    }
  }

  Future<DataPriceModel> getPrice(String instansi) async {
    final encodedInstansi = Uri.encodeComponent(instansi);
    final url = Uri.parse(
        'https://arrahman.site/api_spp/api/getprice?instansi=$encodedInstansi');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      try {
        if (jsonData['message'] == 'Success' && jsonData['data'] != null) {
          final dataPriceModel = DataPriceModel.fromJson(jsonData['data']);
          return dataPriceModel;
        } else {
          throw Exception(jsonData['message'] ?? 'Invalid response format');
        }
      } catch (error) {
        throw Exception("Failed to parse response: $error");
      }
    } else if (response.statusCode == 404) {
      throw Exception("Data not found");
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  Future<DataPriceModel> fetchData() async {
    try {
      print('Fetching data for INSTASI: $instansiTEST');
      if (_cachedDataPrice != null) {
        print('Data found in cache: $_cachedDataPrice');
        return _cachedDataPrice!;
      } else {
        final dataPrice = await getPrice(instansiTEST);
        print('Data fetched successfully: $dataPrice');
        _cachedDataPrice = dataPrice;
        return dataPrice;
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DataPriceModel>(
      future: _dataPriceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          } else if (snapshot.hasData) {
            final dataPrice = snapshot.data!;
            final biaya = double.tryParse(dataPrice.totalBiaya) ?? 0;

            final formattedBiaya = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp ',
              decimalDigits: 2,
              customPattern: '###,###.##',
            ).format(biaya);

            return Text(
              'Masukan Nilai Berupa Angka 1 s/d 12 Untuk Mengkalkulasikan Total Biaya \nJumlah Perbulan Yang Harus Dibayar : \nRp $formattedBiaya',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            );
          }
        }

        // Shimmer effect
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 300,
                height: 16,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Container(
                width: 250,
                height: 16,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Container(
                width: 200,
                height: 16,
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}

class FriendlyTipsWidget extends StatefulWidget {
  final bool shouldRefresh;
  final VoidCallback onRefreshComplete;

  FriendlyTipsWidget(
      {required this.shouldRefresh, required this.onRefreshComplete});

  @override
  State<FriendlyTipsWidget> createState() => _FriendlyTipsWidgetState();
}

class _FriendlyTipsWidgetState extends State<FriendlyTipsWidget> {
  Future<List<Article>>? _articlesFuture;

  @override
  void initState() {
    super.initState();
    if (widget.shouldRefresh) {
      _articlesFuture = ArticleService().getArticles();
    }
  }

  @override
  void didUpdateWidget(covariant FriendlyTipsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldRefresh && !oldWidget.shouldRefresh) {
      _articlesFuture = ArticleService().getArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Article>>(
      future: _articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show shimmer effect while waiting for data
          return _buildShimmerLoading();
        } else if (snapshot.hasData) {
          final articles = snapshot.data!;
          final random = Random();
          articles.shuffle(random);
          final articleSubset = articles.take(4).toList();

          return _buildArticleList(articleSubset);
        } else if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Berita Hari Ini',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: List.generate(4, (index) {
                return _buildShimmerItem();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width / 3.5,
                height: MediaQuery.of(context).size.height / 11,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Container(
                  width: double.infinity,
                  height: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(List<Article> articles) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
        bottom: 50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Berita Hari Ini',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: articles.map((article) {
                return HomeTipsItem(
                  imageUrl: 'assets/tv.png',
                  title: article.title.length > 50
                      ? '${article.title.substring(0, 50)}...'
                      : article.title,
                  url: article.url,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class QuoteWidget extends StatefulWidget {
  final Future<KataMotivasiFormModel>? isFuture;
  QuoteWidget({required this.isFuture});

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  @override
  void initState() {
    super.initState();
    isFuture = widget.isFuture;
    print('isFuture: ${widget.isFuture}');
  }

  Future<KataMotivasiFormModel>? isFuture;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kutipan Hari Ini',
            style: blackTextStyle.copyWith(
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.only(
              top: 14,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
              boxShadow: [
                BoxShadow(
                  color: greyColor,
                  blurRadius: 5.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image QuotationMark
                Image.asset(
                  'assets/quote.png',
                  width: 41,
                  height: 41,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<KataMotivasiFormModel>(
                        future: isFuture, // Use the passed future
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // Show shimmer effect while waiting for data
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    height: 25,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: 150,
                                    height: 20,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            );
                          } else if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data!.text,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    fontFamily: 'Poppins',
                                    color: Color(0xff14193F),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "~ ${snapshot.data!.author}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    fontFamily: 'Poppins',
                                    color: Color(0xffABABCF),
                                  ),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Container(); // Empty container if no data or error
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // ...
                Padding(
                  padding: const EdgeInsets.only(left: 210),
                  child: Image.asset(
                    'assets/quote.png',
                    width: 41,
                    height: 41,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 200.0),
      child: Center(
        child: Image.asset(
          'assets/loading.gif',
          height: 200.0,
          width: 200.0,
          gaplessPlayback: true,
        ),
      ),
    );
  }
}
