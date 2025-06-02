class ConnectivityService {
  /// Simulasi cek koneksi internet.
  /// Nanti bisa pakai package connectivity_plus.
  static Future<bool> isConnected() async {
    // Simulasi delay cek koneksi.
    await Future.delayed(const Duration(milliseconds: 500));
    // Kembalikan true berarti ada koneksi.
    return true;
  }
}
