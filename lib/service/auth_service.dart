import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spp_app/model/sign_in_form_model.dart';
import 'package:spp_app/model/user_edit_form_model.dart';
import 'package:spp_app/model/user_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'https://arrahman.site/spp-web/api';
  static const String token = 'KE9NDFUZ7KO2XNG43QQXVMIFKOL4L7H9';

  Future<UserModel> updateUser(UserEditFormModel data) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/update'),
        body: data.toJson(),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final updatedUser = UserModel.fromJson(jsonDecode(res.body));
        return updatedUser;
      } else {
        throw Exception('Failed to update user.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String?>> getDataSiswa(String nipd) async {
    final response = await http.post(
      Uri.parse('$baseUrl/getdatasiswa'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nipd': nipd,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<UserModel> siswaList =
          data.map((item) => UserModel.fromJson(item)).toList();

      // Cek apakah ada data siswa yang berhasil diambil
      if (siswaList.isNotEmpty) {
        // Jika ada, kembalikan tahun akademik dari data pertama
        final String? tahunAkademik = siswaList[0].thn_akademik;
        // Buat map yang berisi data siswa dan tahun akademik
        return {'tahunAkademik': tahunAkademik};
      } else {
        throw Exception('Data siswa tidak ditemukan.');
      }
    } else {
      throw Exception('Failed to load data');
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

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final user = UserModel.fromJson(jsonDecode(res.body));
        user.password = data.password;

        await storeCredentialToLocal(user);

        return user;
      } else {
        final responseJson = jsonDecode(res.body);
        final error = responseJson['error'] ?? 'Unknown error occurred';
        throw (error);
      }
    } on HandshakeException catch (e) {
      throw Exception('Handshake error: ${e.toString()}');
    } on SocketException {
      throw Exception('Network error');
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> storeCredentialToLocal(UserModel user) async {
    try {
      const storage = FlutterSecureStorage();
      await storage.write(key: 'nipd', value: user.nipd);
      await storage.write(key: 'nama_siswa', value: user.nama_siswa);
      await storage.write(key: 'password', value: user.password);
      await storage.write(key: 'kategori_sekolah', value: user.kelas);
      await storage.write(key: 'status', value: user.status);
    } catch (e) {
      rethrow;
    }
  }

  Future<SignInFormModel> getCredentialFromLocal() async {
    try {
      const storage = FlutterSecureStorage();
      Map<String, dynamic> values = await storage.readAll();

      if (values['nipd'] != null) {
        final SignInFormModel data = SignInFormModel(
          nipd: values['nipd'],
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
