import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spp_app/model/transaction_form_model.dart';
import 'package:spp_app/service/payment_method_service.dart';

part 'getdate_event.dart';
part 'getdate_state.dart';

class GetdateBloc extends Bloc<GetdateEvent, GetdateState> {
  GetdateBloc() : super(GetdateInitial()) {
    on<GetdateEvent>((event, emit) async {
      if (event is Getdatefilter) {
        try {
          emit(GetdateLoading());

          final transactions = await PaymentMethodService()
              .getTransactionDate(event.nipd, event.startDate, event.endDate);

          emit(GetdateSuccess(transactions));
        } catch (e) {
          emit(GetdateFailed(e.toString()));
        }
      }
    });
  }
}
