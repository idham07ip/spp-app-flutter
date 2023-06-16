part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionGet extends TransactionEvent {
  final String nis;

  TransactionGet({
    required this.nis,
  });

  @override
  List<Object> get props => [nis];
}

class TransactionGetByDate extends TransactionEvent {
  final String nis;
  final String startDate;
  final String endDate;
  final String sort;

  TransactionGetByDate({
    required this.nis,
    required this.startDate,
    required this.endDate,
    required this.sort,
  });

  @override
  List<Object> get props => [nis, startDate, endDate, sort];
}
