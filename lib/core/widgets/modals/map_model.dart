import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../features/dashboard/presentation/providers/driver_dashboard_provider.dart';
import '../../../features/drawer_wrapper/schedules_driver/data/models/get_drivers_list_response_model.dart';
import '../../utils/globals/globals.dart';

class MapModel {
  final BuildContext context;
  List<PointLatLng> points;
  BoundsNe boundsNe;
  BoundsSw boundsSw;

  LatLng start;
  LatLng end;


  MapModel(this.context,
      {required this.points,
      required this.start,
      required this.end,
      required this.boundsSw,
      required this.boundsNe});
  DashboardProvider provider = sl();

  show() {
    showDialog(
        context: context,
        // barrierDismissible: false,
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: provider,
            child: Builder(builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GoogleMap(
                              zoomControlsEnabled: false,
                        zoomGesturesEnabled: false,
                      scrollGesturesEnabled: false,

                        polylines: {
                            Polyline(
                                polylineId: const PolylineId('1'),
                                points: points
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList(),
                                color: Colors.purple,
                                width: 3),
                        },
                        markers: {
                            Marker(
                              markerId: const MarkerId('1'),
                              position: LatLng(
                                start.latitude,
                                start.longitude,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueGreen),
                            ),
                            Marker(
                              markerId: const MarkerId('2'),
                              position: LatLng(
                                end.latitude,
                                end.longitude,
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                            ),
                        },
                              onMapCreated: (controller){
                            controller.animateCamera((CameraUpdate.newLatLngBounds(
                                LatLngBounds(southwest: LatLng(boundsSw.latitude,boundsSw.longitude), northeast:LatLng(boundsNe.latitude,boundsNe.longitude),),
                                40)));
                              },
                        initialCameraPosition: CameraPosition(
                            target: LatLng(provider.currentLocation!.latitude,
                                provider.currentLocation!.longitude),
                            zoom: 15,
                        ),
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                      ),
                          ))
                    ],
                  ),
                ),
              );
            }),
          );
        });
  }
}
