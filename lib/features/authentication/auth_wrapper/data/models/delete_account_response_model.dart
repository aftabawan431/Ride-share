
class DeleteAccountResponseModel {
  DeleteAccountResponseModel({
    required this.msg,
  });
  late final String msg;

  DeleteAccountResponseModel.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    return _data;
  }
}