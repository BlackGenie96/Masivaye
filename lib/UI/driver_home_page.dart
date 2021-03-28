import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/models/models.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DriverHome extends StatelessWidget{
  final Driver driver;
  Position _currentPosition;

  SharedPreferences prefs;

  DriverHome({@required this.driver});

  //fetch users current location
  void _getDriverLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentPosition = Position.fromMap({"latitude":position.latitude,"longitude": position.longitude});

    //update the location in the server database.
    _updateDriverLocation(_currentPosition);
  }

  Future<void> _updateDriverLocation(Position loc) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('driverId');

    final url = "https://vybe.ashio.me/masivaye/update_driver_location.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "driver_id" : id,
      "latitude" : loc.latitude,
      "longitude" : loc.longitude
    };

    print(json.encode(data));

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from api.
    print(response.body);

    if(response.statusCode == 200){
      Map res = json.decode(response.body);
      print(res['message']);
    }else{
      throw Exception("Error updating driver location.");
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    var _statusColor = Colors.green[700];
    var _statusState = "Online";

    //function to change the status of the driver.
    void _changeStatus(DriverMenuBloc bloc) async{
      await showDialog(
        context : context,
        builder: (context) =>
            AlertDialog(
              title: Text('Choose Status',style:TextStyle(fontWeight:FontWeight.bold,color:Colors.black,)),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      bloc.add(DriverMenuChangeToOnline());
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        borderRadius: BorderRadius.circular(50.0)
                      ),
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Online',style:TextStyle(fontWeight:FontWeight.w300,color: Colors.white,)),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      bloc.add(DriverMenuChangeToBusy());
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.orange[500],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Busy',style:TextStyle(fontWeight:FontWeight.w300,color: Colors.white,)),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      bloc.add(DriverMenuChangeToOffline());
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red[800],
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      margin: const EdgeInsets.all(5.0),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Offline',style:TextStyle(fontWeight: FontWeight.w300,color: Colors.white)),
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.black,
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Text('Cancel',textAlign:TextAlign.center,),
                  onPressed: ()=> Navigator.pop(context),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                ),
              ]
            ),
      );
    }

    return BlocProvider<DriverMenuBloc>(
      create: (context) => DriverMenuBloc(_authBloc),
      child : new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor:Color(0xffff0000),
        ),
        child: new Builder(
          builder: (context) => new Scaffold(
            body:new BlocListener<DriverMenuBloc, DriverMenuState>(
              listener: (context,state){
                if(state is DriverMenuMapsButtonSuccess){
                  Navigator.pushNamed(context, '/driver_map_page');
                }

                if(state is DriverMenuProfileButtonSuccess){
                  //TODO: go to driver profile
                }

                if(state is DriverMenuLogoutButtonSuccess){
                  Navigator.pushReplacementNamed(context,'/');
                }

                if(state is DriverMenuViewRequestsState){
                  Navigator.of(context).pushNamed('/received_requests_page');
                }

                if(state is DriverMenuTransactionsSuccess){
                  Navigator.of(context).pushNamed('/driver_transactions_page');
                }


              },
              child: BlocBuilder<DriverMenuBloc, DriverMenuState>(
                builder: (context, state){
                  if(state is DriverMenuLoading){
                    return Center(
                      child : CircularProgressIndicator()
                    );
                  }

                  if(state is DriverMenuChangeToOnlineSuccess){
                    _statusColor = Colors.green[700];
                    _statusState = "Online";
                    updateStatus(_statusState);
                  }

                  if(state is DriverMenuChangeToBusySuccess){
                    _statusColor = Colors.orange[500];
                    _statusState = "Busy";
                    updateStatus(_statusState);
                  }

                  if(state is DriverMenuChangeToOfflineSuccess){
                    _statusColor = Colors.red[800];
                    _statusState = "Offline";
                    updateStatus(_statusState);
                  }

                  _getDriverLocation();

                  if(state is DriverMenuInitial){
                    updateStatus(_statusState);
                  }

                  return SafeArea(
                    child: Center(
                      child:SingleChildScrollView(
                          child : Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Color(0xffff0000),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    _changeStatus(BlocProvider.of<DriverMenuBloc>(context));
                                  },
                                  child : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                          children: <Widget>[
                                            Icon(Icons.account_circle, color:_statusColor,),
                                            Padding(
                                              padding: const EdgeInsets.only(left:12,),
                                              child: Text('$_statusState'),
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  height: 100,
                                  child: Image.asset('assets/logo4.png'),
                                ),
                                SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.only(left:25.0),
                                  child: Text('Driver',textAlign:TextAlign.start,style:TextStyle(fontSize:15,color:Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:25.0),
                                  child: Text('Menu', style:TextStyle(fontSize:35,color:Colors.white,))
                                ),
                                SizedBox(height: 25.0),
                                GestureDetector(
                                  onTap:(){
                                    BlocProvider.of<DriverMenuBloc>(context).add(DriverMenuViewRequestsEvent());
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      height: 70,
                                      margin: const EdgeInsets.only(left: 25.0),
                                      alignment: Alignment.center,
                                      child : Text(
                                        'Received Request',
                                        textAlign: TextAlign.center,
                                        style:TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                /*GestureDetector(
                                  onTap: (){
                                    BlocProvider.of<DriverMenuBloc>(context).add(DriverMenuProfileButtonPressed());
                                  },
                                  child : Container(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(left: 25.0),
                                    child : Text(
                                      'Driver Profile',
                                      textAlign: TextAlign.center,
                                      style:TextStyle(color:Colors.black,),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.0),*/
                                GestureDetector(
                                  onTap:(){
                                    BlocProvider.of<DriverMenuBloc>(context).add(DriverMenuTransactions());
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                    alignment:Alignment.center,
                                    margin: const EdgeInsets.only(left: 25.0),
                                    child: Text(
                                      'View My Activity',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black
                                      )
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 25.0),
                                GestureDetector(
                                  onTap: (){
                                    BlocProvider.of<DriverMenuBloc>(context).add(DriverMenuLogoutButtonPressed());
                                  },
                                  child : Container(
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(left:25.0),
                                    child : Text(
                                      'Logout',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color:Colors.black,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                  ),
                                ),
                                SizedBox(height:20.0)
                              ],
                            ),
                          ),
                      ),
                    ),
                  );
                }
              )
            ),
          ),
        )
      ),
    );
  }

  void updateStatus(_statusState) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('driverId');

    final url = "https://vybe.ashio.me/masivaye/update_driver_status.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "driver_id": id,
      "status" : _statusState
    };

    http.Response response = await http.post(
      url,
      headers : headers,
      body: json.encode(data)
    );


    print(response.body);

    if(response.statusCode == 200){
      Map j = json.decode(response.body);
      print(j['message']);
    }else{
      throw Exception('Error updating driver status');
    }
  }
}