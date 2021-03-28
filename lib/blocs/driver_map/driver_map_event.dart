import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:masivaye/models/models.dart';

abstract class DriverMapEvent extends Equatable{
  DriverMapEvent();

  @override
  List<Object> get props => [];
}

class DriverMapShowCurrentRequests extends DriverMapEvent{}

class DriverMapShowRouteToCustomer extends DriverMapEvent{
  final int userId;

  DriverMapShowRouteToCustomer({this.userId});

  @override
  List<Object> get props => [userId];
}

class DriverMapShowCustomerInformation extends DriverMapEvent{
  final UserLocation user;

  DriverMapShowCustomerInformation({this.user});

  @override
  List<Object> get props => [user];
}

class DriverMapFindMyLocation extends DriverMapEvent{}