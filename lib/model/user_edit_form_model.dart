class UserEditFormModel {
  final String? nipd;
  final String? nama_siswa;
  final String? password;

  UserEditFormModel({
    this.nipd,
    this.nama_siswa,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nipd': nipd,
      'nama_siswa': nama_siswa,
      'password': password,
    };
  }
}
