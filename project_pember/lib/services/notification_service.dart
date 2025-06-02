class NotificationService {
  /// Simulasi menampilkan notifikasi.
  /// Nanti bisa diganti dengan flutter_local_notifications, dll.
  static void showNotification({required String title, required String body}) {
    // Contoh sederhana, print ke console.
    print('Notification: $title - $body');
  }
}
