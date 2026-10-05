import 'dart:math' as math;

const double _earthRadiusKm = 6371;

/// Returns the great-circle distance between two coordinates in kilometers.
double calculateDistanceKm(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  final latitudeDelta = _degreesToRadians(lat2 - lat1);
  final longitudeDelta = _degreesToRadians(lon2 - lon1);
  final firstLatitude = _degreesToRadians(lat1);
  final secondLatitude = _degreesToRadians(lat2);

  final haversine = math.pow(math.sin(latitudeDelta / 2), 2) +
      math.cos(firstLatitude) *
          math.cos(secondLatitude) *
          math.pow(math.sin(longitudeDelta / 2), 2);
  final angularDistance =
      2 * math.atan2(math.sqrt(haversine), math.sqrt(1 - haversine));

  return _earthRadiusKm * angularDistance;
}

double _degreesToRadians(double degrees) => degrees * math.pi / 180;
