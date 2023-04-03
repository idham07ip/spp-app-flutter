import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spp_app/model/sign_in_form_model.dart';
import 'package:spp_app/model/user_edit_form_model.dart';
import 'package:spp_app/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://192.168.56.1/api_spp/api/';

  Future<void> updateUser(UserEditFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/update'),
        body: data.toJson(),
      );

      print(res.body);

      if (res.statusCode != 200 || res.statusCode != 201) {}
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> login(SignInFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/login',
        ),
        body: data.toJson(),
      );

      print(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        final user = UserModel.fromJson(jsonDecode(res.body));
        user.password = data.password;

        await storeCredentialToLocal(user);

        return user;
      } else {
        throw 'Invalid Email And Password';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'nis', value: user.nis);
      await storage.write(key: 'nama_siswa', value: user.nama_siswa);
      await storage.write(key: 'password', value: user.password);
      await storage.write(
          key: 'kategori_sekolah', value: user.kategori_sekolah);
    } catch (e) {
      rethrow;
    }
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();
      Map<String, dynamic> values = await storage.readAll();

      if (values['nis'] != null) {
        final SignInFormModel data = SignInFormModel(
          nis: values['nis'],
          password: values['password'],
        );

        print('get user from local: ${data.toJson()}');

        return data;
      } else {
        throw 'Please Do Login Again';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> Logout() async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/logout',
        ),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        await ClearStorage();
      } else {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> ClearStorage() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
