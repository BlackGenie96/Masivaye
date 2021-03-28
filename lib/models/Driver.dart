class Driver{
  final int id;
  final String driverName;
  final String driverSurname;
  final int driverIdNum;
  final String driverPhone;
  final bool isDriver;
  final String driverProfileUrl;

  Driver({this.id, this.driverName, this.driverSurname, this.driverIdNum, this.driverPhone, this.driverProfileUrl, this.isDriver});

  factory Driver.fromJson(Map<String,dynamic> json){
    return Driver(
      id: json['id'],
      driverName : json['firstName'],
      driverSurname : json['lastName'],
      driverIdNum: int.parse(json['idNum']),
      driverPhone : json['phoneNum'],
      driverProfileUrl : json['profileUrl'],
      isDriver : true
    );
  }
}