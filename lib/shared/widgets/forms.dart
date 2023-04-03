import 'package:flutter/material.dart';
import 'package:spp_app/shared/theme.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;

  const CustomFormField({
    Key? key,
    required this.title,
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
        Text(
          title,
          style: blackTextStyle.copyWith(
            fontWeight: medium,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
