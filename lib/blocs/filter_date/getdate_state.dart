part of 'getdate_bloc.dart';

abstract class GetdateState extends Equatable {
  const GetdateState();

  @override
  List<Object> get props => [];
}

class GetdateInitial extends GetdateState {}

class GetdateLoading extends GetdateState {}

class GetdateFailed extends GetdateState {
  final String e;
  const GetdateFailed(this.e);

  @override
  List<Object> get props => [e];
}

class GetdateSuccess extends GetdateState {
  final List<TransactionFormModel> transactions;
  const GetdateSuccess(this.transactions);

  List<TransactionFormModel> get data => transactions;

  @override
  // TODO: implement props
  List<Object> get props => [transactions];
}
