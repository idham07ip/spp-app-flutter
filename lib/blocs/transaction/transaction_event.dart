part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class TransactionGet extends TransactionEvent {
  final String nipd;

  TransactionGet({
    required this.nipd,
  });

  @override
  List<Object> get props => [nipd];
}

class TransactionGetByDate extends TransactionEvent {
  final String nipd;
  final String startDate;
  final String endDate;
  final String sort;

  TransactionGetByDate({
    required this.nipd,
    required this.startDate,
    required this.endDate,
    required this.sort,
  });

  @override
  List<Object> get props => [nipd, startDate, endDate, sort];
}
