import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:masivaye/models/models.dart';
import '../UI/finish_request_page.dart';

const double CAMERA_ZOOM = 11;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 0;
const LatLng SOURCE_LOCATION = LatLng(0.0,000);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);
const String domain = "https://vybe.ashio.me/masivaye";

class DestinationMapPage extends StatefulWidget{

  final int requestId;
  LocationData source;
  LocationData destination;
  LocationData userLocation;
  LocationData driverLocation;

  DestinationMapPage({this.source, this.destination,this.userLocation, this.driverLocation, @required this.requestId});
  @override
  DestinationMapPageState createState() => new DestinationMapPageState(
    requestId: requestId,
    sourceLocation: source == null ? null : source,
    destinationLocation: destination == null ? null : destination,
  );
}

class DestinationMapPageState extends State<DestinationMapPage>{

  final int requestId;
  DestinationMapPageState({this.sourceLocation,this.destinationLocation, this.userLocation, this.driverLocation,@required this.requestId});
  SharedPreferences prefs;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  PolylinePoints _polylinePoints = PolylinePoints();

  String googleAPIKey = "AIzaSyDB9PVjYaDfB5VL2AArtMuCv3ffAZitN9I";

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  BitmapDescriptor driverIcon;

  LocationData currentLocation;
  LocationData destinationLocation;
  LocationData sourceLocation;
  LocationData userLocation;
  LocationData driverLocation;

  Location location;

  @override
  void initState(){
    super.initState();

    location = new Location();

    if(sourceLocation != null){
      _markers.add(Marker(
        markerId: MarkerId('source'),
        position: LatLng(sourceLocation.latitude,sourceLocation.longitude),
        icon: sourceIcon,
        infoWindow: InfoWindow(title: 'Start here'),
      ));

      _markers.add(Marker(
        markerId: MarkerId('destination'),
        position: LatLng(destinationLocation.latitude,destinationLocation.longitude),
        icon: destinationIcon,
        infoWindow: InfoWindow(title: 'Destination'),
      ));
    }

    location.onLocationChanged().listen((LocationData cLoc){
      currentLocation = cLoc;
      updatePinOnMap();
    });
    setIcons();
  }

  void setIcons() async{
    sourceIcon = BitmapDescriptor.defaultMarkerWithHue(80);
    destinationIcon = BitmapDescriptor.defaultMarker;
    driverIcon = BitmapDescriptor.defaultMarkerWithHue(40);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: SOURCE_LOCATION,
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING
    );

    if(currentLocation != null){
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom : CAMERA_ZOOM,
        bearing: CAMERA_BEARING,
        tilt: CAMERA_TILT,
      );

    }

    return Scaffold(
      appBar: AppBar(
        title: sourceLocation == null ? Text('Destination',style:TextStyle(color:Colors.white)): Text('On Going Request',style:TextStyle(color:Colors.white,)),
        backgroundColor: Color(0xffff8a00),
        iconTheme: IconTheme.of(context).copyWith(
          color:Colors.white,
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.hybrid,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);

              showCurrentLocationPin();
              if(sourceLocation == null){
                if(sourceLocation != null){
                  print('I am setting polylies now.');
                  setPolylines(currentLocation, sourceLocation);
                  setPolylines(sourceLocation, destinationLocation);
                }
              }
            },
            onTap:((LatLng pos){
              if(sourceLocation == null){
                _markers.add(Marker(
                    markerId: MarkerId('dest1'),
                    position: pos,
                    icon: destinationIcon,
                    infoWindow: InfoWindow(title: 'Destination1')
                ));

                //display a dialog asking if this is the right destination.
                //Future.delayed(Duration(milliseconds: 1500));
                return Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:(context) => ConfirmDestination(destination: pos,)
                    )
                );
              }

              return null;

            }),
          ),
        ],
      ),
      floatingActionButton: sourceLocation == null ? null: FloatingActionButton.extended(
        onPressed: finishRequest,
        label: Text('Finished',style:TextStyle(color:Color(0xffff8a00))),
        icon: Icon(Icons.done,color:Color(0xffff8a00)),
        backgroundColor: Colors.white,
      ),
    );
  }

  setPolylines(LocationData source, LocationData dest) async{
    List<PointLatLng> result = await _polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        source.latitude,
        source.longitude,
        dest.latitude,
        dest.longitude);

    if(result.isNotEmpty){
      result.forEach((PointLatLng point){
        _polylineCoordinates.add(
          LatLng(point.latitude,point.longitude)
        );
      });
    }

    setState(() {
      Polyline polyline = Polyline(
        polylineId: PolylineId("poly"),
        color: Color.fromARGB(255,40,122,198),
        points: _polylineCoordinates
      );

      _polylines.add(polyline);
    });
  }

  void finishRequest() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('driverId');
    final url = domain+"/finish_request.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "driver_id" : id,
      "request_id" : requestId
    };

    print(json.encode(data));
    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);

    try{
      if(response.statusCode == 200){
        Map res = json.decode(response.body);
        if(res['success'] == 1 || res['success'] == "1"){
          print(res['message']);
          Navigator.pushNamed(context, '/');
        }else{
          print(res["message"]);
        }
      }
    }catch(err){
      print(err);
    }
  }
  void showCurrentLocationPin() async{
    prefs = await SharedPreferences.getInstance();
    var name,surname;
    if(sourceLocation == null){
      name = prefs.getString('firstName');
      surname = prefs.getString('lastName');
    }else{
      name = prefs.getString('driverName');
      surname = prefs.getString('driverSurname');
    }
    var pin = LatLng(currentLocation.latitude, currentLocation.longitude);
    setState(() {

      _markers.add(Marker(
          markerId: MarkerId('current_user'),
          position: pin,
          icon: driverIcon,
          infoWindow: InfoWindow(title: '$name $surname')
      ));
    });
  }

  void updatePinOnMap() async{

    prefs = await SharedPreferences.getInstance();
    var name,surname;
    if(sourceLocation == null){
      name = prefs.getString('firstName');
      surname = prefs.getString('lastName');
    }else{
      name = prefs.getString('driverFirstName');
      surname = prefs.getString('driverLastName');
    }

    CameraPosition cPosition = CameraPosition(
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
      zoom : CAMERA_ZOOM,
      bearing: CAMERA_BEARING,
      tilt: CAMERA_TILT,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState(() {
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      _markers.removeWhere((m) => m.markerId.value == 'current_user');

      _markers.add(Marker(
        markerId: MarkerId('current_user'),
        position: pinPosition,
        icon: driverIcon,
        infoWindow: InfoWindow(title: '$name $surname')
      ));
    });
  }

}

class ConfirmDestination extends StatefulWidget{

  final LatLng destination;
  ConfirmDestination({@required this.destination});

  @override
  ConfirmDestinationState createState() => new ConfirmDestinationState(destination: destination);
}

class ConfirmDestinationState extends State<ConfirmDestination>{

  TextEditingController destinationName = new TextEditingController();
  SharedPreferences prefs;
  final LatLng destination;

  ConfirmDestinationState({@required this.destination});

  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: Theme.of(context).copyWith(
        ),
        child: new Builder(
          builder: (context)=> Scaffold(
            appBar:AppBar(
              backgroundColor: Color(0xffff8a00),
              iconTheme: IconTheme.of(context).copyWith(
                color:Colors.white,
              ),
              elevation: 0.0,
            ),
            body:SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffff8a00),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 25.0),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 70,
                          alignment: Alignment.center,
                          child: TextFormField(
                              controller: destinationName,
                              decoration: InputDecoration(
                                hintText: 'Where are you going ?',
                                hintStyle: TextStyle(
                                    color: Color(0xffffffff)
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color:Color(0xffffffff), width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(color: Color(0xffffffff), width: 0.5),
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.black
                              ),
                              keyboardType: TextInputType.text
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding:const EdgeInsets.all(16.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children : <Widget>[
                                  SizedBox(height: 20.0),
                                  Text('Confirm',style:TextStyle(fontSize: 18,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Is this your destination',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 22,
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0,),
                                      color: Colors.black,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        InkWell(
                                          onTap:(){
                                            //send data to database and continue to ask for destination.
                                            updateOngoingRequest();
                                          },
                                          child:Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child:Text(
                                              'Okay',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight:FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          width: MediaQuery.of(context).size.width * 0.01,
                                          height: 45,
                                        ),
                                        InkWell(
                                          onTap:(){
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width * 0.2,
                                            child : Text(
                                              'Cancel',
                                              textAlign: TextAlign.center,
                                              style:TextStyle(
                                                fontWeight:FontWeight.bold,
                                                color:Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }

  void updateOngoingRequest() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('requestId');

    final url = domain+"/on_going_requests.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "id" : id,
      "latitude" : destination.latitude,
      "longitude" : destination.longitude,
      "destination_name" : destinationName.text
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from api
    print(response.body);

    if(response.statusCode == 200){
      Map res = json.decode(response.body);

      if(res["success"] == 1 || res["success"] == "1"){
        //go to finish request
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context)=> FinishRequest()
          ),
        );
      }else{
        throw Exception('Error updating on going request');
      }
    }
  }
}