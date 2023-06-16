part of 'student_bloc.dart';

abstract class StudentState extends Equatable {
  const StudentState();

  @override
  List<Object> get props => [];
}

class StudentInitial extends StudentState {}

class StudentFailed extends StudentState {
  final e;
  const StudentFailed(this.e);

  @override
  // TODO: implement props
  List<Object> get props => [e];
}

class StudentLoading extends StudentState {}

class StudentSuccess extends StudentState {
  final DataPriceModel price;
  const StudentSuccess(this.price);

  @override
  // TODO: implement props
  List<Object> get props => [price];
}
