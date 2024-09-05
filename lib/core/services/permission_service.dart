import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
    ].request();

    // Kontroller yapabilirsiniz, örneğin konum izni verilmediyse uyarı gösterilebilir.
    if (statuses[Permission.location] != PermissionStatus.granted) {
      throw Exception('Location permission not granted');
    }
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isDenied) {
      throw Exception("Location permission denied.");
    }
  }

  // Bildirim izni isteme metodu
  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status.isDenied) {
      throw Exception("Notification permission denied.");
    }
  }
}
