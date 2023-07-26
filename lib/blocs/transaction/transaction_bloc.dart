import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/service/payment_method_service.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<TransactionEvent>((event, emit) async {
      if (event is TransactionGet) {
        try {
          emit(TransactionLoading());

          final transactions =
              await PaymentMethodService().getTransaction(event.nipd);

          emit(TransactionSuccess(transactions));
        } catch (e) {
          emit(TransactionFailed(e.toString()));
        }
      }
    });
  }
}
