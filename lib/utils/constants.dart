/// Menyimpan nilai konstan aplikasi
/// Agar tidak terjadi pengulangan kode (best practice)
library;

class ApiConstants {
  // Base URL MockAPI
  static const String baseUrl =
      'https://695ea9d82556fd22f6791091.mockapi.io';

  // Endpoint schedules
  static const String schedules = '$baseUrl/schedules';
}

class AppConstants {
  static const String appName = 'Planno';
}
