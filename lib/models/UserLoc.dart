class UserLocation {
  final int id;
  final String userName;
  final String userSurname;
  final String userPhone;
  final double latitude;
  final double longitude;
  final String profileUrl;

  UserLocation({this.id, this.userName, this.userSurname, this.userPhone, this.latitude, this.longitude, this.profileUrl});

  factory UserLocation.fromJson(Map<String,dynamic> json){
    return UserLocation(
      id : json["id"],
      userName: json["name"],
      userSurname: json["surname"],
      userPhone : json["phone"],
      latitude : json["latitude"],
      longitude: json["longitude"],
      profileUrl : json["profileUrl"]
    );
  }
}