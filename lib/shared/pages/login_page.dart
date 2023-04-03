import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/model/sign_in_form_model.dart';
import 'package:spp_app/shared/helpers.dart';
import 'package:spp_app/shared/theme.dart';
import 'package:spp_app/shared/widgets/buttons.dart';
import 'package:spp_app/shared/widgets/forms.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nisController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  bool validate() {
    if (nisController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          }

          if (state is AuthFailed) {
            showCustomSnackbar(context, state.e);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 24,
            ),
            children: [
              Container(
                width: 155,
                height: 250,
                margin: const EdgeInsets.only(top: 70, bottom: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/auth.png',
                    ),
                  ),
                ),
              ),
              Text(
                "Login &\nSmart Honest n Hafidz Al-Qur'an",
                style: blackTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: semiBold,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note username input
                    CustomFormField(
                      title: 'Nomor Induk Siswa',
                      controller: nisController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Note password input
                    CustomFormField(
                      title: 'Password',
                      obscureText: true,
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    CustomFilledButton(
                      title: 'Login',
                      onPressed: () {
                        if (validate()) {
                          context.read<AuthBloc>().add(
                                AuthLogin(
                                  SignInFormModel(
                                      nis: nisController.text,
                                      password: passwordController.text),
                                ),
                              );
                        } else {
                          showCustomSnackbar(context, 'Isi Semua Form Log In');
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
