part of 'student_bloc.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();

  @override
  List<Object> get props => [];
}

class GetPriceSiswa extends StudentEvent {
  final String nipd;

  GetPriceSiswa({required this.nipd});

  @override
  // TODO: implement props
  List<Object> get props => [nipd];
}
