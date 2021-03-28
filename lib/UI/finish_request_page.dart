import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String domain = 'https://vybe.ashio.me/masivaye';

class FinishRequest extends StatefulWidget{

  @override
  FinishRequestState createState() => new FinishRequestState();
}

class FinishRequestState extends State<FinishRequest>{

  SharedPreferences prefs;
  int _radioValue;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new PreferredSize(
        child: Container(
          alignment:Alignment.centerLeft,
          padding: new EdgeInsets.only(
            top : MediaQuery.of(context).padding.top,
          ),
          child: new Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              color:Colors.white,
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffff8a00), Color(0xffff0000)]
            ),
          ),
        ),
        preferredSize: new Size(
          MediaQuery.of(context).size.width,
          60
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient:LinearGradient(
                colors: [Color(0xffff8a00),Color(0xffff0000)],
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 35.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left:15.0),
                            child: Text('Let\'s finalize your',style:TextStyle(color:Colors.white,fontSize:13,fontWeight:FontWeight.w300)),
                          ),
                          SizedBox(height: 2),
                          Padding(
                            padding:const EdgeInsets.only(left: 15.0),
                            child: Text('Request',style:TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    /*Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width* 0.45,
                        height: 50,
                        child: Image.asset('assets/logo4.png',scale: 4),
                      ),
                    ),*/
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(70.0),
                  ),
                  width: MediaQuery.of(context).size.width*0.99,
                  child : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 12.0),
                      Text('Confirm',style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center),
                      SizedBox(height: 30.0),
                      Text(
                        'Payment Method',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Radio(
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: (int val){
                                    setState(() {
                                      _radioValue = val;
                                    });
                                  },
                                ),
                                new Text(
                                  'Mobile Money',
                                  style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Radio(
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: (int val){
                                    setState(() {
                                      _radioValue = val;
                                    });
                                  },
                                ),
                                new Text(
                                  'EWallet',
                                  style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Radio(
                                  value: 2,
                                  groupValue: _radioValue,
                                  onChanged: (int val){
                                    setState(() {
                                      _radioValue = val;
                                    });
                                  },
                                ),
                                new Text(
                                  'EMali',
                                  style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                new Radio(
                                  value: 3,
                                  groupValue: _radioValue,
                                  onChanged: (int val){
                                    setState(() {
                                      _radioValue = val;
                                    });
                                  },
                                ),
                                new Text(
                                  'Cash',
                                  style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: (){
                          finishRequestService();
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          alignment: Alignment.center,
                          child: Text('Finish',style:TextStyle(color:Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void finishRequestService() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('requestId');

    final url = domain+"/finish_request.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "method" : _radioValue,
      "id"     : id
    };

    http.Response response = await http.post(
      url,
      headers : headers,
      body: json.encode(data)
    );

    //handle response from server api.
    print(response.body);

    if(response.statusCode == 200){
      Map result = json.decode(response.body);
      var val = result["message"];

      if(val == "Success."){
        print(val);
      }else{
        print(val);
      }
    }else{
      throw Exception('Error finishing up request');
    }
  }
}