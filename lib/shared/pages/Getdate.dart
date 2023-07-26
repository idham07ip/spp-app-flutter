import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/model/transaction_form_model.dart';

class GetDate extends StatefulWidget {
  const GetDate({Key? key, required this.transaction}) : super(key: key);
  final TransactionFormModel transaction;
  @override
  State<GetDate> createState() => _GetDateState();
}

class _GetDateState extends State<GetDate> {
  final nisController = TextEditingController(text: '');
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nipd!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Widget buildGetFilter(BuildContext context) {
    return const Placeholder();
  }
}
