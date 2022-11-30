

class
UserLocation {
  String placeFormattedAddress;
  String placeName;
  String placeId;
  double latitude;
  double longitude;
  double heading;
  UserLocation(
      {required this.longitude,
      required this.latitude,
      required this.placeFormattedAddress,
      required this.placeId,
      required this.placeName,
      required this.heading
      });
}
