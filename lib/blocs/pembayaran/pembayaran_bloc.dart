import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spp_app/model/pembayaran_form_model.dart';
import 'package:spp_app/service/local_notification.dart';
import 'package:spp_app/service/payment_method_service.dart';

part 'pembayaran_event.dart';
part 'pembayaran_state.dart';

class PembayaranBloc extends Bloc<PembayaranEvent, PembayaranState> {
  PembayaranBloc() : super(const PembayaranInitial()) {
    on<PembayaranEvent>((event, emit) async {
      if (event is PembayaranPost) {
        try {
          emit(PembayaranLoading());

          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
            if (event.data.image != null) {
              // Menyesuaikan dengan atribut image pada objek data
              final data = await PaymentMethodService().payment(
                event.data,
                event.data
                    .image, // Menyesuaikan dengan atribut image pada objek data
              );
              emit(PembayaranSuccess(data));
            } else {
              emit(PembayaranFailed('File gambar belum dipilih.'));
            }
          } else {
            emit(PembayaranFailed('Tidak ada koneksi internet.'));
          }
        } catch (e) {
          print('Error during payment: $e');
          emit(PembayaranFailed(e.toString()));
        }

        if (state is! PembayaranFailed) {
          // Notifikasi hanya ditampilkan jika tidak terjadi kesalahan
          final bodyText =
              'Terimakasih Sudah Melakukan Pembayaran, Kami Doakan Semoga Ayah Bunda Sehat Selalu Ya 😊';
          await NotificationLocal.showNotification(
            id: 0,
            title: 'Arrahmah Boarding School Bogor',
            body: bodyText,
            payload: 'arrahman',
          );
        }
      }
    });
  }
}
