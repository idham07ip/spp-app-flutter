part of 'pembayaran_bloc.dart';

abstract class PembayaranEvent extends Equatable {
  const PembayaranEvent();

  @override
  List<Object> get props => [];
}

class PembayaranPost extends PembayaranEvent {
  final PembayaranFormModel data;
  final PlatformFile? platformFile;

  const PembayaranPost(this.data, {this.platformFile});

  @override
  List<Object> get props => [data, platformFile!];
}

class PembayaranSelectFile extends PembayaranEvent {
  final PlatformFile? platformFile;
  const PembayaranSelectFile(this.platformFile);

  @override
  List<Object> get props => [
        if (platformFile != null) platformFile!,
      ];
}
