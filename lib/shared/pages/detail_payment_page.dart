// ignore_for_file: unused_field, unused_import

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/buttons.dart';
import 'package:photo_view/photo_view.dart';
import '../../blocs/auth/auth_bloc.dart';
import 'package:screenshot/screenshot.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails(
      {super.key, required this.nis, required TransactionFormModel transaction})
      : transactions = transaction;
  final String nis;
  final TransactionFormModel transactions;

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  ScreenshotController screenshotController = ScreenshotController();
  double nominal = 0.0;
  File _imageFile = File('');
  bool _isButtonVisible = true;
  final nisController = TextEditingController(text: '');
  final namasiswaController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final kelasController = TextEditingController(text: '');
  final tingkatSekolah = TextEditingController(text: '');

  Future<void> _takeScreenshot() async {
    try {
      // Tangkap layar menggunakan screenshotController
      screenshotController.capture().then((Uint8List? imageBytes) async {
        if (imageBytes != null) {
          // Simpan gambar ke file
          setState(() {
            _imageFile = File.fromRawPath(imageBytes);
          });

          Directory tempDir = await getTemporaryDirectory();
          File imgFile = File('${tempDir.path}/screenshot.png');
          imgFile.writeAsBytesSync(imageBytes);
          print("File Saved");

          await Share.shareFiles([imgFile.path],
              text:
                  'Sumbangan Pengembangan Pendidikan NIS: ${nisController.text}, Nama Siswa: ${namasiswaController.text}');
        }
      });
    } catch (e) {
      print('Error taking screenshot: $e');
    }
  }

  Future<Uint8List> imageToByte(String path) async {
    File file = File(path);
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  @override
  void initState() {
    super.initState();
    nominal = double.parse(widget.transactions.nominal!);
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nis!;
      namasiswaController.text = authState.user.nama_siswa!;
      kelasController.text = authState.user.kelas!;
      tingkatSekolah.text = authState.user.instansi!;
    }
  }

  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    String _getKeterangan() {
      if (widget.transactions.keterangan == null ||
          widget.transactions.keterangan!.isEmpty) {
        return "No keterangan";
      } else if (widget.transactions.keterangan!.length < 20) {
        return widget.transactions.keterangan!;
      } else {
        return '${widget.transactions.keterangan!.substring(0, 20)}...';
      }
    }

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          'Detail History',
        ),
      ),

      //

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 25),
            Screenshot(
              controller: screenshotController,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 22.0),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              "Nomor NISN :",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${widget.transactions.nis}",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: greenColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nama Siswa :",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Flexible(
                            child: Text(
                              "${widget.transactions.nama_siswa}",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kelas :",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Flexible(
                            child: Text(
                              kelasController.text,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Waktu :",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm').format(
                              widget.transactions.created_at ?? DateTime.now(),
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tanggal :",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            DateFormat('dd MMMM yyyy').format(
                              widget.transactions.created_at ?? DateTime.now(),
                            ),
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Tingkat Sekolah :",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                tingkatSekolah.text,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "Nominal :",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "Rp ${NumberFormat.currency(
                                    locale: 'id_ID',
                                    symbol: '',
                                  ).format(nominal)}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "Status Pengajuan :",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${widget.transactions.status}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: greenColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 8.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Keterangan :",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _isExpanded
                                    ? widget.transactions.keterangan!
                                    : _getKeterangan(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              if (widget.transactions.keterangan != null &&
                                  widget.transactions.keterangan!.length >
                                      20) ...[
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isExpanded = !_isExpanded;
                                    });
                                  },
                                  child: Text(
                                    _isExpanded ? 'Show Less' : 'Read More',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                indent: 4,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                endIndent: 4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(),
                                  body: Container(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: PhotoView(
                                        imageProvider: NetworkImage(
                                          'https://arrahman.site/api_spp/uploads/${widget.transactions.image}',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.network(
                              'https://arrahman.site/api_spp/uploads/${widget.transactions.image}',
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                indent: 4,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                endIndent: 4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CustomDetailPaymentButton(
                    title: 'Bagikan Bukti Bayar',
                    onPressed: _takeScreenshot,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
