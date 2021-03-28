import 'package:masivaye/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverListEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class DriverListEditRadiusReload extends DriverListEvent{
  final String radius;
  final String quantity;
  final int userId;

  DriverListEditRadiusReload({this.userId, this.radius, this.quantity});

  @override
  List<Object> get props => [userId, radius, quantity];
}

class DriverListSelectedDriver extends DriverListEvent{
  final DriverLocation driver;
  final String quantity;

  DriverListSelectedDriver({@required this.driver,@required this.quantity});

  @override
  List<Object> get props => [driver,quantity];
}