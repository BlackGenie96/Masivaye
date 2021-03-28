import 'package:masivaye/exceptions/exceptions.dart';
import 'package:masivaye/models/models.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

abstract class DriverRegisterServiceAbstract{
  //TODO: implement facebook and google registration
  Future<Driver> registerDriver(String firstName, String lastName, String idNum, String phoneNum, String password);
  Future uploadDriverProfile(File profileImage, String carName, String numberPlate, String seats, File carImage);
}

class DriverRegisterService extends DriverRegisterServiceAbstract{

  SharedPreferences prefs;
  var server = "http://192.168.43.56";

  @override
  Future<Driver> registerDriver(String firstName, String lastName, String idNum, String phoneNum, String password) async{
    prefs = await SharedPreferences.getInstance();

    final url = server+'/masivaye/driver_register.php';
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      'first_name' : firstName,
      'last_name' : lastName,
      'id_number' : idNum,
      'phone_number' : phoneNum,
      'password' : password
    };

    print(json.encode(data));
    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle response from server.

    try{
      if(response.statusCode == 200){
        print(json.decode(response.body));

        final res = json.decode(response.body);
        Driver driver = Driver.fromJson(res);

        saveToPreferences(driver.id, driver.driverName, driver.driverSurname, driver.driverIdNum, driver.driverPhone);
        print(driver);

        return driver;
      }else{
        throw AuthenticationException(message: 'Error from API driver registration.');
      }
    }catch(e){
      print(e);
    }
  }

  void saveToPreferences(int id, String name, String surname, int Id, String phone) async{
    prefs = await SharedPreferences.getInstance();

    prefs.setBool('driverLogged', true);
    prefs.setInt('driverId', id);
    prefs.setString('driverFirstName', name);
    prefs.setString('driverLastName', surname);
    prefs.setInt('driverIdNum',Id);
    prefs.setString('driverPhoneNum', phone);

  }

  Future uploadDriverProfile(File profileImage, String carName, String numberPlate, String seats, File carImage) async{
    prefs = await SharedPreferences.getInstance();
    var profileExt = path.extension(profileImage.path);
    var carExt = path.extension(carImage.path);
    var id = prefs.getInt('driverId');

    final url = server+'/masivaye/upload_driver_profile.php';
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'id' : id,
      'profile_image' : base64Encode(profileImage.readAsBytesSync()),
      'profile_ext' : profileExt,
      'car_name' : carName,
      'number_plate' : numberPlate,
      'car_image' : base64Encode(carImage.readAsBytesSync()),
      'car_ext' : carExt,
      'seats' : seats
    };


    http.Response response = await http.post(
      url,
      headers : headers,
      body: json.encode(data)
    );

    //handle response from json
    print(response.body);
    if(response.statusCode == 200){
      Map res = json.decode(response.body);
      var success = res['success'];
      var message = res['message'];

      if(success == 1 || success == "1"){
        print(message);
        return 1;
      }else{
        print("Success == 0"+message);
        return null;
      }
    }else{
      throw Exception('Error from driver profile API');
    }
  }
}