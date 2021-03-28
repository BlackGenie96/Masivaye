import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UserRegisterState extends Equatable{
  UserRegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends UserRegisterState{}

class RegisterLoading extends UserRegisterState{}

class RegisterSuccess extends UserRegisterState{}

class RegisterFailure extends UserRegisterState{
  final String error;
  RegisterFailure({@required this.error});

  @override
  List<Object> get props =>[error];
}

class GoToLogin extends UserRegisterState{}

class RegisterWithFacebook extends UserRegisterState{}

class RegisterWithGoogle extends UserRegisterState{}

class RegisterObscurePasswordSuccess extends UserRegisterState{}

class RegisterObscureConfirmSuccess extends UserRegisterState{}