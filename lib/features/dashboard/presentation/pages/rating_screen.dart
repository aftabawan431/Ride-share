
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../core/utils/constants/app_url.dart';
import '../../../../core/widgets/custom/continue_button.dart';
import '../../../../core/widgets/custom/custom_app_bar.dart';
import '../../../../core/widgets/custom/custom_form_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/globals/globals.dart';
import '../providers/rating_provider.dart';

class RatingScreen extends StatelessWidget {
 final RatingProvider provider=sl();
   RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: provider,
        child: const RatingScreenContent());
  }
}

class RatingScreenContent extends StatefulWidget {
   const RatingScreenContent({Key? key}) : super(key: key);

  @override
  State<RatingScreenContent> createState() => _RatingScreenContentState();
}

class _RatingScreenContentState extends State<RatingScreenContent> {
  double rating=5;

  final GlobalKey<FormState> formKey=GlobalKey();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RatingProvider ratingProvider=sl();
    ratingProvider.textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:const CustomAppBar(
        title: 'Rating',

      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 100.h,
              ),
              Expanded(
                  child: Stack(

                      clipBehavior:Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 20.h),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(width: double.infinity, height: 50.r),
                              Text(
                               context.read<RatingProvider>().fullName!,
                                style: TextStyle(
                                    fontSize: 18.sp, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                "How was your trip?",
                                style: TextStyle(
                                    fontSize: 22.sp, fontWeight: FontWeight.w900,)
                                ,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Text(
                                "Your feed back will help improve app experience",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                    color: Colors.black26
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Center(
                                child: RatingBar.builder(
                                  initialRating: rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 50.w,
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  onRatingUpdate: (value) {
                                    rating = value;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              CustomTextFormField(
                                controller: context.read<RatingProvider>().textController,
                                hintText: 'Additional comments',
                                // validator: (value){
                                //   if(value!.isEmpty){
                                //     return 'Please enter something';
                                //   }
                                //   return null;
                                // },
                                labelText: '',
                                maxLines: 4,
                                minLines: 4,
                                textInputAction: TextInputAction.done,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              ContinueButton(
                                loadingNotifier: context.read<RatingProvider>().addRatingLoading,
                                  text: 'Submit Review', onPressed: () {


                                    if(!formKey.currentState!.validate()){
                                      return;
                                    }
                                    context.read<RatingProvider>().addRating(rating);
                              })
                            ],
                          ),
                        ),
                      ),

                      Positioned(
                        top: -35.h,
                        left: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            AppUrl.fileBaseUrl+context.read<RatingProvider>().profileImage!
                          ),
                          radius: 50.r,
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
