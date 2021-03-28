import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "AIzaSyDB9PVjYaDfB5VL2AArtMuCv3ffAZitN9I";

class LocationPath{
  Future getRouteCoordinates(LatLng l1, LatLng l2) async{
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$apiKey";

    http.Response response = await http.get(url);

    Map values = json.decode(response.body);

    print(values);
    return values["routes"][0]["overview_polyline"]["points"];
  }
}