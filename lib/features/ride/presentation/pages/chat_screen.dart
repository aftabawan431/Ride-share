import 'dart:async';

import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/app_state.dart';
import '../../../../core/utils/globals/globals.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubbule_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, required this.receiverId}) : super(key: key);


  String receiverId;

  final ChatProvider _chatProvider = sl();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _chatProvider,
        child: ChatScreenContent(
          receiverId: receiverId,
        ));
  }
}

class ChatScreenContent extends StatefulWidget {
  ChatScreenContent({Key? key, required this.receiverId}) : super(key: key);
  String receiverId;

  @override
  State<ChatScreenContent> createState() => _ChatScreenContentState();
}

class _ChatScreenContentState extends State<ChatScreenContent> {
  AuthProvider authProvider=sl();
  ChatProvider chatProvider=sl();


  @override
  void initState() {
    super.initState();
    chatProvider.chatScrollController = ScrollController();
    chatProvider.newMessageListener();
    chatProvider.joinRoom();


  }

  @override
  void dispose() {
    super.dispose();
    chatProvider.leaveRoom();
    chatProvider.setOffNewMessageLisntener();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


        body: Consumer<ChatProvider>(
          builder: (context,provider,ch) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 10.h),
                  child: Row(children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        Timer(const Duration(milliseconds: 400), () {
                          AppState appState = sl();
                          appState.moveToBackScreen();
                        });

                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 1,
                              )
                            ]),
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Theme.of(context).primaryColor,
                          size: 25.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w,),

                    // Text(context.read<ChatProvider>().receiver.name,style: TextStyle(
                    //   fontSize: 17.sp,
                    //   color: Theme.of(context).primaryColor
                    // ),)
                  ],),
                ),
                Expanded(
                  child:
                provider.messages.isEmpty?const Center(child:  Text("No messages",style: TextStyle(color: Colors.black87),),):
                  ListView.builder(
                    controller: provider.chatScrollController,
                    reverse: false,
                    itemCount: provider.messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final message=provider.messages[index];
                      return ChatBubbleWidget(chat: message, currentUserId: authProvider.currentUser!.id);



                  },



                  ),
                ),

                MessageBar(

                  onSend: (message) {

                    provider.sendMessage(message);
                  },
                  actions: const[

                  ],
                ),

              ],
            );
          }
        ),
      ),
    );
  }
}


