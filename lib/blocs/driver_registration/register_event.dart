import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverRegisterEvent extends Equatable{
  DriverRegisterEvent();

  @override
  List<Object> get props => [];
}

class DriverRegisterButtonPressed extends DriverRegisterEvent{
  final String firstName;
  final String lastName;
  final String idNum;
  final String phoneNum;
  final String password;

  DriverRegisterButtonPressed({@required this.firstName, @required this.lastName, @required this.idNum, @required this.phoneNum, @required this.password});

  @override
  List<Object> get props => [firstName, lastName, idNum, phoneNum, password];
}

class DriverRegisterLoginButtonPressed extends DriverRegisterEvent{}

class DriverRegisterObscureTextPassword extends DriverRegisterEvent{}

class DriverRegisterObscureTextConfirm extends DriverRegisterEvent{}