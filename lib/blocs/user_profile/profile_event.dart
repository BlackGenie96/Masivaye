import 'dart:io';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable{
  UserProfileEvent();

  @override
  List<Object> get props => [];
}

class ChooseProfileImage extends UserProfileEvent{}

class ProfileFinishedButtonPressed extends UserProfileEvent{
  final File pickedImage;

  ProfileFinishedButtonPressed({@required this.pickedImage});

  @override
  List<Object> get props => [pickedImage];
}

class ImageChosen extends UserProfileEvent{

  final File pickedImage;

  ImageChosen({@required this.pickedImage});

  @override
  List<Object> get props => [pickedImage];
}