import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:masivaye/models/models.dart';

abstract class UserHomeState extends Equatable{
  UserHomeState();

  @override
  List<Object> get props => [];
}

class UserHomeInitial extends UserHomeState {}

class UserHomeLoading extends UserHomeState{}

class UserHomeMapsButtonSuccess extends UserHomeState{}

class UserHomeProfileButtonSuccess extends UserHomeState{}

class UserHomeActivityButtonSuccess extends UserHomeState{}

class UserLogoutButtonSuccess extends UserHomeState{}

class UserHomeFailure extends UserHomeState{
  final String error;

  UserHomeFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class UserProfileHeroShow extends UserHomeState{}