// ignore_for_file: unused_field, unused_local_variable, unused_import

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
import 'package:spp_app/service/kata_motivasi.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/home_tips_item.dart';
import 'package:translator/translator.dart';

List<String> splitText(String text) {
  List<String> lines = [];
  List<String> words = text.split(' ');

  String currentLine = '';
  for (int i = 0; i < words.length; i++) {
    if ((currentLine.length + words[i].length + 1) <= 20) {
      currentLine += words[i] + ' ';
    } else {
      lines.add(currentLine.trim());
      currentLine = words[i] + ' ';
    }
  }
  lines.add(currentLine.trim());

  return lines;
}

class FuturePriceWidget extends StatefulWidget {
  final String instansi;
  final String nipd;

  const FuturePriceWidget({required this.instansi, required this.nipd});

  @override
  State<FuturePriceWidget> createState() => _FuturePriceWidgetState();
}

class _FuturePriceWidgetState extends State<FuturePriceWidget> {
  late Future<DataPriceModel>? _dataPriceFuture;
  DataPriceModel? _cachedDataPrice;

  @override
  void initState() {
    super.initState();
    _dataPriceFuture = fetchData();
  }

  Future<DataPriceModel> getPrice(String instansi, String nipd) async {
    try {
      final response = await http.get(Uri.parse(
          'https://arrahman.site/spp-web/api/getprice?nipd=${Uri.encodeComponent(nipd)}&instansi=${Uri.encodeComponent(instansi)}'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData != null && jsonData['message'] == 'Success') {
          final data = jsonData['data'];
          if (data != null && data is List<dynamic> && data.isNotEmpty) {
            final dataPriceModel = DataPriceModel.fromJson(jsonData);
            return dataPriceModel;
          } else {
            throw Exception('Invalid response data');
          }
        } else {
          throw Exception(jsonData['message'] ?? 'Invalid response format');
        }
      } else if (response.statusCode == 404) {
        throw Exception("Data not found");
      } else {
        throw Exception("Failed to fetch data");
      }
    } catch (error) {
      throw Exception("Failed to fetch data: $error");
    }
  }

  Future<DataPriceModel> fetchData() async {
    try {
      print(
          'Fetching data for INSTASI: ${widget.instansi}, nipd: ${widget.nipd}');
      if (_cachedDataPrice != null) {
        print('Data found in cache: $_cachedDataPrice');
        return _cachedDataPrice!;
      } else {
        final dataPrice = await getPrice(widget.instansi, widget.nipd);
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
        try {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              final dataPrice = snapshot.data!;
              final formattedData = dataPrice.data.map((item) {
                final biaya = double.tryParse(item.biaya) ?? 0;
                final formattedBiaya = NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 2,
                  customPattern: '###,###.##',
                ).format(biaya);

                final splitLines = splitText(item.jenisPembayaran);
                final formattedLines = splitLines.join('\n');

                return '$formattedLines: $formattedBiaya';
              }).join('\n\n');

              final potongan = double.tryParse(dataPrice.potongan) ?? 0;
              final formattedPotongan = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 2,
                customPattern: '###,###.##',
              ).format(potongan);

              final total = double.tryParse(dataPrice.total.toString()) ?? 0;
              final formattedTotal = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 2,
                customPattern: '###,###.##',
              ).format(total);

              return RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: formattedData,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '\n\n'), // Tambahkan baris kosong di sini
                    TextSpan(
                      text: 'Potongan : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '$formattedPotongan'),
                    TextSpan(text: '\n\n'), // Tambahkan baris kosong di sini
                    TextSpan(
                      text:
                          'Total Biaya Bulanan Yang Harus \nDibayarkan Selama Tahun Ajaran Berjalan Sebesar : ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: '$formattedTotal Perbulan'),
                  ],
                ),
              );
            } else {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/rokets.gif',
                      width: 500,
                      height: 500,
                    ),
                    Text(
                      'Data Tidak Ditemukan',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
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
        } catch (e) {
          return Center(
            child: Text('Terjadi kesalahan'),
          );
        }
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
                        future: KataMotivasi.getMotivasi(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                            dynamic text = snapshot.data!.text;
                            // dynamic author = snapshot.data!.author;

                            Future<dynamic> translateText(dynamic text) async {
                              final translator = GoogleTranslator();
                              final translation = await translator
                                  .translate(text, from: 'en', to: 'id');
                              return translation.text;
                            }

                            return FutureBuilder<dynamic>(
                              future: translateText(text),
                              builder: (context, textSnapshot) {
                                if (textSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                } else if (textSnapshot.hasData) {
                                  dynamic translatedText = textSnapshot.data!;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translatedText,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25,
                                          fontFamily: 'Poppins',
                                          color: Color(0xff14193F),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FutureBuilder<dynamic>(
                                        builder: (context, authorSnapshot) {
                                          if (authorSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 150,
                                                height: 20,
                                                color: Colors.white,
                                              ),
                                            );
                                          } else if (authorSnapshot.hasData) {
                                            dynamic translatedAuthor =
                                                authorSnapshot.data!;
                                            return Text(
                                              "~ ${snapshot.data!.author}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 22,
                                                fontFamily: 'Poppins',
                                                color: Color(0xffABABCF),
                                              ),
                                            );
                                          } else if (authorSnapshot.hasError) {
                                            return Text(
                                                'Error: ${authorSnapshot.error}');
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                } else if (textSnapshot.hasError) {
                                  return Text('Error: ${textSnapshot.error}');
                                } else {
                                  return Container();
                                }
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
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
