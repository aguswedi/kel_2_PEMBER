class LocationService {
  /// Simulasi mendapatkan lokasi user.
  /// Nanti bisa diganti pakai package location/geolocator.
  static Future<String> getCurrentLocation() async {
    // Simulasi delay request lokasi.
    await Future.delayed(const Duration(seconds: 1));
    // Kembalikan string lokasi dummy.
    return 'Latitude: -6.200000, Longitude: 106.816666';
  }
}
