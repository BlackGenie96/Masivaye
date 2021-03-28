import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:masivaye/maps/destination_map_page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:masivaye/models/models.dart';
import 'package:toast/toast.dart';

const double CAMERA_ZOOM = 5;
const double CAMERA_TILT = 20;
const double CAMERA_BEARING = 0;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);
const String domain = "https://vybe.ashio.me/masivaye";

class MapPage extends StatefulWidget{

  LatLng source;
  LatLng dest;
  MapPage({this.source, this.dest});

  @override
  MapPageState createState() => new MapPageState(
    sourceLocation: source == null ? null:  LocationData.fromMap({"latitude": source.latitude,"longitude":source.longitude}),
    destinationLocation: dest == null ? null :  LocationData.fromMap({"latitude": dest.latitude, "longitude":dest.longitude})
  );
}

class MapPageState extends State<MapPage>{

  MapPageState({this.sourceLocation, this.destinationLocation});
  SharedPreferences prefs;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  List<DriverLocation> driversList = [];

  //for the drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  String googleAPIKey = "AIzaSyDB9PVjYaDfB5VL2AArtMuCv3ffAZitN9I";

  //for custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //the user's initial location and current location as it moves
  LocationData currentLocation;

  //a reference to the destination location
  LocationData sourceLocation;
  LocationData destinationLocation;

  //wrapper around the location API
  Location location;

  TextEditingController _quantity = new TextEditingController();
  TextEditingController _radius = new TextEditingController();

  @override
  void initState(){

    super.initState();

    //create an instance of Location
    location = new Location();

    //subscribe to channels in the user's location by listening to the location's onLocationChanged event
    location.onLocationChanged().listen((LocationData cLoc){
      //cLoc contains the lat and lng of the current users position in real time
      //so we are holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });

    //set custom marker pins
    setSourceAndDestinationIcons();

    //set the initial location
    setInitialLocation();

    if(destinationLocation != null){

      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: LatLng(sourceLocation.latitude, sourceLocation.longitude) ,
          icon : sourceIcon,
          infoWindow: InfoWindow(title :'Source')
      ));

      _markers.add(Marker(
          markerId: MarkerId('destinationPin'),
          position: LatLng(destinationLocation.latitude, destinationLocation.longitude),
          icon : destinationIcon,
          infoWindow: InfoWindow(title :'Destination')
      ));
    }else{
      print('error here');
    }
  }

  void setSourceAndDestinationIcons() async{
    sourceIcon = BitmapDescriptor.defaultMarkerWithHue(40);

    destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 1), 'assets/destination.png');
  }

  void setInitialLocation() async{
    //set the initial location by pulling the user's current location from the location's getLocation()
    currentLocation = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt : CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION
    );

    if(currentLocation != null){
      initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing :CAMERA_BEARING
      );
      //this means my location has been found
      //make api call to save location in the database.
      _updateCurrentLocation(currentLocation);
    }

    return Scaffold(
      appBar:AppBar(
        title: sourceLocation == null ? Text('Select Driver:',style: TextStyle(color:Colors.white)) : Text('Source and Destination',style:TextStyle(color:Colors.white,)),
        backgroundColor:Color(0xffff0000),
        iconTheme:IconTheme.of(context).copyWith(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            markers :_markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);

              //my map has been created
              // ready to show pins on map
              showPinsOnMap();
            },
          ),
        ],
      ),
      floatingActionButton: sourceLocation == null ? FloatingActionButton.extended(
          icon:Icon(
            Icons.directions_car,
            color:Colors.white,
          ),
          label:Text(
            'Refresh Drivers',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        backgroundColor:Color(0xffff0000),
        onPressed: (){
          //TODO : handle removing the current markers of drivers on the map, then re-request for the right drivers from the api.
          setState(() {
            for(int i=0; i < _markers.length; i++){
              for(int j=0; j < driversList.length; j++){
                var loc = driversList[j];
                _markers.removeWhere((m) => m.markerId.value == 'driver${loc.id}');
              }
            }
          });

          //display dialog asking the number of people there are
          quantityDialog(context);
        },
      ) : null,
    );
  }

  //function to handle quantity input dialog
  void quantityDialog(BuildContext context) async{
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Please fill in',textAlign:TextAlign.center,style:TextStyle(fontWeight:FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 70,
                  alignment:Alignment.center,
                  child: TextFormField(
                    controller: _quantity,
                    decoration: InputDecoration(
                      hintText: 'How many are you ?',
                      hintStyle: TextStyle(
                        color: Color(0xffff0000),
                      ),
                      enabledBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color:Color(0xffff0000), width:2),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Color(0xffff0000), width: 0.5)
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 70,
                  alignment:Alignment.center,
                  child: TextFormField(
                    controller: _radius,
                    decoration: InputDecoration(
                      hintText: 'Search Distance (km)',
                      hintStyle: TextStyle(
                        color: Color(0xffff0000),
                      ),
                      enabledBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(color:Color(0xffff0000), width:2),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(color: Color(0xffff0000), width: 0.5)
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              RaisedButton(
                color: Colors.black,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
                padding: const EdgeInsets.all(16.0),
                onPressed: (){
                  getLocalDrivers();
                  Navigator.pop(context);
                },
                child: Text('Okay'),
              ),
              RaisedButton(
                color:Colors.black,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(70.0)),
                padding: const EdgeInsets.all(16.0),
                onPressed:(){
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ]
          )
    );
  }

  //function to handle getting the local driver locations from server.
  void getLocalDrivers() async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');

    final url = domain+"/get_local_drivers.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String,dynamic> data = {
      "user_id" : id,
      "radius": _radius.text,
      "quantity" : _quantity.text
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
      res.map((item) => addDriverPin(DriverLocation.fromJson(item))).toList();

    }else{
      throw Exception('Error from getting local drivers api.');
    }
  }

  @override
  void dispose(){
    super.dispose();
  }

  void showPinsOnMap(){
    //get a LatLng for the source location from the LocationData currentLocation object
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

    //add the initial source location pin
    _markers.add(Marker(
      markerId: MarkerId('current_user'),
      position: pinPosition,
      icon : BitmapDescriptor.defaultMarkerWithHue(80),
      infoWindow: InfoWindow(title :'This is me')
    ));
  }

  void setPolylines() async{
    try{
      List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          currentLocation.latitude,
          currentLocation.longitude,
          destinationLocation.latitude,
          destinationLocation.longitude);

      if(result.isNotEmpty){
        result.forEach((PointLatLng point){
          polylineCoordinates.add(
              LatLng(point.latitude, point.longitude)
          );
        });

        setState((){
          _polylines.add(Polyline(
              width: 5, //set the width of the polylines
              polylineId: PolylineId("poly"),
              color: Color.fromARGB(255, 40, 122, 198),
              points : polylineCoordinates
          ));
        });
      }
    }catch(err){
      print(err);
    }
  }

  void updatePinOnMap() async{

    final GoogleMapController controller = await _controller.future;
    //create a new Camera Position instance everytime the location changes, so the camera follows the pin as it moves with an animation


    CameraPosition cPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt : CAMERA_TILT,
        bearing : CAMERA_BEARING,
        target: LatLng(currentLocation.latitude, currentLocation.longitude)
    );
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    //do this inside the setState() so flutter gets notified that widget update is due
    setState(() {
      //updated Position
      var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      //the trick is to remove the marker by id and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'current_user');

      _markers.add(Marker(
        markerId: MarkerId('current_user'),
        position: pinPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(80),
        infoWindow: InfoWindow(title: "This is me"),
      ));
    });

    /*if(sourceLocation != null){
      LocationData _northeastCoordinates;
      LocationData _southwestCoordinates;

// Calculating to check that
// southwest coordinate <= northeast coordinate
      if (sourceLocation.latitude <= destinationLocation.latitude) {
        _southwestCoordinates = sourceLocation;
        _northeastCoordinates = destinationLocation;
      } else {
        _southwestCoordinates = destinationLocation;
        _northeastCoordinates = sourceLocation;
      }

      controller.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(
              _northeastCoordinates.latitude,
              _northeastCoordinates.longitude,
            ),
            southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude
            ),
          ),
          100.0
      ));
    }else{

    }*/

  }

  Future<void> _updateCurrentLocation(LocationData currentLocation) async{

    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt("userId");

    final url = domain+"/update_user_location.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      "user_id" : id,
      "latitude" : currentLocation.latitude,
      "longitude" : currentLocation.longitude
    };

    http.Response response = await http.post(
      url,
      headers : headers,
      body: json.encode(data)
    );

    //handle response
    print(response.body);

    if(response.statusCode == 200){
      Map<String,dynamic> decoded = json.decode(response.body);
      final success = decoded["success"];
      final message = decoded["message"];

      if(success == 1){
        print(message);
      }else{
        print(message);
      }
    }else{
      throw Exception('Error from server api: _updateCurrentLocation()');
    }
  }

  void addDriverPin(DriverLocation loc) async{
    setState((){
      var position = LatLng(loc.latitude,loc.longitude);

      _markers.add(Marker(
        markerId: MarkerId('driver${loc.id}'),
        position: position,
        icon:BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title:'${loc.driverName} ${loc.driverSurname}'),
        onTap: (){
          //display dialog to ask if this is the driver the user wants.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:(context)=> ConfirmDriver(location: loc, quantity: _quantity.text,)
            )
          );
        },
      ));
    });

    driversList.add(loc);
  }
}

class ConfirmDriver extends StatefulWidget{
  final DriverLocation location;
  final String quantity;

  ConfirmDriver({@required this.location,@required this.quantity});
  @override
  ConfirmDriverState createState() => new ConfirmDriverState(location : location, quantity: quantity);
}

class ConfirmDriverState extends State<ConfirmDriver>{

  SharedPreferences prefs;
  final DriverLocation location;
  final String quantity;
  ConfirmDriverState({@required this.location, @required this.quantity});

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Color(0xff)
      ),
      child: new Builder(
        builder: (context)=> Scaffold(
          appBar:new PreferredSize(
            child: Container(
              alignment:Alignment.centerLeft,
              padding: new EdgeInsets.only(
                top : MediaQuery.of(context).padding.top,
              ),
              child: new Padding(
                padding: const EdgeInsets.only(
                  left: 15,
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
          body:SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffff8a00), Color(0xffff0000)],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap:(){
                              driverProfileHero();
                            },
                            child: Hero(
                              tag: 'driver_profile_image',
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: MediaQuery.of(context).size.width * 0.45,
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(location.profileUrl)
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:(){
                              carProfileHero();
                            },
                            child: Hero(
                              tag: 'car_profile_image',
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: MediaQuery.of(context).size.width * 0.45,
                                child: CircleAvatar(
                                    backgroundImage: NetworkImage(location.carProfileUrl)
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: Text('${location.driverName} ${location.driverSurname}',style:TextStyle(color:Colors.white,)),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(
                          left : 15.0
                      ),
                      child: Text('${location.driverPhone}',style:TextStyle(color: Colors.white,),),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0
                      ),
                      child: Text('${location.carModel}',style:TextStyle(color:Colors.white)),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 15.0,
                        ),
                        child: Text('Number Of Seats : ${location.seats}',style:TextStyle(color:Colors.white,),)
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
                                'Are you sure you want the services of this driver ?',
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
                                        updateRequest(location, context);

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
                                        width: MediaQuery.of(context).size.width* 0.2,
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
      )
    );
  }

  void updateRequest(DriverLocation driver, BuildContext context) async{
    prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('userId');

    final url = domain+"/on_going_requests.php";
    Map<String,String> headers = {"Content-Type":"application/json"};
    Map<String, dynamic> data = {
      "user_id": id,
      "driver_id" : driver.id,
      "quantity" : quantity
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body: json.encode(data)
    );

    //handle response from api.
    print(response.body);

    if(response.statusCode == 200){
      Map result = json.decode(response.body);
      if(result['success'] == 1 || result['success'] == "1"){
        print(result['message']);
        var id1 = result['id'];
        prefs.setInt('requestId',id1);
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DestinationMapPage(requestId: id1)
            ));
      }else{
        Toast.show(result['message'],context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      }
    }else{
      throw Exception('Error inserting into on going requests.');
    }
  }

  void driverProfileHero(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Theme(
                data : Theme.of(context).copyWith(
                    scaffoldBackgroundColor: Colors.black
                ),
                child: Builder(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Driver Image'),
                        backgroundColor: Colors.black,
                        iconTheme : IconTheme.of(context).copyWith(
                          color : Colors.white,
                        ),
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding:const EdgeInsets.only(
                                    left: 15.0
                                  ),
                                  child: Text('${location.driverName} ${location.driverSurname}',style:TextStyle(color:Colors.white,)),
                                ),
                                SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0
                                  ),
                                  child: Text('${location.driverPhone}',style:TextStyle(color:Colors.white,)),
                                ),
                                SizedBox(height: 25.0),
                                Hero(
                                  tag: 'driver_profile_image',
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      child: Image.network(location.profileUrl)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ),
                )
            )
        )
    );
  }

  void carProfileHero(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Theme(
                data : Theme.of(context).copyWith(
                    scaffoldBackgroundColor: Colors.black
                ),
                child: Builder(
                  builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: Text('Car Image'),
                        backgroundColor: Colors.black,
                        iconTheme : IconTheme.of(context).copyWith(
                          color : Colors.white,
                        ),
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child : Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                  ),
                                  child: Text('${location.carModel}',style: TextStyle(color: Colors.white)),
                                ),
                                SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0
                                  ),
                                  child: Text('Number Of Seats : ${location.seats}',style:TextStyle(color: Colors.white,)),
                                ),
                                SizedBox(height: 25.0),
                                Hero(
                                  tag: 'car_profile_image',
                                  child: Container(
                                      width: MediaQuery.of(context).size.width * 0.95,
                                      height: MediaQuery.of(context).size.height * 0.8,
                                      child: Image.network(location.carProfileUrl)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ),
                  ),
                )
            )
        )
    );
  }
}