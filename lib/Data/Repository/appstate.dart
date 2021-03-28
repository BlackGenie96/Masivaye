import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'locationpath.dart';

class AppState extends ChangeNotifier{
  static LatLng _initialPosition;
  static LatLng _lastPosition;
  GoogleMapController _mapController;
  Set _markers = {};
  Set _polylines = {};
  bool _isLoading = false;

  //To get markers positions.
  LatLng get initialPosition => _initialPosition;
  LatLng get lastPosition => _lastPosition;

  //To check the route checking stage
  bool get isLoading => _isLoading;
  GoogleMapController get mapController => _mapController;

  //To load markers to the map.
  Set get markers => _markers;

  //To load route to the map
  Set get polylines => _polylines;
  LocationPath _locationPath = LocationPath();

  AppState(){
    _getUserLocation();
  }

  //On create, will set the map controller after the map has been created.
  void onCreated(GoogleMapController controller){
    _mapController = controller;
    notifyListeners();
  }

  //handle the camera move position.
  void onCameraMove(CameraPosition position){
    _lastPosition = position.target;
    notifyListeners();
  }

  //fetch users current location
  void _getUserLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);

    _markers.add(Marker(markerId: MarkerId(position.toString()),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),position: LatLng(position.latitude,position.longitude)));
    notifyListeners();
  }

  //To request route path to Google webservice
  void sendRequest(LatLng _initialPosition, Position intendedLocation) async{
    _isLoading = true;
    List placemark = await Geolocator().placemarkFromCoordinates(intendedLocation.latitude, intendedLocation.longitude);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;

    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);
    String route = await _locationPath.getRouteCoordinates(_initialPosition, destination);
    createRoute(route);
    notifyListeners();
  }

  //add marker to markers set and update Map on Marker
  void _addMarker(LatLng location, Position intendedLocation){
    _markers.add(Marker(
      markerId: MarkerId(_lastPosition.toString()),
      position : location,
      infoWindow: InfoWindow(title: "Address", snippet: "Destination"),
      icon: BitmapDescriptor.defaultMarker
    ));
    notifyListeners();
  }

  //to Create route
  void createRoute(String encodedPoly){
    _polylines.add(Polyline(
      polylineId: PolylineId(_lastPosition.toString()),
      width: 4,
      points : _convertToLatLng(_decodePoly(encodedPoly)),
      color: Colors.deepPurple
    ));
    _isLoading = false;
    notifyListeners();
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