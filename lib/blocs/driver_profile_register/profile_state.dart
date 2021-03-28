import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class DriverProfileRegisterState extends Equatable{
  DriverProfileRegisterState();

  @override
  List<Object> get props => [];
}

//basic state handlers for driver profile register
class DriverProfileRegisterInitial extends DriverProfileRegisterState{}

class DriverProfileRegisterLoading extends DriverProfileRegisterState{}

class DriverProfileRegisterSuccess extends DriverProfileRegisterState{}

class DriverProfileRegisterFailure extends DriverProfileRegisterState{
  final String error;

  DriverProfileRegisterFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

//handles the displaying of hero images on click
class DriverProfileRegisterDriverHeroDisplay extends DriverProfileRegisterState{}

class DriverProfileRegisterCarHeroDisplay extends DriverProfileRegisterState{}

//indicates that the profile images have been selected and facilitates showing them on ui
class DriverImageSelected extends DriverProfileRegisterState{
  final File driverImage;

  DriverImageSelected({@required this.driverImage});

  @override
  List<Object> get props => [driverImage];
}

class CarImageSelected extends DriverProfileRegisterState{
  final File carImage;

  CarImageSelected({@required this.carImage});

  @override
  List<Object> get props => [carImage];
}

//handle the actual selecting of image for driver or car
class ChooseDriverState extends DriverProfileRegisterState{}

class ChooseCarState extends DriverProfileRegisterState{}