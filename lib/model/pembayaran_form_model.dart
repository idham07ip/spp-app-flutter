import 'package:file_picker/file_picker.dart';

class PembayaranFormModel {
  final String? nipd;
  final String? nama_siswa;
  final String? instansi;
  final String? nominal;
  final String? keterangan;
  final String? thn_akademik;
  final PlatformFile? image;
  final String? startRangeDate; // Add this field
  final String? endRangeDate; // Add this field

  PembayaranFormModel({
    this.nipd,
    this.nama_siswa,
    this.instansi,
    this.nominal,
    this.keterangan,
    this.thn_akademik,
    this.image,
    this.startRangeDate, // Initialize the fields
    this.endRangeDate,
  });

  PembayaranFormModel copyWith({
    String? nipd,
    String? nama_siswa,
    String? instansi,
    String? nominal,
    String? keterangan,
    String? thn_akademik,
    PlatformFile? image,
    String? startRangeDate, // Add the startRangeDate field to copyWith
    String? endRangeDate, // Add the endRangeDate field to copyWith
  }) {
    return PembayaranFormModel(
      nipd: nipd ?? this.nipd,
      nama_siswa: nama_siswa ?? this.nama_siswa,
      instansi: instansi ?? this.instansi,
      nominal: nominal ?? this.nominal,
      keterangan: keterangan ?? this.keterangan,
      thn_akademik: thn_akademik ?? this.thn_akademik,
      image: image ?? this.image,
      startRangeDate: startRangeDate ??
          this.startRangeDate, // Assign the new fields in copyWith
      endRangeDate: endRangeDate ??
          this.endRangeDate, // Assign the new fields in copyWith
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nipd': nipd,
      'nama_siswa': nama_siswa,
      'instansi': instansi,
      'nominal': nominal,
      'keterangan': keterangan,
      'thn_akademik': thn_akademik,
      'image': image?.path,
      'start_range_date': startRangeDate, // Add start range date
      'end_range_date': endRangeDate, // Add end range date
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'nipd': nipd,
      'nama_siswa': nama_siswa,
      'instansi': instansi,
      'keterangan': keterangan,
      'thn_akademik': thn_akademik,
      'image': image?.path, // Use the file path
    };
  }
}
