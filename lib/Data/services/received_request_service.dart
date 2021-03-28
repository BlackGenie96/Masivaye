import 'package:masivaye/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ReceivedRequestServiceAbstract{
  Future getRequest();
  Future acceptRequest(ReceivedRequest request);
  Future declineRequest(int request);
}

class ReceivedRequestService extends ReceivedRequestServiceAbstract{

  SharedPreferences prefs;
  var server = "http://192.168.43.56";

  @override
  Future getRequest() async{

    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('driverId');
    final url = server+'/masivaye/get_requests.php';
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "driver_id" : id
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);
    try{
      if(response.statusCode == 200){
        Map<String,dynamic> res = json.decode(response.body);
        ReceivedRequest req = ReceivedRequest.fromJson(res);
        print(req.requestId);
        return req;

      }else{
        throw Exception('Error retrieving requests');
      }
    }catch(err){
      print(err);
    }
  }

  @override
  Future acceptRequest(ReceivedRequest request) async {
    final url = server+'/masivaye/accept_request.php';
    Map<String,String> headers = {"Content-Type" : "application/json"};
    Map<String,dynamic> data = {
      "request_id" : request.requestId,
      "status" : "Accepted"
    };

    http.Response response = await http.post(
      url ,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);
    if(response.statusCode == 200){
      Map res = json.decode(response.body);

      if(res["success"] == 1 || res["success"] == "1"){
        print(res["message"]);
        return;
      }else{
        print(res['message']);
      }
    }else{
      throw Exception('Error accepting request. Driver');
    }
    
  }

  @override
  Future declineRequest(int request) async {
    final url = server+'/masivaye/decline_request.php';
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "request_id" : request,
      "status" : "Declined",
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );

    print(response.body);
    if(response.statusCode == 200){
      Map res = json.decode(response.body);

      if(res["success"] == 1 || res["success"] == "1"){
        print(res["message"]);
        return;
      }
      print(res["message"]);
    }else{
      throw Exception('Error declining request. Driver');
    }
  }

}