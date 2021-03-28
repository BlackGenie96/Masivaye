import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:masivaye/models/models.dart';

abstract class UserHomeEvent extends Equatable{
  @override
  List<Object> get props => [];
}

class OpenGoogleMapButtonPressed extends UserHomeEvent{}

class UserProfileButtonPressed extends UserHomeEvent{}

class UserActivityButtonPressed extends UserHomeEvent{}

class UserLogoutButtonPressed extends UserHomeEvent{}

class UserProfileHeroClicked extends UserHomeEvent{}