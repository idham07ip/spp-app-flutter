// ignore_for_file: unused_import, unused_local_variable, unused_field, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:spp_app/model/user_model.dart';
import 'package:spp_app/service/payment_method_service.dart';
import 'package:spp_app/shared/helpers.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/resource/app_resource.dart';
import 'package:spp_app/shared/widgets/resource/indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:spp_app/model/filter_amount.dart';

import 'package:spp_app/blocs/auth/auth_bloc.dart';

import '../../model/Analytics.dart';

class PieChartSample1 extends StatefulWidget {
  @override
  _PieChartSample1State createState() => _PieChartSample1State();
}

class _PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;
  final PageController _pageController = PageController(initialPage: 0);
  List<DataRow> _dataRows = [];

  Status? status;
  NominalData? _nominalData;
  String? currentAcademicYear;

  bool isUserDataChanged = false; // Add this boolean flag
  final apiBaseUrl = 'https://arrahman.site/spp-web/api';
  final authToken = 'Bearer KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9';
  Timer? _timer;
  late final nisController = TextEditingController();
  late final instansi = TextEditingController();
  late final akademik = TextEditingController();
  late StreamSubscription<UserModel?> _userStreamSubscription;
  int itemsPerPage = 4; // You can adjust this value as needed
  int currentPage = 1; // You can adjust this value as needed

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      setState(() {
        nisController.text = authState.user.nipd!;
        instansi.text = authState.user.instansi!;
      });
    }

    _userStreamSubscription = getUserStream(nisController.text).listen((user) {
      if (user != null) {
        setState(() {
          currentAcademicYear = user.thn_akademik ?? '';
          akademik.text = currentAcademicYear!;
        });

        fetchData();
        fetchData2();

        // Set the boolean flag to false after fetching data
        isUserDataChanged = false;
      }
    });
  }

  Stream<UserModel?> getUserStream(String nipd) async* {
    try {
      final res = await http.post(
        Uri.parse('https://arrahman.site/spp-web/api/getdatasiswa'),
        body: {'nipd': nipd},
        headers: {'Authorization': 'Bearer KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9'},
      );
      if (res.statusCode == 200) {
        final List<dynamic> listSiswa = jsonDecode(res.body);
        final siswa = listSiswa
            .map((dynamic item) =>
                UserModel.fromJson(item as Map<String, dynamic>))
            .toList();

        if (siswa.isNotEmpty && siswa.first != null) {
          yield siswa.first;
        } else {
          yield UserModel(); // Replace with your UserModel constructor
        }
      } else {
        print('Response status code: ${res.statusCode}');
        yield UserModel(); // Replace with your UserModel constructor
      }
    } catch (e) {
      print('Error in getUserStream: $e');
      yield UserModel(); // Replace with your UserModel constructor
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await http.post(
        Uri.parse(
          '$apiBaseUrl/countstatus?nipd=${nisController.text}&instansi=${instansi.text}&thn_akademik=${akademik.text}',
        ),
        headers: {'Authorization': authToken},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          status = Status.fromJson(json);
        });
      } else {
        throw Exception('Failed to make API call: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching status data: $e');
      Fluttertoast.showToast(msg: 'Failed to fetch status data');
    }
  }

  Future<void> fetchData2() async {
    try {
      final nominal = PaymentMethodService();
      final NominalData data = await nominal.fetchNominalData(
        nisController.text,
        currentAcademicYear!,
      );
      print('Fetched Data:');
      if (_nominalData != data) {
        // Only append data if the fetched data is different from the existing one
        setState(() {
          if (_nominalData == null) {
            _nominalData = data;
          } else {
            _nominalData!.data.addAll(data.data);
          }
          // Update the current page after fetching data
          currentPage++;
        });
      }
    } catch (e) {
      print('Error fetching nominal data: $e');
      // Fluttertoast.showToast(msg: 'Table Not Show Because Data Not Found');
    }
  }

  @override
  void dispose() {
    // Cancel the user stream subscription when the widget is disposed
    _userStreamSubscription.cancel();
    super.dispose();
  }

  String formatValue(int value) {
    String formattedValue = NumberFormat('#,###', 'id_ID').format(value);
    return 'Rp $formattedValue';
  }

  @override
  Widget build(BuildContext context) {
    final th_akademik = akademik.text;
    final int? total_biaya = status?.analytics.total_biaya;
    final String formattedTotalBiaya = formatValue(total_biaya ?? 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Statistic'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: whiteColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 5, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFB2EBF2), // Pale Blue
                        Color(0xFFC8E6C9), // Mint Green
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Periode Tahun Ajaran : $th_akademik \n\nTotal Biaya Yang Harus Dilunasi \nSampai Tahun Ajaran Baru Sebesar : \n$formattedTotalBiaya',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800], // Dark Gray
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18),
              // Display Total Biaya and Sudah Lunas in a Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  if (status != null)
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: AppColors.contentColorYellow,
                        ),
                        SizedBox(width: 8),
                        Text('Total Biaya'),
                      ],
                    ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: AppColors.contentColorGreen,
                      ),
                      SizedBox(width: 8),
                      Text('Dana Terima'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: buildPieChartWidget(),
              ),
              // DataTable Widget
              Expanded(
                child: buildDataTableWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPieChartWidget() {
    return StreamBuilder<UserModel?>(
      stream: getUserStream(nisController.text),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Terjadi kesalahan: ${snapshot.error}'),
          );
        } else {
          final UserModel? user = snapshot.data;
          if (user == null) {
            return Container();
          }

          akademik.text = user.thn_akademik ?? '';

          return Center(
            child: status != null
                ? FutureBuilder(
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else {
                        return PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback:
                                  (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0,
                            centerSpaceRadius: 40,
                            sections: showingSections(),
                          ),
                        );
                      }
                    },
                  )
                : const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    strokeWidth: 3,
                  ),
          );
        }
      },
    );
  }

  Widget buildDataTableWidget() {
    final dataLength = _nominalData?.data.length ?? 0;
    print('Data Length: $dataLength');

    if (_nominalData?.data == null) {
      // Data is still loading or null
      return Center(
        child: Text(
          'Please Wait...', // Your custom message here
          style: TextStyle(color: Colors.red),
        ),
      );
    } else if (_nominalData!.data.isEmpty) {
      // Data is loaded but empty
      return Center(
        child: Text(
          'Data is empty.', // Your custom message here
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      // Data is loaded and not empty, display the DataTable
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: 420, // Adjust the width as needed
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text('Bulan'),
                  ),
                  DataColumn(
                    label: Text('Nominal'),
                  ),
                  DataColumn(
                    label: Text('Tahun\nAkademik'),
                  ),
                ],
                rows: _nominalData!.data.map<DataRow>((transaction) {
                  return DataRow(
                    cells: [
                      DataCell(Text(transaction.bulan)),
                      DataCell(Text(formatValue(transaction.nominal))),
                      DataCell(Text(transaction.thn_akademik)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget buildLegendRow(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 8),
        Text(label),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    final int totalNominal = int.tryParse(status!.analytics.total_nominal) ?? 0;
    final int totalBiaya = status!.analytics.total_biaya;

    // Ensure totalBiaya is greater than 0
    if (totalBiaya <= 0) {
      // When totalBiaya is zero or negative, display "Data Tidak Tersedia" slice
      return [
        PieChartSectionData(
          color: Colors.grey, // Replace with your desired color
          value: 1, // Set value to 1 to create a slice
          title: 'Data Tidak Tersedia',
          radius: 50, // Adjust the radius as needed
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ];
    }

    // Calculate the remaining percentage (100% - (totalNominal / totalBiaya * 100))
    final double remainingPercentageBiaya =
        100 - (totalNominal / totalBiaya * 100);
    final String percentageStringNominal =
        '${(totalNominal / totalBiaya * 100).toInt()}%';
    final String remainingPercentageStringBiaya =
        '${remainingPercentageBiaya.toInt()}%';

    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: totalBiaya.toDouble(),
            title: remainingPercentageStringBiaya,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );

        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: totalNominal.toDouble(),
            title: percentageStringNominal,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.mainTextColor1,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
