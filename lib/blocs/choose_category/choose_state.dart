import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class ChooseState extends Equatable{
  ChooseState();

  @override
  List<Object> get props => [];
}

class ChooseInitial extends ChooseState{}

class ChooseLoading extends ChooseState{}

class UserChosen extends ChooseState{}

class DriverChosen extends ChooseState{}

class ChoosingError extends ChooseState{}