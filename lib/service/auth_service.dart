import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spp_app/model/sign_in_form_model.dart';
import 'package:spp_app/model/user_edit_form_model.dart';
import 'package:spp_app/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://arrahman.site/api_spp/api';
  static const String token = 'KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9';

  Future<void> updateUser(UserEditFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/update'),
        body: data.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(res.body);

      if (res.statusCode != 200 || res.statusCode != 201) {
      } else {
        jsonDecode(res.body)['message'];
      }
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
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final user = UserModel.fromJson(jsonDecode(res.body));
        user.password = data.password;

        await storeCredentialToLocal(user);

        return user;
      } else if (res.statusCode == 403) {
        throw Exception('Invalid credentials');
      } else {
        throw Exception('Failed to login');
      }
    } on HandshakeException catch (e) {
      throw Exception('Handshake error: ${e.toString()}');
    } on SocketException {
      throw Exception('Network error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'nis', value: user.nis);
      await storage.write(key: 'nama_siswa', value: user.nama_siswa);
      await storage.write(key: 'password', value: user.password);
      await storage.write(key: 'kategori_sekolah', value: user.kelas);
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
        throw Exception('Please Do Login Again');
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
