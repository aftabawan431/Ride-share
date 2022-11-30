import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/snake_bar.dart';
import '../../../../core/utils/location/dashboard_helper.dart';
import '../../data/model/dashboard_data_response_model.dart';
import '../providers/driver_dashboard_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/utils/location/location_api.dart';

class DashboardMapWidget extends StatelessWidget {
  const DashboardMapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


   return Selector<DashboardProvider,
        GetDashboardDataResponseModel>(
        selector: (_, provider) =>
        provider.getDashboardDataResponseModel!,
        builder: (context, data, ch) {
          return Container(
            color: Colors.white,
            height:
            data.data.upcoming.isEmpty ? 270.h : 180.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Around you',
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                    child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(5),
                        child:  GoogleMap(
                            zoomControlsEnabled: false,
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,

                            onMapCreated: (controller)async{
                              try{
                                if(userCurrentLocation==null){
                                  final position = await LocationApi.determinePosition();
                                  userCurrentLocation = position;
                                  DashBoardHelper dashBoardHelper=sl();
                                  DashboardProvider driverDashboardProvider=sl();
                                  driverDashboardProvider.currentLocation =
                                  await dashBoardHelper.searchCoordinateAddress(userCurrentLocation!);

                                }
                                controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(userCurrentLocation!.latitude, userCurrentLocation!.longitude),
                                    zoom: 15)));
                              }catch(e){
                                ShowSnackBar.show(e.toString());

                              }

                            },


                            initialCameraPosition: const CameraPosition(
                              target: LatLng(33.6844, 73.0479),
                              zoom: 16,
                            )))),
              ],
            ),
          );
        });

  }
}
