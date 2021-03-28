import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:masivaye/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TransactionServiceAbstract{
  Future<List<TransactionItem>> getUserTransactions();
  Future<List<TransactionItem>> getDriverTransactions();
  //void getTransactionCoordinates(TransactionItem item);
}

class TransactionService extends TransactionServiceAbstract{

  SharedPreferences prefs;
  var server = "http://192.168.43.56";

  @override
  Future<List<TransactionItem>> getUserTransactions() async{
    prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    final url = server+"/masivaye/get_transactions.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "user_id" : userId
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle response from server api.

    print(response.body);
      try{
        if(response.statusCode == 200){
          List res = json.decode(response.body);
          print(res);
          return res.map((item) => TransactionItem.fromJson(item)).toList();
        }else{
          throw Exception('Error getting transactions from api.');
        }
      }catch(err){
        print(err);
      }
  }

  @override
  Future<List<TransactionItem>> getDriverTransactions() async{
    prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('driverId');

    final url = server+"/masivaye/get_transactions.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "driver_id" : userId
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
      return res.map((item) => TransactionItem.fromJson(item)).toList();
    }else{
      throw Exception('Error getting transactions from api.');
    }
  }
}