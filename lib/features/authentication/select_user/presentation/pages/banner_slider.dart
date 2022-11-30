import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/utils/constants/app_url.dart';
import '../../../../dashboard/data/model/dashboard_data_response_model.dart';
import '../../../../dashboard/presentation/providers/driver_dashboard_provider.dart';

class BannerSlider extends StatelessWidget {
  const BannerSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (context.read<DashboardViewModel>().promotionList == null) {
    //   Container(
    //     height: 140.h,
    //     width: double.infinity,
    //     decoration: BoxDecoration(
    //       color: Colors.grey,
    //       borderRadius: BorderRadius.circular(12.r),
    //     ),
    //   );
    // }

    return Selector<DashboardProvider,GetDashboardDataResponseModel>(
      selector: (_,provider)=>provider.getDashboardDataResponseModel!,
      builder: (context,data,ch) {
        if(data.data.ads.isEmpty){
          return const SizedBox.shrink();
        }

        return CarouselSlider.builder(
          itemCount: data.data.ads.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final ad=data.data.ads[index];
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xff4CE5B1).withOpacity(.4),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(

                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [

                          Text(ad.title,style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold
                          ),),
                      SizedBox(height: 6.h,),
                      GestureDetector(
                        onTap: ()async{
                          Logger().v(ad.redirectUrl);
                          final uri = Uri.parse(ad.redirectUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                          }
                        },
                        child: Text(ad.buttonText,style: TextStyle(
                          fontSize: 13.sp,

                        ),),
                      )


                      ],),
                    )
                  ),
                  SizedBox(
                    width: 160.w,
                    height: double.infinity,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(AppUrl.fileBaseUrl+ad.imageUrl,fit: BoxFit.cover,)),
                  )
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 160.h,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ),
        );
      }
    );
  }
}
