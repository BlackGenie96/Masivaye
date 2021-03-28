class ForHireLocation{
  final int id;
  final String driverName;
  final String driverSurname;
  final String driverPhone;
  final double latitude;
  final double longitude;
  final String profileUrl;

  ForHireLocation({this.id, this.driverName, this.driverSurname, this.driverPhone, this.latitude, this.longitude, this.profileUrl});

  factory ForHireLocation.fromJson(Map<String,dynamic> json){
    return ForHireLocation(
        id : json["id"],
        driverName : json["name"],
        driverSurname : json["surname"],
        driverPhone : json["phone"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        profileUrl: json["profileUrl"]
    );
  }
}