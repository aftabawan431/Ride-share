class AutoGenerate {
  AutoGenerate({
    required this.msg,
    required this.data,
  });
  late final String msg;
  late final Data data;
  
  AutoGenerate.fromJson(Map<String, dynamic> json){
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this._id,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.profileImage,
    required this.token,
    required this.fcmToken,
    required this.otpExpiry,
    required this.registered,
    required this.pets,
    required this.createdAt,
    required this.updatedAt,
    required this._V,
    required this.selectedPet,
  });
  late final String _id;
  late final String firstName;
  late final String lastName;
  late final String gender;
  late final String phone;
  late final String profileImage;
  late final String token;
  late final String fcmToken;
  late final String otpExpiry;
  late final bool registered;
  late final List<Pets> pets;
  late final String createdAt;
  late final String updatedAt;
  late final int _V;
  late final String selectedPet;
  
  Data.fromJson(Map<String, dynamic> json){
    _id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    token = json['token'];
    fcmToken = json['fcmToken'];
    otpExpiry = json['otpExpiry'];
    registered = json['registered'];
    pets = List.from(json['pets']).map((e)=>Pets.fromJson(e)).toList();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    _V = json['__v'];
    selectedPet = json['selectedPet'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = _id;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    _data['gender'] = gender;
    _data['phone'] = phone;
    _data['profileImage'] = profileImage;
    _data['token'] = token;
    _data['fcmToken'] = fcmToken;
    _data['otpExpiry'] = otpExpiry;
    _data['registered'] = registered;
    _data['pets'] = pets.map((e)=>e.toJson()).toList();
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['__v'] = _V;
    _data['selectedPet'] = selectedPet;
    return _data;
  }
}

class Pets {
  Pets({
    required this._id,
    required this.name,
    required this.breed,
    required this.gender,
    required this.petType,
    required this.location,
    required this.story,
    required this.dob,
    required this.date,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this._V,
  });
  late final String _id;
  late final String name;
  late final String breed;
  late final String gender;
  late final String petType;
  late final String location;
  late final String story;
  late final String dob;
  late final String date;
  late final String photo;
  late final String createdAt;
  late final String updatedAt;
  late final int _V;
  
  Pets.fromJson(Map<String, dynamic> json){
    _id = json['_id'];
    name = json['name'];
    breed = json['breed'];
    gender = json['gender'];
    petType = json['petType'];
    location = json['location'];
    story = json['story'];
    dob = json['dob'];
    date = json['date'];
    photo = json['photo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    _V = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = _id;
    _data['name'] = name;
    _data['breed'] = breed;
    _data['gender'] = gender;
    _data['petType'] = petType;
    _data['location'] = location;
    _data['story'] = story;
    _data['dob'] = dob;
    _data['date'] = date;
    _data['photo'] = photo;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    _data['__v'] = _V;
    return _data;
  }
}