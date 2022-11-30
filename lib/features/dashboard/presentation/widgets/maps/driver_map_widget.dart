import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../providers/driver_dashboard_provider.dart';

class DriverMapWidget extends StatefulWidget {
  const DriverMapWidget({Key? key}) : super(key: key);

  @override
  State<DriverMapWidget> createState() => _DriverMapWidgetState();
}

class _DriverMapWidgetState extends State<DriverMapWidget> {
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(builder: (context, provider, ch) {
      
      return Padding(
        padding: EdgeInsets.only(bottom: provider.defaultHeight),
        child: GoogleMap(
          onMapCreated: provider.onMapCreated,
          // myLocationButtonEnabled: true,
          markers: provider.markers,
          polylines: provider.polylines,
          zoomControlsEnabled: false,

          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
              target: LatLng(
                  currentPosition == null ? 33.6844 : currentPosition!.latitude,
                  currentPosition == null
                      ? 73.0479
                      : currentPosition!.longitude),
              zoom: 15,
              tilt: provider.defaultMapTilt,
              bearing: provider.defaultBering),
          circles: provider.circles,
          compassEnabled: false,
        ),
      );
    });
  }
}
