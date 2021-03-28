import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class DriverProfileRegisterEvent extends Equatable{
  DriverProfileRegisterEvent();

  @override
  List<Object> get props => [];
}

//for displaying hero on click
class DriverProfileImageHeroClicked extends DriverProfileRegisterEvent{}

class CarProfileImageHeroClicked extends DriverProfileRegisterEvent{}

//for uploading data to server api
class DriverRegisterUploadButtonPressed extends DriverProfileRegisterEvent{
  final File driverImage;
  final String carName;
  final String numberPlate;
  final String seats;
  final File carImage;

  DriverRegisterUploadButtonPressed({@required this.driverImage,@required this.carName, @required this.numberPlate, @required this.seats, @required this.carImage});

  @override
  List<Object> get props => [driverImage, carName, numberPlate, seats, carImage];
}

//indicates that the profile has been selected form gallery or camera
class DriverProfileImageSelected extends DriverProfileRegisterEvent{
  final File driverImage;

  DriverProfileImageSelected({@required this.driverImage});

  @override
  List<Object> get props => [driverImage];
}

class CarProfileImageSelected extends DriverProfileRegisterEvent{
  final File carImage;

  CarProfileImageSelected({@required this.carImage});

  @override
  List<Object> get props => [carImage];
}

//handles the events for actually selecting the images on click
class ChooseDriverProfileImage extends DriverProfileRegisterEvent{}

class ChooseCarProfileImage extends DriverProfileRegisterEvent{}