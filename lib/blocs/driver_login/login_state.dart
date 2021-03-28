import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DriverLoginState extends Equatable{
  DriverLoginState();

  @override
  List<Object> get props => [];
}

class DriverLoginInitial extends DriverLoginState{}

class DriverLoginLoading extends DriverLoginState{}

class DriverLoginSuccess extends DriverLoginState{}

class DriverLoginFailure extends DriverLoginState{
  final String error;

  DriverLoginFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class GoToDriverRegister extends DriverLoginState{}

class DriverPasswordObscureSuccess extends DriverLoginState{}