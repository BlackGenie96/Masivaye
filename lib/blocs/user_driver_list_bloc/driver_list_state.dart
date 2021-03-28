import 'package:masivaye/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverListState extends Equatable{

  @override
  List<Object> get props => [];
}

class DriverListInitial extends DriverListState{}

class DriverListLoading extends DriverListState{}

class DriverListSuccess extends DriverListState{}

class DriverListFailure extends DriverListState{}

class DriverListRadiusReloadSuccess extends DriverListState{
  final List<DriverLocation> driverList;

  DriverListRadiusReloadSuccess({@required this.driverList});

  @override
  List<Object> get props => [driverList];
}

class DriverListSelectedDriverSuccess extends DriverListState{
  final DriverLocation driver;
  final String quantity;

  DriverListSelectedDriverSuccess({@required this.driver, @required this.quantity});

  @override
  List<Object> get props => [driver];
}