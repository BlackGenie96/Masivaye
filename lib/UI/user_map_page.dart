import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:masivaye/models/models.dart';
import 'package:masivaye/Data/services/services.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DESTINATION_LOCATION =  LatLng(37.335685, -122.0605916);

class UserMapPage extends StatelessWidget{

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
  LocationData currentLocation;
  LocationData destinationLocation;
  Location location;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  //for the drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  String googleAPIKey = "AIzaSyDB9PVjYaDfB5VL2AArtMuCv3ffAZitN9I";

  @override
  Widget build(BuildContext context) {

    final _mapService = RepositoryProvider.of<MapService>(context);
    return BlocProvider<UserMapBloc>(
      create: (context) => UserMapBloc(_mapService),
      child : new Theme(
        data: Theme.of(context).copyWith(

        ),
        child: new Builder(
          builder: (context) => Scaffold(
            body: BlocListener<UserMapBloc,UserMapState>(
              listener: (context, state){


              },
              child: BlocBuilder<UserMapBloc,UserMapState>(
                builder: (context,state){

                  if(state is UserMapMyLocationFound){
                    //TODO: yet to decide what to do upon retrieval of current location.
                  }

                  if(state is UserMapNearbyDriversLocated){
                    //TODO : yet to decide what happens here.
                  }

                  if(state is UserMapNearbyForHireLocated){
                    //TODO : yet to define functionality.
                  }

                  if(state is UserMapDriverInformationRetrieved){
                    //TODO: display a bubble showing the driver information.
                  }

                  if(state is UserMapSetPolylinesSuccess){
                    _polylines.add(Polyline(
                        width: 5,
                        polylineId: PolylineId("poly"),
                        color: Color.fromARGB(255, 40, 122, 198),
                        points: polylineCoordinates
                    ));
                  }

                  if(state is UserMapUpdatePinSuccess){
                    //upon updating the new user position, update the pin on the map
                    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
                    _markers.removeWhere((m) => m.markerId.value == 'sourcePin');

                    _markers.add(Marker(
                        markerId : MarkerId('sourcePin'),
                        position: pinPosition,
                        icon : sourceIcon,
                        infoWindow: InfoWindow(title: 'This is me.')
                    ));
                  }

                  if(state is UserMapShowPinsOnMapSuccess){
                    setPolylines(BlocProvider.of<UserMapBloc>(context));
                  }

                  location = new Location();
                  location.onLocationChanged().listen((LocationData cLoc){
                    currentLocation = cLoc;
                    updatePinOnMap(BlocProvider.of<UserMapBloc>(context));
                  });

                  setSourceAndDestinationIcons();
                  setInitialLocation();

                  if(state is UserMapLoading){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  CameraPosition initialCameraPosition = CameraPosition(
                    target: SOURCE_LOCATION,
                    zoom: CAMERA_ZOOM,
                    tilt : CAMERA_TILT,
                    bearing: CAMERA_BEARING,
                  );

                  if(currentLocation != null){
                    initialCameraPosition = CameraPosition(
                      target: LatLng(currentLocation.latitude, currentLocation.longitude),
                      zoom : CAMERA_ZOOM,
                      bearing: CAMERA_BEARING
                    );

                    destinationLocation = LocationData.fromMap({
                      "latitude" : currentLocation.latitude+200,
                      "longitude" : currentLocation.longitude,
                    });

                    //call find my location event on location found
                    BlocProvider.of<UserMapBloc>(context).add(FindMyLocation(loc: LatLng(currentLocation.latitude, currentLocation.longitude)));
                  }

                  return SafeArea(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          myLocationEnabled: true,
                          compassEnabled: true,
                          tiltGesturesEnabled: true,
                          markers: _markers,
                          polylines: _polylines,
                          mapType: MapType.normal,
                          initialCameraPosition: initialCameraPosition,
                          onMapCreated: (GoogleMapController controller){
                            _controller.complete(controller);

                            showPinsOnMap(BlocProvider.of<UserMapBloc>(context));
                          },
                        )
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );

  }

  void setSourceAndDestinationIcons() async{
    sourceIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/source.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5), 'assets/destination.png');
  }

  void setInitialLocation() async{
    currentLocation = await location.getLocation();

    //handle setting of destination on click
    destinationLocation = LocationData.fromMap({
      "latitude" : currentLocation.latitude + 40.0,
      "longitude" : currentLocation.longitude + 40.0
    });
  }

  void showPinsOnMap(UserMapBloc bloc){
    var pinPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    var destPosition = LatLng(destinationLocation.latitude, destinationLocation.longitude);

    //add the initial source location pin
    _markers.add(Marker(
      markerId: MarkerId('sourcePin'),
      position: pinPosition,
      icon: sourceIcon,
      infoWindow: InfoWindow(title: 'Source',),
    ));

    //destination Pin
    _markers.add(Marker(
      markerId: MarkerId('destPin'),
      position: destPosition,
      icon: destinationIcon,
      infoWindow: InfoWindow(title: 'Destination')
    ));

    //set up the route between the two positions on the map.
    //setPolylines();
    bloc.add(UserMapShowPinsOnMap());
  }

  void setPolylines(UserMapBloc bloc) async{
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        currentLocation.latitude,
        currentLocation.longitude,
        destinationLocation.latitude,
        destinationLocation.longitude);

    if(result.isNotEmpty){
      result.forEach((PointLatLng point){
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));
      });

      //push into bloc
      bloc.add(UserMapSetPolylines());
      //handle in if statement what happens after this point
    }
  }

  void updatePinOnMap(UserMapBloc bloc) async{
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude)
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));

    bloc.add(UserMapUpdatePinOnMap());
    //push event into bloc and handle what happens after this point.
  }
}