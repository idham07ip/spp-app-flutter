class UserModel {
  String? nama_siswa;
  String? nis;
  String? kategori_sekolah;
  String? password;
  String? status;
  String? role_id;

  UserModel({
    this.nama_siswa,
    this.nis,
    this.kategori_sekolah,
    this.password,
    this.status,
    this.role_id,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    nama_siswa = json['nama_siswa'];
    nis = json['nis'];
    kategori_sekolah = json['kategori_sekolah'];
    password = json['password'];
    status = json['status'];
    role_id = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_siswa'] = nama_siswa;
    data['nis'] = nis;
    data['kategori_sekolah'] = kategori_sekolah;
    data['password'] = password;
    data['status'] = status;
    data['role_id'] = role_id;
    return data;
  }

  UserModel copyWith({
    String? nama_siswa,
    String? nis,
    String? kategori_sekolah,
    String? password,
  }) =>
      UserModel(
        nama_siswa: nama_siswa ?? this.nama_siswa,
        nis: nis ?? this.nis,
        kategori_sekolah: kategori_sekolah ?? this.kategori_sekolah,
        password: password ?? this.password,
      );
}
