import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:masivaye/models/models.dart';

abstract class DriverMapState extends Equatable{
  DriverMapState();

  @override
  List<Object> get props => [];
}

class DriverMapStateInitial extends DriverMapState{}

class DriverMapStateLoading extends DriverMapState{}

class DriverMapStateSuccess extends DriverMapState{}

class DriverMapStateFailure extends DriverMapState{
  final String error;

  DriverMapStateFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class DriverMapStateShowCurrentRequests extends DriverMapState{}

class DriverMapStateShowRouteToCustomer extends DriverMapState{
  final UserLocation customer;

  DriverMapStateShowRouteToCustomer({@required this.customer});

  @override
  List<Object> get props => [customer];
}

class DriverMapStateShowCustomerInfo extends DriverMapState{
  final UserLocation user;

  DriverMapStateShowCustomerInfo({this.user});

  @override
  List<Object> get props => [user];
}

class DriverMapStateFindMyLocation extends DriverMapState{}