import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UserRegisterEvent extends Equatable{
  UserRegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterButtonPressed extends UserRegisterEvent{
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNum;
  final String password;

  RegisterButtonPressed({@required this.firstName, @required this.lastName, @required this.email, @required this.phoneNum, @required this.password});

  @override
  List<Object> get props => [firstName, lastName, email, phoneNum, password];
}

class RegisterLoginButtonPressed extends UserRegisterEvent{}

class UserRegisterObscurePassword extends UserRegisterEvent{}

class UserRegisterObscureConfirm extends UserRegisterEvent{}