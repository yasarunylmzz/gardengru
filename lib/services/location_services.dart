import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  LocationService();

  Future<LocationData> getCurrentLocation() async {
    await _checkPermissions(); // İzinleri kontrol et
    return await location.getLocation(); // Konum bilgilerini al
  }

  Future<void> _checkPermissions() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Konum hizmetlerinin etkin olup olmadığını kontrol et
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Konum hizmetleri etkin değilse hata fırlat
        throw Exception('Konum hizmetleri etkin değil.');
      }
    }

    // Konum izinlerini kontrol et
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Kullanıcı konum iznini reddettiyse hata fırlat
        throw Exception('Konum izni reddedildi.');
      }
    }

    if (_permissionGranted == PermissionStatus.deniedForever) {
      // Kullanıcı konum iznini kalıcı olarak reddettiyse hata fırlat
      throw Exception('Konum izni kalıcı olarak reddedildi. Ayarlardan izin verilmesi gerekiyor.');
    }
  }
}
