class TransactionItem {
  int requestId;
  int userId;
  String username;
  String surname;
  String phone;
  String profileUrl;

  int driverId;
  String driverName;
  String driverSurname;
  String driverPhone;
  String driverProfileUrl;

   String destinationName;
   String distance;
   String price;
   String paymentMethod;
   String status;
   double sourceLatitude;
   double sourceLongitude;
   double destLatitude;
   double destLongitude;
   int rating;
   int quantity;

  int carId;
  String carName;
  String carPlate;
  String carProfileUrl;

  TransactionItem({
    this.requestId,
    this.userId,
    this.username,
    this.surname,
    this.phone,
    this.profileUrl,
    this.driverId,
    this.driverName,
    this.driverSurname,
    this.driverPhone,
    this.driverProfileUrl,
    this.destinationName,
    this.distance,
    this.price,
    this.paymentMethod,
    this.status,
    this.sourceLatitude,
    this.sourceLongitude,
    this.destLatitude,
    this.destLongitude,
    this.rating,
    this.carId,
    this.carName,
    this.carPlate,
    this.carProfileUrl,
    this.quantity
  });

  factory TransactionItem.fromJson(Map json){
    TransactionItem item = new TransactionItem(
        requestId: int.parse(json["requestId"]),
        userId: int.parse(json["userId"]),
        username: json["username"],
        surname: json["usersurname"],
        phone: json["userphone"],
        profileUrl: json["profileUrl"],
        driverId: int.parse(json["driverId"]),
        driverName: json["driverName"],
        driverSurname: json["driverSurname"],
        driverPhone: json["driverPhone"],
        driverProfileUrl: json["driveProfileUrl"],
        destinationName: json["destinationName"],
        distance: json["distance"].toString(),
        price: json["price"].toString(),
        paymentMethod: json["paymentMethod"],
        status: json["requestStatus"],
        sourceLatitude: double.parse(json["sourceLatitude"]),
        sourceLongitude: double.parse(json["sourceLongitude"]),
        destLatitude: double.parse(json["destLatitude"]),
        destLongitude: double.parse(json["destLongitude"]),
        rating: 3,//int.parse(json["rating"]),
        carId: int.parse(json["carId"]),
        carName : json["carName"],
        carPlate: json["carPlate"],
        carProfileUrl: json["carProfileUrl"],
        quantity: int.parse(json["quantity"])
    );
    return item;
  }
}