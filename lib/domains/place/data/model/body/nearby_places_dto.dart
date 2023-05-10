class NearbyPlacesDto {
  final String? keyword;
  final String? latitude;
  final String? longitude;
  final String? radius;
  final String? type;
  final String? apiKey;

  NearbyPlacesDto({
    this.keyword,
    this.latitude,
    this.longitude,
    this.radius,
    this.type,
    this.apiKey,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'type': type,
      'apiKey': apiKey,
    };
  }
}
