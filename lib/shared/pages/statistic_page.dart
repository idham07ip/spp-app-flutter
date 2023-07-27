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
  int currentPage = 1;
  int itemsPerPage = 3; // You can adjust this value as needed

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

  // Function to handle arrow button press to move to the previous page
  void goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
    }
  }

  // Function to handle arrow button press to move to the next page
  void goToNextPage() {
    if (currentPage < totalPageCount) {
      setState(() {
        currentPage++;
      });
    }
  }

  // Calculate the total number of pages based on the number of data items and itemsPerPage
  int get totalPageCount {
    if (_nominalData?.data.isEmpty ?? true) {
      return 1;
    } else {
      return ((_nominalData!.data.length - 1) ~/ itemsPerPage) + 1;
    }
  }

  Stream<UserModel?> getUserStream(String nipd) async* {
    // Tidak ada loop tak terbatas di sini, Stream hanya mengambil data sekali
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
      Fluttertoast.showToast(msg: 'Failed to fetch nominal data');
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
        title: Text('Grafik Performa'),
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
                child: Text(
                  'Periode Tahun Ajaran : $th_akademik \n\nTotal Biaya Yang Harus Dilunasi \nSampai Tahun Ajaran Baru Sebesar : \n$formattedTotalBiaya',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //
              SizedBox(height: 65),

              Expanded(
                child: StreamBuilder<UserModel?>(
                  stream: getUserStream(nisController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Terjadi kesalahan: ${snapshot.error}'),
                      );
                    } else {
                      final UserModel? user = snapshot.data;
                      if (user == null) {
                        return Center(
                          child: Text('Data siswa tidak ditemukan.'),
                        );
                      }

                      akademik.text = user.thn_akademik ?? '';

                      return Center(
                          child: status != null
                              ? FutureBuilder(
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container();
                                    } else {
                                      return PieChart(
                                        PieChartData(
                                          pieTouchData: PieTouchData(
                                            touchCallback: (FlTouchEvent event,
                                                pieTouchResponse) {
                                              setState(() {
                                                if (!event
                                                        .isInterestedForInteractions ||
                                                    pieTouchResponse == null ||
                                                    pieTouchResponse
                                                            .touchedSection ==
                                                        null) {
                                                  touchedIndex = -1;
                                                  return;
                                                }
                                                touchedIndex = pieTouchResponse
                                                    .touchedSection!
                                                    .touchedSectionIndex;
                                              });
                                            },
                                          ),
                                          startDegreeOffset: 180,
                                          borderData: FlBorderData(show: false),
                                          sectionsSpace: 1,
                                          centerSpaceRadius: 0,
                                          sections: showingSections2(),
                                        ),
                                      );
                                    }
                                  },
                                )
                              : const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                  strokeWidth: 3,
                                ));
                    }
                  },
                ),
              ),
              const SizedBox(height: 65),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (status != null)
                    Indicator(
                      color: Colors.green,
                      text: 'Progress Lunas',
                      isSquare: false,
                      size: touchedIndex == 0 ? 18 : 16,
                      textColor:
                          touchedIndex == 0 ? Colors.black : Colors.black,
                      count: int.tryParse(status!.analytics.total_nominal) ?? 0,
                    ),
                ],
              ),
              const SizedBox(height: 25),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.greenAccent,
                ),
                child: Expanded(
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
                          label: Text('Tahun Akademik'),
                        ),
                      ],
                      rows: _nominalData?.data
                              .skip((currentPage - 1) * itemsPerPage)
                              .take(itemsPerPage)
                              .map<DataRow>((transaction) {
                            return DataRow(
                              cells: [
                                DataCell(Text(transaction.bulan)),
                                DataCell(
                                    Text(formatValue(transaction.nominal))),
                                DataCell(Text(transaction.thn_akademik)),
                              ],
                            );
                          }).toList() ??
                          [],
                    ),
                  ),
                ),
              ),

              // ... (other existing widgets)

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: goToPreviousPage, // Use the custom functions
                    icon: Icon(Icons.arrow_back),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: goToNextPage, // Use the custom functions
                    icon: Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Existing code...

  // ... (other existing methods)

  List<PieChartSectionData> showingSections2() {
    if (status == null) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 1,
          title: 'Data Tidak Ditemukan',
          radius: 100,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ];
    }

    final int totalNominal = int.tryParse(status!.analytics.total_nominal) ??
        0; // Parse total_nominal as int
    final int totalBiaya = status!.analytics.total_biaya; // Already an int

    final double diterimaValue =
        (totalNominal / totalBiaya) * 100.0; // Perform floating-point division

    final String percentageString = '${diterimaValue.toStringAsFixed(2)}%';

    return [
      if (diterimaValue > 0)
        PieChartSectionData(
          color: Colors.green,
          value: diterimaValue / 100,
          title: percentageString,
          radius: 100,
          titlePositionPercentageOffset: diterimaValue == 100 ? 0.5 : 0.55,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
    ];
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;
  final int count;

  const Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
    required this.size,
    required this.textColor,
    required this.count,
  });

  String formatValue(int value) {
    return NumberFormat('#,###', 'id_ID').format(value);
  }

  @override
  Widget build(BuildContext context) {
    String formattedCount = formatValue(count);

    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              'Total : Rp. $formattedCount', // Use the formatted count
              style: TextStyle(
                fontSize: 12,
                color: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
