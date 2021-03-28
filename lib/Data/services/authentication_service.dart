import 'package:masivaye/exceptions/exceptions.dart';
import 'package:masivaye/models/UserAuth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masivaye/models/Driver.dart';

abstract class AuthenticationServiceAbstract{
  Future<UserAuth> getCurrentUser();
  Future<UserAuth> signInWithPhoneAndPassword(String phoneNum, String password);
  Future<void> signOut();

  //functions to handle driver authentication
  Future<Driver> getCurrentDriver();
  Future<Driver> signInWithDriverPhoneAndPassword(String phoneNum, String password);
  Future<void> driverSignOut();
}

class AuthenticationService extends AuthenticationServiceAbstract{

  SharedPreferences prefs;
  var server = "http://192.168.43.56";

  @override
  Future<UserAuth> getCurrentUser() async{
    prefs = await SharedPreferences.getInstance();
    bool logged = prefs.getBool('logged');

    if(logged == null || logged == false){
      return null;
    }else if(logged == true){
      print('user data retrieved');
      var userId = prefs.getInt('userId');
      var firstName = prefs.getString('firstName');
      var lastName = prefs.getString('lastName');
      var email = prefs.getString('email');
      var phoneNum = prefs.getString('phoneNum');
      var driver = prefs.getBool('isDriver');
      var profileUrl = prefs.getString('userProfileUrl');

      print(firstName);
      return UserAuth(id: userId, firstName: firstName, lastName : lastName, email: email, phoneNum: phoneNum, profileImageUrl: profileUrl, isDriver: driver);
    }
  }

  @override
  Future<UserAuth> signInWithPhoneAndPassword(String phoneNum, String password) async{
    prefs = await SharedPreferences.getInstance();
    final url = server+"/masivaye/authenticate.php";
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      "is_user" : true,
      "phoneNum" : phoneNum,
      "password" : password
    };

    http.Response response = await http.post(
      url,
      headers : headers,
      body: json.encode(data)
    );

    //handle response from api.
    print(response.body);
    if(response.statusCode == 200 && response.body.contains('id')){
      Map<String, dynamic> res = json.decode(response.body);
      UserAuth user = UserAuth.fromJson(res);

      print(res);
      prefs.setBool('logged', true);
      prefs.setInt('userId', user.id);
      prefs.setString('firstName', user.firstName);
      prefs.setString('lastName', user.lastName);
      prefs.setString('email', user.email);
      prefs.setString('phoneNum', user.phoneNum);
      prefs.setBool('isDriver', user.isDriver);
      prefs.setString('userProfileUrl', user.profileImageUrl);

      return user;
    }else{
      throw AuthenticationException(message: "Error from api.");
    }
  }

  Future<void> signOut() async{
    prefs = await SharedPreferences.getInstance();
    prefs.clear().then((res){
      if(res){
        return;
      }else{
        throw AuthenticationException(message: "Could not sign out.");
      }
    });
  }

  Future<Driver> getCurrentDriver() async{
    prefs = await SharedPreferences.getInstance();
    bool driverLogged = prefs.getBool('driverLogged');
    if(driverLogged == false || driverLogged == null){
      return null;
    }else if(driverLogged == true){
      var driverId = prefs.getInt('driverId');
      var name = prefs.getString('driverFirstName');
      var surname = prefs.getString('driverLastName');
      var idNum = prefs.getInt('driverIdNum');
      var phoneNum = prefs.getString('driverPhoneNum');
      var profileUrl = prefs.getString('driverProfileUrl');

      return Driver(id: driverId, driverName: name, driverSurname: surname, driverIdNum: idNum, driverPhone:phoneNum, driverProfileUrl: profileUrl,isDriver: true);
    }
  }

  Future<Driver> signInWithDriverPhoneAndPassword(String phoneNum, String password) async{
    prefs = await SharedPreferences.getInstance();
    final url = server+'/masivaye/authenticate.php';
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      'phoneNum' : phoneNum,
      'password' : password,
      'is_driver' : true
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle response from API
    print(response.body);

    if(response.statusCode == 200 && !response.body.contains('success')){
      Map<String, dynamic> res = json.decode(response.body);
      Driver driver = Driver.fromJson(res);

      prefs.setBool('driverLogged', true);
      prefs.setInt('driverId', driver.id);
      prefs.setString('driverFirstName', driver.driverName);
      prefs.setString('driverLastName', driver.driverSurname);
      prefs.setInt('driverIdNum',driver.driverIdNum);
      prefs.setString('driverPhoneNum', driver.driverPhone);

      return driver;
    }else{
      throw AuthenticationException(message: "Error from API driver");
    }
  }

  Future<void> driverSignOut() async{
    prefs = await SharedPreferences.getInstance();
    prefs.clear().then((res){
     if(res){
       return null;
     }else{
       throw AuthenticationException(message: "Could not sign out driver.");
     }
    });
  }
}
