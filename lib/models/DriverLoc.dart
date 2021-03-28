class DriverLocation{
  final int id;
  final String driverName;
  final String driverSurname;
  final String driverPhone;
  final double latitude;
  final double longitude;
  final String profileUrl;
  final String carProfileUrl;
  final String carModel;
  final int carId;
  final String seats;
  final double rating;

  DriverLocation({
    this.id,
    this.driverName,
    this.driverSurname,
    this.driverPhone,
    this.latitude,
    this.longitude,
    this.profileUrl,
    this.carId,
    this.carModel,
    this.carProfileUrl,
    this.seats,
    this.rating,
  });

  factory DriverLocation.fromJson(Map<String,dynamic> json){
    return DriverLocation(
      id : int.parse(json["driver_id"]),
      driverName : json["firstName"],
      driverSurname : json["lastName"],
      driverPhone : json["phoneNum"],
      latitude: double.parse(json["latitude"]),
      longitude: double.parse(json["longitude"]),
      profileUrl: json["profileUrl"],
      carId: int.parse(json["carId"]),
      carModel : json["carModel"],
      carProfileUrl: json["carProfileUrl"],
      seats: json["seats"],
      rating: 3//json["rating"]
    );
  }
}