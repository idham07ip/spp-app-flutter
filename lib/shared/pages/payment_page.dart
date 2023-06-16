// ignore_for_file: unused_local_variable, unused_import, unused_field

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/blocs/pembayaran/pembayaran_bloc.dart';
import 'package:spp_app/model/pembayaran_form_model.dart';
import 'package:spp_app/model/price.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/shared/helpers.dart';
import 'package:spp_app/shared/pages/payment_success.dart';
import 'package:spp_app/shared/pages/snap_web_view_screen.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/builder.dart';
import 'package:spp_app/shared/widgets/buttons.dart';
import 'package:spp_app/shared/widgets/custom_form_payments.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({
    Key? key,
    required this.data,
    required this.transactions,
  }) : super(key: key);
  final PembayaranFormModel data;
  final TransactionFormModel transactions;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage>
    with SingleTickerProviderStateMixin {
  final payment = PembayaranFormModel();
  bool _isLoading = true;
  bool _hasInternetConnection = true;
  final nisController = TextEditingController(text: '');
  final namaController = TextEditingController(text: '');
  final tingkatSekolahController = TextEditingController(text: '');
  final jumlahPembayaranController = TextEditingController(text: '');
  final keteranganPembayaranController = TextEditingController(text: '');
  final kelasController = TextEditingController(text: '');
  final tahunAkademik = TextEditingController(text: '');
  final nominalController = TextEditingController(text: '');
  late AnimationController loadingController;
  bool isButtonDisabled = false;

  File? _file;
  PlatformFile? _platformFile;

  void selectFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No File Selected'),
          content: Text('Please select an image file.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final File file = File(pickedFile.path);
    final length = await file.length();
    final name = file.path.split('/').last;

    setState(() {
      _platformFile = PlatformFile(
        path: pickedFile.path,
        name: name,
        size: length,
      );
      isButtonDisabled = true;
      showCustomSnackbar(context, 'Harap Tunggu Hingga Proses Selesai');
    });

    loadingController.forward().then((_) {
      setState(() {
        isButtonDisabled = false;
      });
    });
  }

  @override
  void dispose() {
    loadingController.dispose();
    super.dispose();
  }

  bool containsXSS(String input) {
    // Daftar pola yang digunakan untuk mencocokkan serangan XSS
    final xssPatterns = [
      RegExp(r'<script[^>]*?>.*?<\/script>', caseSensitive: false),
      RegExp(r'on\w+="[^"]*"', caseSensitive: false),
      RegExp(r'on\w+=\[]' '^]*\'', caseSensitive: false),
      RegExp(r'style=[^>]*expression[^>]*', caseSensitive: false),
    ];

    // Memeriksa apakah string mengandung pola serangan XSS
    for (var pattern in xssPatterns) {
      if (pattern.hasMatch(input)) {
        return true;
      }
    }

    return false;
  }

  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nis!;
      namaController.text = authState.user.nama_siswa!;
      tingkatSekolahController.text = authState.user.instansi!;
      kelasController.text = authState.user.kelas!;
      tahunAkademik.text = authState.user.tahun_akademik!;
    }

    addAmount(String number) {
      if (jumlahPembayaranController.text == '0') {
        jumlahPembayaranController.text = '';
      }
      setState(() {
        jumlahPembayaranController.text =
            jumlahPembayaranController.text + number;
      });
    }
  }

  bool validate() {
    if (nisController.text.isEmpty ||
        namaController.text.isEmpty ||
        tingkatSekolahController.text.isEmpty ||
        nominalController.text.isEmpty ||
        keteranganPembayaranController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text('Form Payment'),
      ),
      body: BlocProvider(
        create: (context) => PembayaranBloc(),
        child: BlocConsumer<PembayaranBloc, PembayaranState>(
          listener: (context, state) async {
            print(state);
            if (state is PembayaranFailed) {
              showCustomSnackbar(context, state.e.toString());
            }
            if (state is PembayaranSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentSuccessPage(),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PembayaranLoading) {
              return Container(
                child: Center(
                  child: Image.asset(
                    'assets/loading.gif',
                    gaplessPlayback: true,
                  ),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(19.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteColor,
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 30),
                    Visibility(
                      visible: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tahun Akademik',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomFormName(
                                readOnly: true,
                                controller: tahunAkademik,
                                hintText: '',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // const SizedBox(height: 30),

                    Visibility(
                      visible: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nomor Induk Siswa',
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: semiBold,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomFormName(
                                readOnly: true,
                                controller: nisController,
                                hintText: 'Masukkan Jumlah Pembayaran',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Siswa',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        CustomFormName(
                            readOnly: true, controller: namaController),
                      ],
                    ),

                    const SizedBox(height: 30),
                    Text(
                      'Tingkat Sekolah',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    CustomFormName(
                        readOnly: true, controller: tingkatSekolahController),
                    const SizedBox(height: 16),

                    Text(
                      'Nominal',
                      style: blackTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: semiBold,
                      ),
                    ),
                    CustomFormPaymentNumbers(
                      readOnly: false,
                      controller: nominalController,
                      hintText: 'Masukkan Keterangan Pembayaran',
                    ),
                    const SizedBox(height: 16),

                    //KETERANGAN PEMBAYARAN
                    Row(
                      children: [
                        Text(
                          'Keterangan Pembayaran',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),

                        //
                        TextButton(
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                              ),
                              title: const Text(
                                'Informasi Keterangan Pembayaran',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    const Text(
                                      'Masukan Keterangan Pembayaran Secara Spesifik Contoh Sebagai Berikut : \n',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),

                                    //
                                    const Text(
                                      'Pembayaran Uang Bulanan Sekolah Arrahmah',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),

                                    //
                                  ],
                                ),
                              ),

                              //
                              actions: <Widget>[
                                //
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomFilledButton(
                                  title: 'Tutup',
                                  onPressed: () {
                                    Navigator.pop(context, 'Tutup');
                                  },
                                ),
                                const SizedBox(
                                  height: 10.5,
                                ),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.info_outline_rounded,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),

                    CustomFormPayment(
                      readOnly: false,
                      controller: keteranganPembayaranController,
                      hintText: 'Masukkan Keterangan Pembayaran',
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Upload Bukti Pembayaran',
                          style: blackTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: semiBold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Format File jpg dan png',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: selectFile,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: Radius.circular(10),
                              dashPattern: [10, 4],
                              strokeCap: StrokeCap.round,
                              color: Colors.blue.shade400,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50.withOpacity(.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Iconsax.folder_open,
                                      color: Colors.blue,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Pilih Foto',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        _platformFile != null
                            ? Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            offset: Offset(0, 1),
                                            blurRadius: 3,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              File(_platformFile!.path!),
                                              width: 70,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _platformFile!.name,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(_platformFile!.size / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                isButtonDisabled
                                                    ? LinearProgressIndicator(
                                                        value: loadingController
                                                            .value)
                                                    : Row(
                                                        children: [
                                                          Text(
                                                            'Selesai',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                            size: 13,
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    CustomFilledButton(
                      title: 'Lanjut',
                      onPressed: () async {
                        var connectivityResult =
                            await Connectivity().checkConnectivity();
                        if (connectivityResult == ConnectivityResult.none) {
                          showCustomSnackbar(
                              context, 'Tidak Ada Koneksi Internet');
                        } else {
                          String keterangan =
                              keteranganPembayaranController.text.trim();
                          if (keterangan.isEmpty) {
                            showCustomSnackbar(
                                context, 'Keterangan tidak boleh kosong');
                          } else if (keterangan.length > 140) {
                            showCustomSnackbar(
                                context, 'Keterangan terlalu panjang');
                          } else if (containsXSS(keterangan)) {
                            showCustomSnackbar(
                                context, 'Keterangan tidak valid');
                          } else {
                            context.read<PembayaranBloc>().add(
                                  PembayaranPost(
                                    widget.data.copyWith(
                                      tahun_akademik: tahunAkademik.text,
                                      nis: nisController.text,
                                      nama_siswa: namaController.text,
                                      instansi: tingkatSekolahController.text,
                                      nominal: nominalController.text,
                                      keterangan:
                                          keteranganPembayaranController.text,
                                      image: _platformFile,
                                    ),
                                  ),
                                );
                            keteranganPembayaranController.clear();
                            nominalController.clear();
                            setState(() {
                              _platformFile = null;
                            });
                          }
                        }
                      },
                    ),

                    const SizedBox(height: 57),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
