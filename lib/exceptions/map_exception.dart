class MapException implements Exception{
  final String message;

  MapException({this.message = "Unknown error occured."});
}