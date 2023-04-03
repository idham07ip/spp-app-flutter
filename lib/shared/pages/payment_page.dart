import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/bank_item.dart';
import 'package:spp_app/shared/widgets/buttons.dart';
import 'package:spp_app/shared/widgets/forms.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:spp_app/shared/pages/snap_web_view_screen.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class Payment {
  final int id;
  final String name;

  Payment({
    required this.id,
    required this.name,
  });
}

// //Month
class Month {
  final int id;
  final String month;

  Month({
    required this.id,
    required this.month,
  });
}

//
class _PaymentPageState extends State<PaymentPage> {
  final namaController = TextEditingController();
  final kategoriController = TextEditingController();
  final bulanController = TextEditingController();
  final tipeController = TextEditingController();

  final TextEditingController _url = TextEditingController();
  // //Multi Select Month
  static final List<Month> _bulan = [
    Month(id: 1, month: "Januari"),
    Month(id: 2, month: "Februari"),
    Month(id: 3, month: "Maret"),
    Month(id: 4, month: "April"),
    Month(id: 5, month: "Mei"),
    Month(id: 6, month: "Juni"),
    Month(id: 7, month: "Juli"),
    Month(id: 8, month: "Agustus"),
    Month(id: 9, month: "September"),
    Month(id: 10, month: "Oktober"),
    Month(id: 11, month: "November"),
    Month(id: 12, month: "Desember"),
  ];

  final _items2 = _bulan
      .map((month) => MultiSelectItem<Month>(month, month.month))
      .toList();

  final List<Month> _selectedMonths = [];
  final List<Month> _selectedMonths2 = [];
  final List<Month> _selectedMonths3 = [];
  final List<Month> _selectedMonths4 = [];
  final List<Month> _selectedMonths5 = [];
  final List<Month> _selectedMonths6 = [];
  final List<Month> _selectedMonths7 = [];
  final List<Month> _selectedMonths8 = [];
  final List<Month> _selectedMonths9 = [];
  final List<Month> _selectedMonths10 = [];
  final List<Month> _selectedMonths11 = [];
  List<Month> _selectedMonths12 = [];

  final _multiSelectKeyMonth = GlobalKey<FormFieldState>();

  @override
  void initStateMonth() {
    _selectedMonths12 = _bulan;
    super.initState();
  }
  //

  // MultiSelect Payment Start
  static final List<Payment> _payments = [
    Payment(id: 1, name: "SPP"),
    Payment(id: 2, name: "Tabungan"),
  ];

  final _items = _payments
      .map((payment) => MultiSelectItem<Payment>(payment, payment.name))
      .toList();
  final List<Payment> _selectedPayments = [];
  List<Payment> _selectedPayments2 = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _selectedPayments2 = _payments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: whiteColor,
              toolbarHeight: 70,
              title: const Text(
                'Pembayaran',
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              children: [
                const SizedBox(
                  height: 30,
                ),

                Text(
                  'Nama Siswa',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),

                //
                const SizedBox(
                  height: 10,
                ),

                //
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.7,
                    vertical: 4.7,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(
                      17.8,
                    ),
                  ),

                  //
                  child: Center(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: namaController,
                          style: TextStyle(
                            fontWeight: bold,
                          ),
                          decoration: InputDecoration(
                            hintText: state.user.nama_siswa.toString(),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                //
                Text(
                  'Tingkat Sekolah',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),

                //
                const SizedBox(
                  height: 10,
                ),

                //
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.7,
                    vertical: 4.7,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(
                      17.8,
                    ),
                  ),

                  //
                  child: Center(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: kategoriController,
                          style: TextStyle(
                            fontWeight: bold,
                          ),
                          decoration: InputDecoration(
                            hintText: state.user.kategori_sekolah.toString(),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                            enabled: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Text(
                  'Pilih Kategori Pembayaran',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                //
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      MultiSelectDialogField(
                        dialogHeight: 120,
                        items: _items,
                        title: Text("Kategori"),
                        selectedColor: blackColor,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: greyColor,
                            width: 2,
                          ),
                        ),
                        buttonIcon: Icon(
                          Icons.arrow_drop_down,
                          color: blackColor,
                        ),
                        buttonText: Text(
                          "Kategori Pembayaran",
                          style: TextStyle(
                            height: 2,
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        onConfirm: (results) {},
                      ),
                    ],
                  ),
                ),

                //

                //
                const SizedBox(
                  height: 30,
                ),

                Text(
                  'Pilih Bulan Pembayaran',
                  style: blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: semiBold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                //
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      MultiSelectDialogField(
                        dialogHeight: 240,
                        items: _items2,
                        title: Text(
                          "Bulan",
                        ),
                        selectedColor: blackColor,
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: greyColor,
                            width: 2,
                          ),
                        ),
                        buttonIcon: Icon(
                          Icons.arrow_drop_down,
                          color: blackColor,
                        ),
                        buttonText: Text(
                          "Pilih Bulan",
                          style: TextStyle(
                            height: 2,
                            color: greyColor,
                            fontSize: 14,
                            fontWeight: bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        onConfirm: (results) {},
                      ),
                    ],
                  ),
                ),
                //

                const SizedBox(
                  height: 30,
                ),

                //
                Row(
                  children: [
                    Text(
                      'Masukkan Nominal Pembayaran',
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
                            borderRadius: BorderRadius.all(Radius.circular(13)),
                          ),
                          title: const Text(
                            'Informasi Jumlah Pembayaran',
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
                                  'SPP',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),

                                //
                                const Text(
                                  'TK = 250 RIBU / BULAN \nSD = 225 RIBU s/d 500 RIBU / BULAN \nSMP = 100 RIBU s/d 300 RIBU / BULAN \n PONDOK = 1 JT / BULAN',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),

                                //
                                const SizedBox(
                                  height: 14,
                                ),

                                //Tabungan
                                const Text(
                                  'TABUNGAN',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                  ),
                                ),

                                //
                                const Text(
                                  'SD = 25 RIBU / BULAN',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
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

                const SizedBox(
                  height: 18,
                ),

                //Jumlah Pembayaran
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.6,
                    vertical: 4.6,
                  ),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(
                      16.8,
                    ),
                  ),
                  // padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      //
                      TextFormField(
                        style: TextStyle(
                          fontWeight: bold,
                        ),
                        decoration: new InputDecoration(
                          labelText: "Jumlah Pembayaran",
                          prefixIcon: Text(
                            '  Rp',
                            style: blackTextStyle.copyWith(
                              height: 2.5,
                              fontSize: 16,
                              fontWeight: bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          contentPadding: const EdgeInsets.all(19),
                          enabled: true,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 24,
                ),

                //
                CustomFilledButton(
                  title: 'Bayar',
                  onPressed: () async {
                    String url;
                    url =
                        "https://app.midtrans.com/payment-links/1680155296864";

                    Navigator.of(context).pushNamed(
                      SnapWebViewScreen.routeName,
                      arguments: {
                        'url': url,
                      },
                    );
                  },
                ),

                const SizedBox(
                  height: 57,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
