// ignore_for_file: prefer_conditional_assignment

import 'dart:async';
import 'package:background_locator_2/location_dto.dart';
import '../constants/app_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'package:dio/dio.dart';

class LocationServiceRepository {
  
  static  String? routeId;
  static final LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';


  Future<void> init(Map<dynamic, dynamic> params) async {
    routeId=params['routeId'];
    LocationServiceRepository.routeId=routeId;
  }

  Future<void> dispose() async {

    // await setLogLabel("end");
    // final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    // send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {

    if(routeId==null){
      routeId=(await const FlutterSecureStorage().read(key: 'routeId'))!;
    }
    Dio().post(AppUrl.baseUrl+  "api/route/livelocation",data: {
      "location": {
        "latitude": locationDto.latitude.toString(),
        "longitude": locationDto.longitude.toString()
      },
      "routeId": routeId
    });
    //write this location in logs

    // SocketService.emit();

    // try{
    //   print("Sending request");
    //   await Dio().get("http://192.168.4.156:3002/api/test");
    //
    // }catch(e){
    //
    // }

    // final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    // Logger().v("Sending data to the port");
    // send?.send(locationDto);
    // _count++;
  }
}
