part of 'pembayaran_bloc.dart';

class PembayaranState extends Equatable {
  final bool isFileSelected;

  const PembayaranState({
    required this.isFileSelected,
  });

  @override
  List<Object?> get props => [isFileSelected];
}

class PembayaranInitial extends PembayaranState {
  const PembayaranInitial() : super(isFileSelected: false);
}

class PembayaranLoading extends PembayaranState {
  const PembayaranLoading() : super(isFileSelected: true);
}

class PembayaranFailed extends PembayaranState {
  final e;

  const PembayaranFailed(this.e) : super(isFileSelected: true);

  @override
  List<Object> get props => [e];
}

class PembayaranSuccess extends PembayaranState {
  final String successMessage;

  const PembayaranSuccess(this.successMessage) : super(isFileSelected: true);

  @override
  List<Object?> get props => [successMessage, isFileSelected];
}
