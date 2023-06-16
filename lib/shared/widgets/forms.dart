import 'package:flutter/material.dart';
import 'package:spp_app/shared/theme.dart';

class CustomFormField extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool visible;

  const CustomFormField({
    Key? key,
    required this.title,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
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

class CustomFormPassword extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool visible;
  final InputDecoration decoration;

  const CustomFormPassword({
    Key? key,
    required this.title,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
    this.visible = true,
    this.decoration = const InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      contentPadding: EdgeInsets.all(12),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          readOnly: readOnly,
          decoration: decoration.copyWith(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}

class CustomFormNis extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool visible;
  final InputDecoration decoration;

  const CustomFormNis({
    Key? key,
    required this.title,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
    this.visible = true,
    this.decoration = const InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
      contentPadding: EdgeInsets.all(12),
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          readOnly: readOnly,
          decoration: decoration.copyWith(
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}

class CustomLogin extends StatelessWidget {
  final String title;
  final String hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final bool visible;

  const CustomLogin({
    Key? key,
    required this.title,
    this.hintText = '',
    this.obscureText = false,
    this.readOnly = false,
    this.controller,
    this.visible = true,
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
