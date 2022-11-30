import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../core/utils/constants/socket_point.dart';
import '../../../../core/utils/encryption/encryption.dart';
import '../../../../core/utils/sockets/sockets.dart';
import '../../../authentication/auth_wrapper/presentation/providers/auth_provider.dart';
import '../../data/models/chat_receiver_model.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:logger/logger.dart';

import '../../../../core/utils/globals/globals.dart';
import '../../data/models/chat_message_model.dart';

class ChatProvider extends ChangeNotifier {
  //value listners

  ValueNotifier<bool> getMessagesLoading = ValueNotifier(false);
  //properties
  late ScrollController chatScrollController;

  late ChatReceiverModel receiver;
  List<ChatMessageModel> messages = [

  ];

  AuthProvider authProvider = sl();

  void scrollToBottom() {
    final bottomOffset = chatScrollController.position.maxScrollExtent+200;
    chatScrollController.animateTo(
      bottomOffset,
      duration:const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  //setters

  setChatMessages(List<ChatMessageModel> values) {
    messages = values;
    notifyListeners();
  }

  addChatMessage(ChatMessageModel value) {
    messages.add( value);
    notifyListeners();
  }

  //sockets
  //to join room based on idz, it will return the previous chats
  void joinRoom() {
    String receiverId = receiver.id;
    String senderId = authProvider.currentUser!.id;
    final data = {"receiver": receiverId, "sender": senderId};
    final encodedData = jsonEncode(Encryption.encryptObject(jsonEncode(data)));
    SocketService.socket!.emitWithAck(
        SocketPoint.joinRoomAndGetMessagesEmitter, encodedData, ack: (data) {
          Logger().v(data);
          final decryptedData=Encryption.decryptJson(data);
          messages.clear();
          if(decryptedData['chat']['chat'].isEmpty){
            messages=[];
          }else{
            messages = decryptedData['chat']['chat'].map<ChatMessageModel>((e) => ChatMessageModel.fromJson(e)).toList().toList();

          }
      notifyListeners();
      scrollToBottom();
    });
  }

  // to leave user from room when he will move back from chat screen
  void leaveRoom() {
    String receiverId = receiver.id;
    String senderId = authProvider.currentUser!.id;
    final data = {"receiver": receiverId, "sender": senderId};
    final encodedData = Encryption.encryptObject(jsonEncode(data));
    SocketService.socket!.emit(SocketPoint.leaveRoomEmitter, jsonEncode(encodedData));
  }

  void sendMessage(String messageText) {
    String receiverId = receiver.id;
    String senderId = authProvider.currentUser!.id;
    String name = authProvider.currentUser!.getFullName();
    String profileImage = authProvider.currentUser!.profileImage;
    String dateTime = DateTime.now().toLocal().toString();

    final message = ChatMessageModel(
        userId: senderId,
        name: name,
        profileImage: profileImage,
        message: messageText,
        receiver: receiverId,
        date: dateTime);
    final encodedMessage = Encryption.encryptObject(jsonEncode(message.toJson()));


    SocketService.socket!.emit(SocketPoint.sendMessageEmitter, jsonEncode(encodedMessage));
  }

  //to listen for new messages updates
  newMessageListener() {
    SocketService.on(SocketPoint.newMessageListener, (data) {
      Logger().v(data);
      final decodeMessage=Encryption.decryptJson(jsonDecode(data));
      final newMessage = ChatMessageModel.fromJson(decodeMessage);
      AuthProvider authProvider=sl();
      if(newMessage.userId!=authProvider.currentUser!.id){
        FlutterRingtonePlayer.playNotification();
      }
      addChatMessage(newMessage);
      scrollToBottom();
    });
  }

  setOffNewMessageLisntener() {
    SocketService.socket!.off(SocketPoint.newMessageListener);
  }
}
