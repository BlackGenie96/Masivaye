import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverRegisterState extends Equatable{
  DriverRegisterState();

  @override
  List<Object> get props => [];
}

class DriverRegisterInitial extends DriverRegisterState{}

class DriverRegisterLoading extends DriverRegisterState{}

class DriverRegisterSuccess extends DriverRegisterState{}

class DriverRegisterFailure extends DriverRegisterState{
  final String error;

  DriverRegisterFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class DriverGoToLogin extends DriverRegisterState{}

class DriverRegisterWithFaceBook extends DriverRegisterState{}

class DriverRegisterWithGoogle extends DriverRegisterState{}

class DriverRegisterObscurePasswordSuccess extends DriverRegisterState{}

class DriverRegisterObscureConfirmSuccess extends DriverRegisterState{}