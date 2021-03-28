import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverMenuEvent extends Equatable{
  DriverMenuEvent();

  @override
  List<Object> get props => [];
}

class DriverMenuMapsButtonPressed extends DriverMenuEvent{}

class DriverMenuProfileButtonPressed extends DriverMenuEvent{}

class DriverMenuLogoutButtonPressed extends DriverMenuEvent{}

class DriverMenuViewRequestsEvent extends DriverMenuEvent{}

class DriverMenuTransactions extends DriverMenuEvent{}

class DriverMenuChangeToOnline extends DriverMenuEvent{}

class DriverMenuChangeToBusy extends DriverMenuEvent{}

class DriverMenuChangeToOffline extends DriverMenuEvent{}