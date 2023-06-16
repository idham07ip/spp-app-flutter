part of 'getdate_bloc.dart';

abstract class GetdateEvent extends Equatable {
  const GetdateEvent();

  @override
  List<Object> get props => [];
}

class Getdatefilter extends GetdateEvent {
  final String nis;
  final DateTime startDate;
  final DateTime endDate;

  Getdatefilter({
    required this.nis,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [nis, startDate, endDate];
}
