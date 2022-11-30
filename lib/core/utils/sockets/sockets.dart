import 'dart:convert';

import 'package:flutter_rideshare/core/utils/globals/loading.dart';

import '../background_location/background_locatoin_service.dart';
import '../background_location/location_service_repository.dart';
import '../constants/app_url.dart';
import '../encryption/encryption.dart';
import '../../../features/authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../globals/globals.dart';
import '../globals/snake_bar.dart';

class SocketService {
  static final AuthProvider _authProvider = sl();
  static IO.Socket? socket;
  static init() {
    socket = IO.io(
        "${AppUrl.baseUrl}?userId=${_authProvider.currentUser!.id}&name=${_authProvider.currentUser!.firstName}",
        <String, dynamic>{
          "transports": ["websocket"],
        });

    socket!.onConnect((data) {
      // socket!.id=authProvider.currentUser!.id;
      Logger().v('Connected');


      socket!.on('locationObserver', (data) async {
        Logger().v("Observer");
        AuthProvider authProvider = sl();
        if (_authProvider.currentUser!.selectedUserType == '1') {
          final decodedData = Encryption.decryptJson(jsonDecode(data));
          if (decodedData['observer']) {
            Logger().v(decodedData);
            await BackgroundLocationService.initPlatformState();

            LocationServiceRepository.routeId = decodedData['routeId'];

            await const FlutterSecureStorage()
                .write(key: 'routeId', value: decodedData['routeId']);

            BackgroundLocationService.start(decodedData['routeId']);
            // LocationApi.locationRoomId=decodedData['routeId'];
            // LocationApi.startBackgroundLocationListener();

          } else {
            BackgroundLocationService.stop();
            // LocationApi.stopBackgroundLocationListener();

          }
        } else {
          BackgroundLocationService.stop();
        }
      });
    });

    socket!.onConnectError((data) {
      Logger().v('Connect error');

      // ShowSnackBar.show(data);
    });

    socket!.onError((data) {
      Logger().v('Error');

      // Logger().v(data);
      Loading.dismiss();
      final decoded=jsonDecode(data);
      ShowSnackBar.show(decoded['msg']??'Error occured');
    });

    socket!.on("message", (data) {
      // ShowSnackBar.show(data.toString());
    });
    socket!.onDisconnect((data) {
      socket!.off('locationObserver');
    });
  }

  static close() {
    if (socket != null) {
      if (socket!.connected) {
        socket!.close();
      }

      socket = null;
    }
  }

  static bool hasListener(String event) {
    if (socket == null) {
      return false;
    }
    return socket!.hasListeners(event);
  }

  static removeAllListener() {
    socket!.clearListeners();
  }

  static on(String event, dynamic Function(dynamic) callback) {
    if (!hasListener(event)) {
      socket!.on(event, callback);
    }
  }

  static off(String event) {
    if (socket != null) {
      socket!.off(event);
    }
  }
}
