// ignore_for_file: unused_field

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_screenshot/flutter_native_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:spp_app/blocs/auth/auth_bloc.dart';
import 'package:spp_app/shared/theme.dart';

class ScreenshotContainer extends StatefulWidget {
  final Widget child;

  const ScreenshotContainer({Key? key, required this.child}) : super(key: key);

  @override
  State<ScreenshotContainer> createState() => _ScreenshotContainerState();
}

class _ScreenshotContainerState extends State<ScreenshotContainer> {
  final nisController = TextEditingController(text: '');
  final namasiswaController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  File _imageFile = File('');
  Future<void> _takeScreenshot() async {
    try {
      String? imagePath = await FlutterNativeScreenshot.takeScreenshot();
      if (imagePath != null) {
        Uint8List bytes = await imageToByte(imagePath);
        setState(() {
          _imageFile = File.fromRawPath(bytes);
        });
        Directory tempDir = await getTemporaryDirectory();
        File imgFile = File('${tempDir.path}/screenshot.png');
        imgFile.writeAsBytesSync(bytes);
        print("File Saved");
        await Share.shareFiles([imgFile.path],
            text:
                'Sumbangan Pengembangan Pendidikan NIS: ${nisController.text}, Nama Siswa: ${namasiswaController.text}');
      }
    } catch (e) {
      print('Error taking screenshot: $e');
    }
  }

  Future<Uint8List> imageToByte(String path) async {
    File file = File(path);
    Uint8List bytes = await file.readAsBytes();
    return bytes;
  }

  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      nisController.text = authState.user.nipd!;
      namasiswaController.text = authState.user.nama_siswa!;
      passwordController.text = authState.user.password!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22.0),
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border.all(
          width: 0.5,
          color: lightBackgroundColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: widget.child,
    );
  }
}
