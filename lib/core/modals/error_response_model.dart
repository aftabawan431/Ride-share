import 'package:equatable/equatable.dart';

class ErrorResponseModel extends Equatable {
  const ErrorResponseModel({
    required this.msg
  });


  final String? msg;

  factory ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    return ErrorResponseModel(
      msg: json['msg'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;

    return _data;
  }

  @override
  List<Object?> get props => [msg];
}

class SocketAwkResponseModel extends Equatable {
  const SocketAwkResponseModel({
    required this.msg,
    required this.status
  });


  final String msg;
  final bool status;

  factory SocketAwkResponseModel.fromJson(Map<String, dynamic> json) {
    return SocketAwkResponseModel(
      msg: json['msg'],
      status: json['status']??false,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['status'] = status;

    return _data;
  }

  @override
  List<Object?> get props => [msg,status];
}

