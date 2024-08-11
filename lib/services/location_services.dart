import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  LocationService();

  Future<LocationData> getCurrentLocation() async {
    await _checkPermissions(); // İzinleri kontrol et
    return await location.getLocation(); // Konum bilgilerini al
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Konum hizmetlerinin etkin olup olmadığını kontrol et
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Konum hizmetleri etkin değilse hata fırlat
        throw Exception('Konum hizmetleri etkin değil.');
      }
    }

    // Konum izinlerini kontrol et
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Kullanıcı konum iznini reddettiyse hata fırlat
        throw Exception('Konum izni reddedildi.');
      }
    }

    if (permissionGranted == PermissionStatus.deniedForever) {
      // Kullanıcı konum iznini kalıcı olarak reddettiyse hata fırlat
      throw Exception('Konum izni kalıcı olarak reddedildi. Ayarlardan izin verilmesi gerekiyor.');
    }
  }
}
