class UserModel{
  String? name, email, gender, imageUrl, userUid;

  UserModel({this.name, this.email, this.gender, this.imageUrl, this.userUid});


  ///sending data to db
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'email': email,
      'gender': gender,
      'imageUrl': imageUrl,
      'uid': userUid
    };
  }

  ///receiving data from db

  factory UserModel.fromMap(map){
    return UserModel(
      name: map['name'],
      email: map['email'],
      gender: map['gender'],
      imageUrl: map['imageUrl'],
      userUid: map['uid']
    );
  }
}

