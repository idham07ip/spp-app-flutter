// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomFormUpload extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomFormUpload({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        TextField(
          obscureText: obscureText,
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
          decoration: new InputDecoration(
            hintText: hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.7),
              borderRadius: BorderRadius.circular(18),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 1.7),
              borderRadius: BorderRadius.circular(18),
            ),
            contentPadding: const EdgeInsets.all(22),
          ),
        ),
      ],
    );
  }
}

class CustomFormPaymentNumbers extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomFormPaymentNumbers({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
  }) : super(key: key);

  @override
  _CustomFormPaymentNumbersState createState() =>
      _CustomFormPaymentNumbersState();
}

class _CustomFormPaymentNumbersState extends State<CustomFormPaymentNumbers> {
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;
  String? _errorMessage;
  // final CurrencyInputFormatter _inputFormatter = CurrencyInputFormatter();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_validateInputOnFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_validateInputOnFocusChange);
    super.dispose();
  }

  void _validateInputOnFocusChange() {
    setState(() {
      _hasError =
          !_focusNode.hasFocus && _validateInput(widget.controller?.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        TextField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          readOnly: widget.readOnly,
          focusNode: _focusNode,
          style: TextStyle(),
          decoration: InputDecoration(
            hintText: widget.hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _hasError ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _hasError ? Colors.red : Colors.black,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            errorText: _hasError ? _errorMessage : null,
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            // FilteringTextInputFormatter.digitsOnly,
            // _inputFormatter,
          ],
          onChanged: _validateInputOnChange,
        ),
      ],
    );
  }

  void _validateInputOnChange(String input) {
    setState(() {
      _hasError = _validateInput(input);
      _errorMessage = _getErrorMessage(input);
    });
  }

  bool _validateInput(String? input) {
    if (input == null || input.isEmpty) {
      return true;
    }

    if (input.startsWith('0')) {
      return true;
    }

    if (input.length > 12) {
      return true;
    }

    return false;
  }

  String? _getErrorMessage(String? input) {
    if (input == null || input.isEmpty) {
      return 'Input tidak boleh kosong';
    }

    if (input.startsWith('0')) {
      return 'Input tidak boleh dimulai dengan angka 0';
    }

    if (input.length > 12) {
      return 'Input tidak boleh lebih dari 12 digit';
    }

    return null;
  }
}

// class CurrencyInputFormatter extends TextInputFormatter {
//   final NumberFormat _currencyFormat = NumberFormat.currency(
//     locale: 'id_ID',
//     symbol: '',
//     decimalDigits: 0,
//   );

//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }

//     final sanitizedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

//     final formattedText = _currencyFormat.format(
//       int.parse(sanitizedText),
//     );

//     return TextEditingValue(
//       text: formattedText,
//       selection: TextSelection.collapsed(offset: formattedText.length),
//     );
//   }
// }

class CustomFormPayment extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final String? errorText;

  const CustomFormPayment({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  _CustomFormPaymentState createState() => _CustomFormPaymentState();
}

class _CustomFormPaymentState extends State<CustomFormPayment> {
  final FocusNode _focusNode = FocusNode();
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasError =
            !_focusNode.hasFocus && _validateInput(widget.controller?.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        TextField(
          obscureText: widget.obscureText,
          controller: widget.controller,
          readOnly: widget.readOnly,
          focusNode: _focusNode,
          style: TextStyle(),
          decoration: new InputDecoration(
            hintText: widget.hintText,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _hasError ? Colors.red : Theme.of(context).primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: _hasError ? Colors.red : Colors.black,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            errorText:
                _hasError ? _getErrorMessage(widget.controller?.text) : null,
          ),
        ),
      ],
    );
  }

  String? _getErrorMessage(String? text) {
    if (_validateInput(text)) {
      return _getValidationMessage(text);
    }
    return widget.errorText;
  }

  bool _validateInput(String? text) {
    if (text?.isEmpty ?? true) {
      return true;
    }
    if (text!.length > 140) {
      return true;
    }
    final sqlXSS = RegExp(r'[<>;=]');
    if (sqlXSS.hasMatch(text)) {
      return true;
    }
    return false;
  }

  String? _getValidationMessage(String? text) {
    if (text?.isEmpty ?? true) {
      return 'Input tidak boleh kosong';
    }
    if (text!.length > 140) {
      return 'Karakter terlalu panjang';
    }
    final sqlXSS = RegExp(r'[<>;=]');
    if (sqlXSS.hasMatch(text)) {
      return 'Input mengandung karakter yang tidak diperbolehkan';
    }
    return null;
  }
}

//Custom Form for Name
class CustomFormName extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomFormName({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        TextField(
          obscureText: obscureText,
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(),
          decoration: new InputDecoration(
            hintText: hintText,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}

class CustomFormTingkatSekolah extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomFormTingkatSekolah({
    Key? key,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        TextField(
          obscureText: obscureText,
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(),
          decoration: new InputDecoration(
            hintText: hintText,
            focusedBorder: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
