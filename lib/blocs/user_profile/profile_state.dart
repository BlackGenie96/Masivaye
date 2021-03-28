import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class UserProfileState extends Equatable{
  UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState{}

class UserProfileLoading extends UserProfileState{}

class UserProfileSuccess extends UserProfileState{}

class UserProfileFailure extends UserProfileState{
  final String error;
  UserProfileFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class UserProfileImageSelected extends UserProfileState{
  final File pickedImage;
  UserProfileImageSelected({@required this.pickedImage});

  @override
  List<Object> get props => [pickedImage];
}

class UserChooseImage extends UserProfileState{}