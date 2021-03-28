class UserAuth{
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNum;
  final String profileImageUrl;
  final bool isDriver;

  UserAuth({this.id, this.firstName, this.lastName, this.email, this.phoneNum, this.profileImageUrl, this.isDriver});

  factory UserAuth.fromJson(Map<String,dynamic> json){
    return UserAuth(
      id : json["id"],
      firstName : json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      phoneNum : json["phoneNum"],
      profileImageUrl: json["profileUrl"],
      isDriver : json["driver"]
    );
  }
}