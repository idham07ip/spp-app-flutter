class UserModel {
  String? nama_siswa;
  String? nipd;
  String? kelas;
  String? instansi;
  String? thn_akademik;
  String? password;
  String? status;
  String? role_id;

  UserModel({
    this.nama_siswa,
    this.nipd,
    this.kelas,
    this.instansi,
    this.thn_akademik,
    this.password,
    this.status,
    this.role_id,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    nama_siswa = json['nama_siswa'];
    nipd = json['nipd'];
    kelas = json['kelas'];
    instansi = json['instansi'];
    instansi = json['instansi'];
    thn_akademik = json['thn_akademik'];
    password = json['password'];
    status = json['status'];
    role_id = json['role_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nama_siswa'] = nama_siswa;
    data['nipd'] = nipd;
    data['kelas'] = kelas;
    data['instansi'] = instansi;
    data['instansi'] = instansi;
    data['thn_akademik'] = thn_akademik;
    data['password'] = password;
    data['status'] = status;
    data['role_id'] = role_id;
    return data;
  }

  UserModel copyWith({
    String? nama_siswa,
    String? nipd,
    String? kelas,
    String? instansi,
    String? thn_akademik,
    String? password,
    String? status,
  }) =>
      UserModel(
        nama_siswa: nama_siswa ?? this.nama_siswa,
        nipd: nipd ?? this.nipd,
        kelas: kelas ?? this.kelas,
        instansi: instansi ?? this.instansi,
        thn_akademik: thn_akademik ?? this.thn_akademik,
        password: password ?? this.password,
        status: status ?? this.status,
      );
}
