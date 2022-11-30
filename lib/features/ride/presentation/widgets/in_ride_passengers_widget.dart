import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rideshare/core/utils/enums/otp_reset_enum.dart';
import 'package:flutter_rideshare/features/authentication/auth_wrapper/presentation/providers/otp_provider.dart';
import 'package:flutter_rideshare/features/ride/data/models/active_ride_model.dart';
import 'package:flutter_rideshare/features/wallet/presentation/manager/wallet_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/router/models/page_action.dart';
import '../../../../core/router/models/page_config.dart';
import '../../../../core/utils/constants/app_assets.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/utils/enums/page_state_enum.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../../core/utils/globals/loading.dart';
import '../../../../core/widgets/bottom_sheets/cancel_reason_bottom_sheet.dart';
import '../../../../core/widgets/custom/continue_button.dart';
import '../../../../core/widgets/custom/dotted_line_painter.dart';
import '../../../drawer_wrapper/schedules_driver/presentation/providers/schedule_provider.dart';
import '../../data/models/chat_receiver_model.dart';
import '../pages/chat_screen.dart';
import '../pages/passenger_ride_screen.dart';
import '../providers/chat_provider.dart';
import '../providers/driver_ride_provider.dart';

class InRidePassenerWidget extends StatelessWidget {
  const InRidePassenerWidget({Key? key, required this.passenger})
      : super(key: key);
  final Passengers passenger;

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverRideProvider>(
      builder: (context, provider, ch) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 7.h),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  spreadRadius: 1.5,
                  blurRadius: 1.5,
                  color: Colors.black12,
                )
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundImage: NetworkImage(AppUrl.fileBaseUrl +
                          passenger.passenger.userId.profileImage),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passenger.passenger.userId.firstName +
                                ' ' +
                                passenger.passenger.userId.lastName,
                            style: TextStyle(fontSize: 18.sp),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                AppAssets.star1Svg,
                                width: 18.sp,
                                color: Colors.orangeAccent,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                getFormattedRating(
                                    passenger.passenger.userId.totalRating,
                                    passenger.passenger.userId.totalRatingCount),
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontSize: 16.sp),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    if (passenger.status != 'completed')
                      Stack(
                        children: [
                          SizedBox(
                            height: 40.r,
                            width: 35.r,
                            child: FloatingActionButton(
                              heroTag: '1',
                              onPressed: _onChatTap,
                              child: Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 23.sp,
                              ),
                              mini: true,
                              backgroundColor: Colors.deepPurpleAccent,
                            ),
                          ),
                          if (passenger.count > 0)
                            CircleAvatar(
                              radius: 8.r,
                              backgroundColor: Colors.redAccent,
                              child: Center(
                                child: Text(
                                  passenger.count.toString(),
                                  style: TextStyle(
                                      fontSize: 7.sp, color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    SizedBox(
                      width: 4.w,
                    ),
                    SizedBox(
                      height: 40.r,
                      width: 35.r,
                      child: FloatingActionButton(
                        heroTag: '2',
                        onPressed:_onCallTap,
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 25.sp,
                        ),
                        mini: true,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    )
                  ],
                ),
                returnRouteInfoWidget(context),
                returnRouteStat(),
                SizedBox(
                  height: 4.h,
                ),
                if (passenger.status == 'arrived' &&
                    passenger.verifyPin != null)
                  Text(
                    passenger.verifyPin.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                SizedBox(
                  height: 4.h,
                ),
                if (passenger.status == 'completed')
                  const Text("Ride completed"),
                if (passenger.status == 'cancelled')
                  Text(
                    "Cancelled",
                    style: TextStyle(color: Colors.red.withOpacity(.8)),
                  ),
                if (passenger.status != 'cancelled')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (passenger.status == 'arrived' ||
                          passenger.status == 'pending' ||
                          passenger.status == 'active')
                        SizedBox(
                          height: 35.h,
                          width: 140.w,
                          child: ContinueButton(
                            backgroundColor: Colors.red.withOpacity(.8),
                            text: 'Cancel',
                            onPressed: ()=>_onCancelTap(context),
                            fontSize: 14.sp,
                          ),
                        ),
                      if (passenger.status != 'completed' &&
                          passenger.status != 'arrived')
                        SizedBox(
                          height: 35.h,
                          width: 140.w,
                          child: ContinueButton(
                              fontSize: 14.sp,
                              text: passenger.status == 'pending'
                                  ? 'On the way'
                                  : passenger.status == 'active'
                                      ? 'Arrived'
                                      : passenger.status == 'arrived'
                                          ? 'Start'
                                          : 'Complete',
                              onPressed:()=>_updateRideStatus(context)),
                        ),
                    ],
                  ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget returnRouteStat(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RideStatWidget(
            title: 'DISTANCE',
            value:
            '${(passenger.passenger.distance / 1000).toStringAsFixed(1)} KM'),
        RideStatWidget(
            title: 'FARE', value: "Rs ${passenger.fare.toInt()}"),
        RideStatWidget(
            title: 'SEATS',
            value: passenger.passenger.bookedSeats.toString()),
      ],
    );
  }
  Widget returnRouteInfoWidget(BuildContext context){
    return Row(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.radio_button_checked,
              color: Theme.of(context).primaryColor,
              size: 20.sp,
            ),
            CustomPaint(
                size: Size(1, 15.h),
                painter: DashedLineVerticalPainter()),
            Icon(
              Icons.location_on,
              color: Theme.of(context).errorColor,
              size: 20.sp,
            ),
          ],
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                passenger.passenger.startPoint.placeName,
                style: TextStyle(fontSize: 13.sp),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                passenger.passenger.endPoint.placeName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
        )
      ],
    );
  }
_onCallTap()async{
  String url = 'tel:' +
      passenger.passenger.userId.mobile.toString();
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}

  _onChatTap() {
    DriverRideProvider provider = sl();
    ChatProvider chatProvider = sl();
    chatProvider.receiver = ChatReceiverModel(
        id: passenger.passenger.userId.id,
        profileImage: passenger.passenger.userId.profileImage,
        name: passenger.passenger.userId.getFullName());
    provider.setCountToZero(passenger.passenger.userId.id);
    AppState appState = sl();
    appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: PageConfigs.chatPageConfig,
        widget: ChatScreen(
          receiverId: passenger.passenger.userId.id,
        ));
  }

  _onCancelTap(BuildContext context)async{

    List<String> reasons = passenger.status=='arrived'?[

      "Passenger did'nt arrive"
    ]: [
      "Wrong schedule time",
      "Other"
    ];

    CancelReasonBottomSheet
    bottomSheet =
    CancelReasonBottomSheet(
        context:
        navigatorKeyGlobal
            .currentContext!,
        reasons: reasons,
        onPressed: (reason) {
          print(reason);

          Loading.show();
          DriverRideProvider provider = sl();
          provider.cancelInRidePassengerRequestByDriver(
              passenger.passenger.id,reason);
          Navigator.of(context)
              .pop();
        });
    bottomSheet.show();




  }
  _updateRideStatus(BuildContext context)async{
    DriverRideProvider provider = sl();
    if (passenger.status == 'pending') {
      provider.driverOnTheWay(
          scheduleId: passenger.passenger.id);
    } else if (passenger.status == 'active') {
      provider.driverArrived(
          scheduleId: passenger.passenger.id);
    } else if (passenger.status == 'arrived') {
      provider.startRide(
          scheduleId: passenger.passenger.id);
    } else if (passenger.status == 'inprogress') {
      OtpProvider otpProvider=sl();
      otpProvider.otpResetType=OtpResetType.completeRide;
      otpProvider.canResend=false;
      WalletProvider walletProvider=sl();
      walletProvider.compeletePassengerId=passenger.passenger.userId.id;
      walletProvider.completePassengerMobile=passenger.passenger.userId.mobile.toString();
      walletProvider.completeScheduleId=passenger.passenger.id;
      walletProvider.sendCompleteRideOtp(passenger.passenger.id);




    }
  }
}
