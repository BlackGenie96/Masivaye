import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable{
  LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginInWithIdNumButtonPressed extends LoginEvent{
  final String phoneNum;
  final String password;

  LoginInWithIdNumButtonPressed({@required this.phoneNum, @required this.password});

  @override
  List<Object> get props => [phoneNum, password];
}

class LoginRegisterButtonPressed extends LoginEvent{}

class LoginObscurePassword extends LoginEvent{}