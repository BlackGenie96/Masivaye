import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masivaye/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserDriverListAbstractService{
  Future<List<DriverLocation>> getLocalDrivers({String radius, String quantity});
}

const String domain = "http://192.168.43.56/masivaye";
class UserDriverListService extends UserDriverListAbstractService{

  SharedPreferences prefs;

  @override
  Future<List<DriverLocation>> getDriversByLocation() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');

    final url = domain+"/get_drivers_list.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : id
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);

    if(response.statusCode == 200){
      final res = json.decode(response.body);

      return res.map((item) => DriverLocation.fromJson(item)).toList();
    }else{
      throw Exception('Error retrieving data for driver location list.');
    }
  }


  Future<List<DriverLocation>> getLocalDrivers({String radius, String quantity}) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');

    final url = domain+"/get_local_drivers.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : id,
      "radius": radius,
      "quantity" : quantity
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from server api.
    print(response.body);

    if(response.statusCode == 200){
      List res = json.decode(response.body);

      return res.map((item) => DriverLocation.fromJson(item)).toList();
    }else{
      throw Exception('Error from getting local drivers api.');
    }
  }
}