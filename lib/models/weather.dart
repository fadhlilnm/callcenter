class DailyWeather {
  final String localDatetime;
  final String suhuUdara;
  final String tutupanAwan;
  final int kodeCuaca;
  final String kondisiCuaca;
  final int arahAnginDerajat;
  final String arahAngin;
  final String kecepatanAngin;
  final String kelembapan;
  final String jarakPandang;
  final String timeIndex;
  final String analysisDate;
  final String image;
  final String utcDatetime;
  String wilayah; // Tambahkan ini sebagai opsional

  DailyWeather({
    required this.localDatetime,
    required this.suhuUdara,
    required this.tutupanAwan,
    required this.kodeCuaca,
    required this.kondisiCuaca,
    required this.arahAnginDerajat,
    required this.arahAngin,
    required this.kecepatanAngin,
    required this.kelembapan,
    required this.jarakPandang,
    required this.timeIndex,
    required this.analysisDate,
    required this.image,
    required this.utcDatetime,
    this.wilayah = 'Tidak Diketahui',
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      localDatetime: json['local_datetime'] ?? 'Tidak Diketahui',
      suhuUdara: json['suhu_udara'] ?? 'Tidak Diketahui',
      tutupanAwan: json['tutupan_Awan'] ?? 'Tidak Diketahui',
      kodeCuaca: json['kode_cuaca'] ?? 0,
      kondisiCuaca: json['kondisi_cuaca'] ?? 'Tidak Diketahui',
      arahAnginDerajat: json['arah_angin_derajat'] ?? 0,
      arahAngin: json['arah_angin'] ?? 'Tidak Diketahui',
      kecepatanAngin: json['kecepatan_angin'] ?? 'Tidak Diketahui',
      kelembapan: json['kelembapan'] ?? 'Tidak Diketahui',
      jarakPandang: json['jarak_pandang'] ?? 'Tidak Diketahui',
      timeIndex: json['time_index'] ?? 'Tidak Diketahui',
      analysisDate: json['analysis_date'] ?? 'Tidak Diketahui',
      image: json['image'] ?? '',
      utcDatetime: json['utc_datetime'] ?? 'Tidak Diketahui',
    );
  }
}
