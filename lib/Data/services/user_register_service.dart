import 'package:masivaye/exceptions/register_exception.dart';
import 'package:masivaye/models/UserAuth.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;

abstract class UserRegisterServiceAbstract{
  //TODO: implement registration using google and facebook
  Future<UserAuth> registerUser(String firstName, String lastName, String email, String phoneNum, String password);
  Future<String> uploadProfileImage(File pickedImage);
}

class UserRegisterService extends UserRegisterServiceAbstract{
  SharedPreferences prefs;
  var server = "http://192.168.43.56";

  @override
  Future<UserAuth> registerUser(String firstName, String lastName, String email, String phoneNum, String password) async{
    prefs = await SharedPreferences.getInstance();

    final url = server+"/masivaye/user_register.php";
    Map<String, String> headers = {"Content-Type" : "application/json"};
    Map<String, dynamic> data = {
      "first_name" : firstName,
      "last_name" : lastName,
      "email" : email,
      "phone_num" : phoneNum,
      "password" : password
    };

    http.Response response = await http.post(
      url,
      headers :headers,
      body: json.encode(data)
    );

    //handle response from json api
    print(response.body);
    if(response.statusCode == 200){
      Map<String, dynamic> res = json.decode(response.body);
      UserAuth user = UserAuth.fromJson(res);

      print(res);
      print(user);

      prefs.setBool('logged', true);
      prefs.setInt('userId', user.id);
      prefs.setString('firstName', user.firstName);
      prefs.setString('lastName', user.lastName);
      prefs.setString('email', user.email);
      prefs.setString('phoneNum', user.phoneNum);
      prefs.setBool('isDriver', user.isDriver);

      return user;
    }else{
      throw RegisterException(message: "Error from api.");
    }
  }

  Future<String> uploadProfileImage(File pickedImage) async{
    prefs = await SharedPreferences.getInstance();
    int id = prefs.getInt('userId');
    var ext = path.extension(pickedImage.path);

    final url = server+'/masivaye/upload_profile_image.php';
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      'user_id' : id,
      'image' : base64Encode(pickedImage.readAsBytesSync()),
      'extension' : ext
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle response from API
    print(json.decode(response.body));
    if(response.statusCode == 200){
      Map<String, dynamic> res = json.decode(response.body);
      var success = res['success'];
      var message = res['message'];

      if(success == 1 || success == "1"){
        print(message);
        var imageUrl = res['imageUrl'];
        prefs.setString('userProfileUrl', imageUrl);
        return imageUrl;
      }else{
        print(message);
      }
    }
  }
}