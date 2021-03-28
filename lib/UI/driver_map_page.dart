import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/Repository/locationpath.dart';

const double CAMERA_ZOOM1 = 15;
const double CAMERA_TILT1 = 5;
const double CAMERA_BEARING1 = 0;
const LatLng SOURCE_LOCATION1 = LatLng(42.747932, -71.167889);


class DriverMapPage extends StatefulWidget{
  @override
  DriverMapPageState createState() => new DriverMapPageState();
}

class DriverMapPageState extends State<DriverMapPage>{

  Geolocator _geolocator;
  Position _currentPosition;
  Position _destinationPosition;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  SharedPreferences prefs;

  //for drawing of routes on map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  LocationPath _locationPath = LocationPath();

  String googleAPIKey = "AIzaSyDB9PVjYaDfB5VL2AArtMuCv3ffAZitN9I";

  void setSourceAndDestinationIcons() async{
    sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/source.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/destination.png');
  }

  void _getCurrentLocation(){
    _geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then(
            (Position position){
              setState(() {
                _currentPosition = position;
              });
    }).catchError((e){
      print(e);
    });
  }

  @override
  void initState(){
    super.initState();
    _geolocator = Geolocator();
    polylinePoints = PolylinePoints();


    setSourceAndDestinationIcons();
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);
    checkPermission();
    _getCurrentLocation();

    StreamSubscription positionStream = _geolocator.getPositionStream(locationOptions).listen(
        (Position position){
          _currentPosition = position;
        });
  }

  void updateLocation() async{
    try{
      Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(new Duration(seconds: 15));
      setState(() {
        _currentPosition = newPosition;
      });
    }catch(e){
      print('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {

    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM1,
      tilt: CAMERA_TILT1,
      bearing: CAMERA_BEARING1,
      target: SOURCE_LOCATION1,
    );

    if(_currentPosition != null){
      initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM1,
        tilt: CAMERA_TILT1,
        bearing: CAMERA_BEARING1,
        target: LatLng(_currentPosition.latitude, _currentPosition.longitude)
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Driver\'s Map'),
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            compassEnabled: true,
            tiltGesturesEnabled: true,
            markers: _markers,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);

              showPinsOnMap();
            },
            onTap:(LatLng loc){
              //TODO : show dialog asking if this is a location destination.
              _markers.add(Marker(
                markerId: MarkerId('${loc.toString}'),
                position: loc,
                icon: destinationIcon,
                infoWindow: InfoWindow(title:"Destination")
              ));

              setState((){
                _destinationPosition = Position.fromMap({
                  "latitude" : loc.latitude,
                  "longitude" : loc.longitude});
              });

              showPinsOnMap();
            },
          ),
          Positioned(
            child: GestureDetector(
              onTap: (){
                print('update location');
                updateLocation();
                updatePinOnMap();
                updateDriverLocation(_currentPosition);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.orange[900],
                  borderRadius: BorderRadius.circular(100),
                ),
                child : Icon(Icons.location_on,color:Colors.white, size: 35),
              ),
            ),
          ),
        ],
      )
    );
  }

  void showPinsOnMap(){
    //get a LatLng for the source location from the LocationData currentLocation object
    var pinPosition = LatLng(_currentPosition.latitude, _currentPosition.longitude);

    //get a LatLng out of the LocationData object
    var destPosition = LatLng(_destinationPosition.latitude, _destinationPosition.longitude);

    //add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon : sourceIcon,
        infoWindow: InfoWindow(title :'Source')
    ));

    //destination pin
    /*_markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon,
        infoWindow: InfoWindow(title: 'Destination')
    ));*/

    //set the route lines on  the map from source to destination
    if(_currentPosition != null && _destinationPosition != null){
      sendRequest(LatLng(_currentPosition.latitude,_currentPosition.longitude), _destinationPosition);
    }else{
      print('coordinates are null.');
    }
  }

  void setPolylines() async{
    List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
        googleAPIKey,
        _currentPosition.latitude,
        _currentPosition.longitude,
        _destinationPosition.latitude,
        _destinationPosition.longitude);

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
    }else{
      print('error with setting polylines.');
    }
  }

  void updatePinOnMap() async{
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM1,
      tilt: CAMERA_TILT1,
      bearing: CAMERA_BEARING1,
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude)
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    setState((){
      var pinPosition = LatLng(_currentPosition.latitude, _currentPosition.longitude);

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon : sourceIcon,
        infoWindow: InfoWindow(title: "This is me.")
      ));
    });
  }

  void checkPermission(){
    _geolocator.checkGeolocationPermissionStatus().then((status){print('status: $status');});
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status){print('always status: $status');});
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status){print('whenInUse status: $status');});
  }

  Future<void> updateDriverLocation(Position loc) async{
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

  //handle the camera move position.
  void onCameraMove(CameraPosition position){
    _destinationPosition = Position.fromMap({"latitude" : position.target.latitude, "longitude" : position.target.longitude});
  }

  //fetch users current location
  void _getUserLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    _currentPosition = Position.fromMap({"latitude":position.latitude,"longitude": position.longitude});

    _markers.add(Marker(markerId: MarkerId(position.toString()),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),position: LatLng(position.latitude,position.longitude)));
  }

  //To request route path to Google webservice
  void sendRequest(LatLng _initialPosition, Position intendedLocation) async{

    List placemark = await Geolocator().placemarkFromCoordinates(intendedLocation.latitude, intendedLocation.longitude);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;

    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination);
    String route = await _locationPath.getRouteCoordinates(_initialPosition, destination);
    createRoute(route);
  }

  //add marker to markers set and update Map on Marker
  void _addMarker(LatLng location){
    _markers.add(Marker(
        markerId: MarkerId(_destinationPosition.toString()),
        position : location,
        infoWindow: InfoWindow(title: "Address", snippet: "Destination"),
        icon: BitmapDescriptor.defaultMarker
    ));
  }

  //to Create route
  void createRoute(String encodedPoly){
    _polylines.add(Polyline(
        polylineId: PolylineId(_destinationPosition.toString()),
        width: 4,
        points : _convertToLatLng(_decodePoly(encodedPoly)),
        color: Colors.deepPurple
    ));
  }

  List _convertToLatLng(List points){
    List result = [];

    for(int i = 0; i < points.length; i++){
      if(i%2 != 0){
        result.add(LatLng(points[i-1],points[i]));
      }
    }
    return result;
  }

  //decode poly
  List _decodePoly(String poly){
    var list = poly.codeUnits;
    var IList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;

    do{
      var shift = 0;
      int result = 0;

      do{
        c = list[index] - 63;
        result |=(c & 0x1F)<<(shift*5);
        index++;
        shift++;
      }while(c >= 32);

      if(result & 1 == 1){
        result = ~result;
      }

      var result1 = (result >> 1)*0.00001;
      IList.add(result1);
    }while(index < len);

    //adding to previous value as done in encoding
    for(var i =2; i< IList.length; i++){
      IList[i] += IList[i-2];
    }

    print(IList.toString());
    return IList;
  }
}