import 'package:masivaye/exceptions/exceptions.dart';
import 'package:masivaye/models/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class GoogleMapService{

  Future<LatLng> retrieveLastKnownLocation();
  Future<void> updateUserCurrentLocation(LatLng location);
  Future<Set<DriverLocation>> getLocalDriverLocations(LatLng currentLoc, int radius);
  Future<Set<ForHireLocation>> getForHireDriverLocations(LatLng currentLoc);
  Future<Driver> getTappedDriverInformation(int driverId);
  Future<void> requestDriverServices(int userId, int driverId);
  Future<UserLocation> getCustomerLocation(int userId);
}

class MapService extends GoogleMapService{

  SharedPreferences prefs;
  var server = "http://192.168.43.56";

  @override
  Future<LatLng> retrieveLastKnownLocation() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("userId");

    final url = server+"/masivaye/getUserSavedLocation.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "user_id" : id
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle response from api
    print(response.body);

    if(response.statusCode == 200){
      Map<String, dynamic> res = json.decode(response.body);

      if(res['success'] == 1){
        LatLng location = LatLng(res['latitude'], res['longitude']);
        print(res['message']);
        return location;
      }else{
        print(res['message']);
        throw MapException(message: res['message']);
      }
    }else{
      throw MapException(message: "Error occured in retrieve last known location.");
    }
  }

  @override
  Future<void> updateUserCurrentLocation(LatLng location) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("userId");

    final url = server+"/masivaye/update_user_location.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : id,
      "latitude" : location.latitude,
      "longitude" : location.longitude
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body : json.encode(data)
    );

    //handle response from api
    print(response.body);

    if(response.statusCode == 200){
      Map<String, dynamic> res = json.decode(response.body);

      if(res["success"] == 1){
        print(res["message"]);
      }else{
        print(res["message"]);
        throw MapException(message : res["message"]);
      }
    }else{
      throw MapException(message: "Error occured in update user current location.");
    }
  }

  @override
  Future<Set<DriverLocation>> getLocalDriverLocations(LatLng loc, int radius) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("userId");

    final url = server+"/masivaye/get_local_driver_locations.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : id,
      "radius" : radius,
      "current_latitude" : loc.latitude,
      "current_longitude" : loc.longitude
    };

    http.Response response = await http.post(
      url,
      headers : headers,
      body: json.encode(data)
    );

    //handle response from api
    print(response.body);

    if(response.statusCode == 200){
      List res = json.decode(response.body);
      return res.map((item) => DriverLocation.fromJson(item)).toSet();
    }else{
      throw MapException(message: "Could not get driver's locations");
    }
  }

  @override
  Future<Set<ForHireLocation>> getForHireDriverLocations(LatLng loc) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("userId");

    final url = "https://vybe.ashio.me/masivaye/get_forHire_driver_locations.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : id,
      "current_latitude": loc.latitude,
      "current_longitude" : loc.longitude
    };

    http.Response response = await http.post(
      url ,
      headers: headers,
      body: json.encode(data)
    );

    //handle response form API.
    print(response.body);

    if(response.statusCode == 200){
      List res = json.decode(response.body);
      return res.map((item) => ForHireLocation.fromJson(item)).toSet();
    }else{
      throw MapException(message: "Error in get for hire location server call.");
    }
  }

  @override
  Future<Driver> getTappedDriverInformation(int driverId) async{
    final url = "https://vybe.ashio.me/masivaye/getDriverInfo.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "driver_id" : driverId
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body : json.encode(data)
    );

    //handle response from server api
    print(response.body);

    if(response.statusCode == 200){
      Map res = json.decode(response.body);
      return Driver.fromJson(res);
    }else{
      throw MapException(message: "Error in getting driver information from server api.");
    }
  }

  @override
  Future<void> requestDriverServices(int userId, int driverId) async{

  }

  ///**************************************Functions relating to the driver state*************************************************///

  @override
  Future<UserLocation> getCustomerLocation(int userId)async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("driverId");

    final url = "https://vybe.ashio.me/masivaye/get_customer_information.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "driver_id" : id,
      "user_id" : userId
    };

    http.Response response = await http.post(
      url,
      headers:headers,
      body: json.encode(data)
    );

    //handle response
    print(response.body);

    if(response.statusCode == 200){
      final res = json.decode(response.body);
      UserLocation user = UserLocation.fromJson(res);

      return user;
    }else{
      throw MapException(message: "Error from get customer location.");
    }
  }
}