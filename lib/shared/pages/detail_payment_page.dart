import 'package:flutter/material.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/buttons.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBackgroundColor,
        appBar: AppBar(
          backgroundColor: whiteColor,
          toolbarHeight: 70,
          title: const Text(
            'Detail Pembayaran',
          ),
        ),

        //
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 35),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 22.0),
            decoration: BoxDecoration(
              color: whiteColor,
              border: Border.all(
                width: 0.5,
                color: lightBackgroundColor,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),

            //
            child: Column(
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
                      //NISN
                      Text(
                        "Nomor NISN",
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                          fontWeight: bold,
                        ),
                      ),

                      //
                      Text(
                        "0024306262",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: semiBold,
                          color: greenColor,
                        ),
                      ),

                      //
                      Container(
                          width: 60.0,
                          child: Icon(Icons.payment,
                              color: greenColor, size: 40.0)),
                    ],
                  ),
                ),

                SizedBox(
                  height: 13,
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal Pembayaran",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontWeight: bold,
                            ),
                          ),
                          Text(
                            "Selasa 19 April 2023",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                              fontWeight: medium,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 45.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jam",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: semiBold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              "19.20",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: semiBold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //
                SizedBox(
                  height: 13,
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Nama Siswa",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            "Siti Aminah",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: medium,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 45.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kelas",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: semiBold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              "1 SMP",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: semiBold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status Pembayaran",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 45.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lunas",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: greenColor,
                                fontWeight: semiBold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //
                SizedBox(
                  height: 13,
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kategori Pembayaran",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 45.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SPP",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: semiBold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //
                SizedBox(
                  height: 13,
                ),

                //
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jumlah",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rp. 300.000;",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: semiBold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //
                SizedBox(
                  height: 13,
                ),

                Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Expanded(child: Divider()),
                ]),
                //
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: extraBold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rp. 300.000;",
                            style: TextStyle(
                              fontSize: 14.0,
                              color: greenColor,
                              fontWeight: semiBold,
                              fontFamily: 'Poppins',
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

          //
          const SizedBox(
            height: 30,
          ),

          //
          CustomDetailPaymentButton(
            title: 'Kembali ke Beranda',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
          ),
        ])));
  }
}
