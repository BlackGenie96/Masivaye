import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverLoginEvent extends Equatable{
  DriverLoginEvent();

  @override
  List<Object> get props => [];
}

class DriverLoginWithPhoneNumButtonPressed extends DriverLoginEvent{
  final String phoneNum;
  final String password;

  DriverLoginWithPhoneNumButtonPressed({@required this.phoneNum, @required this.password});

  @override
  List<Object> get props => [phoneNum, password];
}

class DriverLoginRegisterButtonPressed extends DriverLoginEvent{}

class DriverLoginWithFaceBook extends DriverLoginEvent{}

class DriverLoginWithGooglePlus extends DriverLoginEvent{}

class DriverPasswordObscure extends DriverLoginEvent{}