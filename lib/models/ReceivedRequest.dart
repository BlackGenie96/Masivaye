class ReceivedRequest{
  final int requestId;
  final int userId;
  final String username;
  final String usersurname;
  final String phoneNum;
  final String destinationName;
  final String distance;
  final String price;
  final int quantity;
  final String paymentMethod;
  final double sourceLatitude;
  final double sourceLongitude;
  final double destLatitude;
  final double destLongitude;
  final double userLatitude;
  final double userLongitude;

  ReceivedRequest({
    this.requestId,
    this.userId,
    this.username,
    this.usersurname,
    this.phoneNum,
    this.destinationName,
    this.distance,
    this.price,
    this.quantity,
    this.paymentMethod,
    this.sourceLatitude,
    this.sourceLongitude,
    this.destLatitude,
    this.destLongitude,
    this.userLatitude,
    this.userLongitude
  });

  factory ReceivedRequest.fromJson(Map<String,dynamic> json){
    return ReceivedRequest(
      requestId: int.parse(json["requestId"]),
      userId : int.parse(json["userId"]),
      username: json["username"],
      usersurname: json["userSurname"],
      phoneNum : json["phoneNum"],
      destinationName: json["destinationName"],
      distance: json["distance"].toString(),
      price : json["price"].toString(),
      quantity: int.parse(json["quantity"]),
      paymentMethod: json["paymentMethod"],
      sourceLatitude: double.parse(json["sourceLatitude"]),
      sourceLongitude: double.parse(json["sourceLongitude"]),
      destLatitude : double.parse(json["destLatitude"]),
      destLongitude : double.parse(json["destLongitude"]),
      userLatitude : double.parse(json["userLatitude"]),
      userLongitude : double.parse(json["userLongitude"])
    );
  }
}