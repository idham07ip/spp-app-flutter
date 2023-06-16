import 'package:file_picker/file_picker.dart';

class PembayaranFormModel {
  final String? nis;
  final String? nama_siswa;
  final String? instansi;
  final String? nominal;
  final String? keterangan;
  final String? tahun_akademik;
  final PlatformFile? image;

  PembayaranFormModel({
    this.nis,
    this.nama_siswa,
    this.instansi,
    this.nominal,
    this.keterangan,
    this.tahun_akademik,
    this.image,
  });

  PembayaranFormModel copyWith({
    String? nis,
    String? nama_siswa,
    String? instansi,
    String? nominal,
    String? keterangan,
    String? tahun_akademik,
    PlatformFile? image,
  }) =>
      PembayaranFormModel(
        nis: nis ?? this.nis,
        nama_siswa: nama_siswa ?? this.nama_siswa,
        instansi: instansi ?? this.instansi,
        nominal: nominal ?? this.nominal,
        keterangan: keterangan ?? this.keterangan,
        tahun_akademik: tahun_akademik ?? this.tahun_akademik,
        image: image ?? this.image,
      );

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'nama_siswa': nama_siswa,
      'instansi': instansi,
      'nominal': nominal,
      'keterangan': keterangan,
      'tahun_akademik': tahun_akademik,
      'image': image?.path, // Use the file path
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'nama_siswa': nama_siswa,
      'instansi': instansi,
      'keterangan': keterangan,
      'tahun_akademik': tahun_akademik,
      'image': image?.path, // Use the file path
    };
  }
}
