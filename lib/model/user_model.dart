class UserModel {
  String? nama_siswa;
  String? nis;
  String? kelas;
  String? instansi;
  String? tahun_akademik;
  String? password;
  String? status;
  String? role_id;

  UserModel({
    this.nama_siswa,
    this.nis,
    this.kelas,
    this.instansi,
    this.tahun_akademik,
    this.password,
    this.status,
    this.role_id,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    nama_siswa = json['nama_siswa'];
    nis = json['nis'];
    kelas = json['kelas'];
    instansi = json['instansi'];
    instansi = json['instansi'];
    tahun_akademik = json['tahun_akademik'];
    password = json['password'];
    status = json['status'];
    role_id = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_siswa'] = nama_siswa;
    data['nis'] = nis;
    data['kelas'] = kelas;
    data['instansi'] = instansi;
    data['instansi'] = instansi;
    data['tahun_akademik'] = tahun_akademik;
    data['password'] = password;
    data['status'] = status;
    data['role_id'] = role_id;
    return data;
  }

  UserModel copyWith({
    String? nama_siswa,
    String? nis,
    String? kelas,
    String? instansi,
    String? tahun_akademik,
    String? password,
  }) =>
      UserModel(
        nama_siswa: nama_siswa ?? this.nama_siswa,
        nis: nis ?? this.nis,
        kelas: kelas ?? this.kelas,
        instansi: instansi ?? this.instansi,
        tahun_akademik: tahun_akademik ?? this.tahun_akademik,
        password: password ?? this.password,
      );
}
