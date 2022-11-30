import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import '../../data/models/chat_message_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatBubbleWidget extends StatelessWidget {
  ChatBubbleWidget({Key? key,required this.chat,required this.currentUserId}) : super(key: key);
  ChatMessageModel chat;
  String currentUserId;



  @override
  Widget build(BuildContext context) {
    bool isSender=chat.userId==currentUserId;
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: isSender?CrossAxisAlignment.end:CrossAxisAlignment.start,

        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
            margin: EdgeInsets.only(
              left: 20.w,
              right: 20.w
            ),
            decoration: BoxDecoration(
              color: const Color(0x558AD3D5),
              borderRadius: BorderRadius.circular(5),

            ),
            child: Text(DateFormat('hh:mm a').format(DateTime.parse(chat.date).toLocal()),style: TextStyle(
              fontSize: 13.sp
            ),),
          ),

          BubbleSpecialThree(
            text: chat.message,
            color:isSender? const Color(0xFF1B97F3):const Color(0xFFE8E8EE),
            tail: true,
            textStyle: TextStyle(
                color:isSender? Colors.white:null,
                fontSize: 16
            ),
            isSender: isSender,
          ),
        ],
      ),
    );
  }
}
