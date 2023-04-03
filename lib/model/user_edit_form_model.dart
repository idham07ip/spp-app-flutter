class UserEditFormModel {
  final String? nis;
  final String? nama_siswa;
  final String? password;

  UserEditFormModel({
    this.nis,
    this.nama_siswa,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_siswa': nama_siswa,
      'password': password,
    };
  }
}
