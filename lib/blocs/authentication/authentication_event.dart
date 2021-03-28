import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import '../../models/models.dart';

abstract class AuthenticationEvent extends Equatable{
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

//fired up just after the app is launched.
class AppLoaded extends AuthenticationEvent{}

//fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent{
  final UserAuth user;

  UserLoggedIn({@required this.user});

  @override
  List<Object> get props => [user];
}

//fired when the user logs out
class UserLoggedOut extends AuthenticationEvent{}

//fired when the driver has successfully logged out
class DriverLoggedIn extends AuthenticationEvent{
  final Driver driver;

  DriverLoggedIn({@required this.driver});

  @override
  List<Object> get props => [driver];
}

class DriverLoggedOut extends AuthenticationEvent{}