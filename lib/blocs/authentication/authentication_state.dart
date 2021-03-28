import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';

abstract class AuthenticationState extends Equatable{
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState{}

class AuthenticationLoading extends AuthenticationState{}

class AuthenticationNotAuthenticated extends AuthenticationState{}

class AuthenticationAuthenticated extends AuthenticationState{
  final UserAuth user;

  AuthenticationAuthenticated({@required this.user});

  @override
  List<Object> get props => [user];
}

class DriverAuthenticationAuthenticated extends AuthenticationState{
  final Driver driver;

  DriverAuthenticationAuthenticated({@required this.driver});
  @override
  List<Object> get props => [driver];
}

class AuthenticationFailure extends AuthenticationState{
  final String message;

  AuthenticationFailure({@required this.message});

  @override
  List<Object> get props => [message];
}


