import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ChooseEvent extends Equatable{
  ChooseEvent();

  @override
  List<Object> get props => [];
}

class UserChoice extends ChooseEvent{}

class DriverChoice extends ChooseEvent{}