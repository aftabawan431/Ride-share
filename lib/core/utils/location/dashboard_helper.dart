// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../features/dashboard/data/model/UserLocation.dart';
import '../globals/globals.dart';

class DashBoardHelper {
  Dio dio;
  DashBoardHelper(this.dio);

  /// To get address of user based on [LatLng]
  Future<UserLocation> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String st1, st2;
    String url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    var response = await dio.get(url);
    if (response != 'Failed') {
      // placeAddress = response['results'][0]['formatted_address'];

      st1 = response.data['results'][0]['address_components'][0]['long_name'];
      st2 = response.data['results'][0]['address_components'][1]['long_name'];
      // st4 = response['results'][0]['address_components'][5]['long_name'];
      placeAddress = st1 + ", " + st2;
      // + ", " + st3 + ", " + st4;

      return UserLocation(
          longitude: position.longitude,
          latitude: position.latitude,
          heading: position.heading,
          placeFormattedAddress: placeAddress,
          placeId: response.data['results'][0]['place_id'],
          placeName: '');
    } else {
      return Future.error('Error getting address');
    }
  }

  /// To get place address from placeId, PlaceId is received from places API
  Future<UserLocation?> getPlaceAddressDetails(String placeId) async {
    String placeDetailsUrl =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey';
    var res = await dio.get(placeDetailsUrl);

    if (res == 'Failed') {
      return null;
    } else {
      if (res.data['status'] == 'OK') {
        UserLocation userLocation = UserLocation(
            heading: 0,
            longitude: res.data['result']['geometry']['location']['lng'],
            latitude: res.data['result']['geometry']['location']['lat'],
            placeFormattedAddress: res.data['result']['name'],
            placeId: placeId,
            placeName: res.data['result']['name']);
        return userLocation;
      }else{
        return null;
      }
    }
  }

  Future<Uint8List> makeCustomMarker(String path, {int width = 100}) async {
    final Uint8List customMarker = await _getBytesFromAsset(
        path: path, //paste the custom image path
        width: width // size of custom image as marker
        );
    return customMarker;
  }

  Future<Uint8List> _getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  /// To get the polyline directions [GetDirectionModel]
  Future<GetDirectionModel> getDirection(
      LatLng origin, LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey';
    final result = await dio.get(url);
    var direction = GetDirectionModel(
        bounds_ne: getLat(result.data['routes'][0]['bounds']['northeast']),
        bounds_sw: getLat(result.data['routes'][0]['bounds']['southwest']),
        endLocation:
            getLat(result.data['routes'][0]['legs'][0]['end_location']),
        polyline: result.data['routes'][0]['overview_polyline']['points'],
        polylineDecoded: PolylinePoints().decodePolyline(
            result.data['routes'][0]['overview_polyline']['points']),
        startLocation:
            getLat(result.data['routes'][0]['legs'][0]['start_location']),
        duration: result.data['routes'][0]['legs'][0]['duration']['value'],
        distance: result.data['routes'][0]['legs'][0]['distance']['value']);
    return direction;
  }
}

LatLng getLat(Map value) {
  return LatLng(value['lat'], value['lng']);
}

class GetDirectionModel {
  late final LatLng bounds_ne;
  late final LatLng bounds_sw;
  late final LatLng startLocation;
  late final LatLng endLocation;
  late final String polyline;
  late final int duration;
  late final int distance;
  late final List<PointLatLng> polylineDecoded;

  GetDirectionModel(
      {required this.bounds_ne,
      required this.bounds_sw,
      required this.endLocation,
      required this.polyline,
      required this.polylineDecoded,
      required this.distance,
      required this.duration,
      required this.startLocation});
}
