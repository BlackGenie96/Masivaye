import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class DriverMenuState extends Equatable{
  DriverMenuState();

  @override
  List<Object> get props => [];
}

class DriverMenuInitial extends DriverMenuState{}

class DriverMenuLoading extends DriverMenuState{}

class DriverMenuSuccess extends DriverMenuState{}

class DriverMenuFailure extends DriverMenuState{
  final String error;

  DriverMenuFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class DriverMenuMapsButtonSuccess extends DriverMenuState{}

class DriverMenuProfileButtonSuccess extends DriverMenuState{}

class DriverMenuLogoutButtonSuccess extends DriverMenuState{}

class DriverMenuViewRequestsState extends DriverMenuState{}

class DriverMenuTransactionsSuccess extends DriverMenuState{}

class DriverMenuChangeToOnlineSuccess extends DriverMenuState{
  final String status = "Online";

  @override
  List<Object> get props => [status];
}

class DriverMenuChangeToBusySuccess extends DriverMenuState{
  final String status = "Busy";

  @override
  List<Object> get props => [status];
}

class DriverMenuChangeToOfflineSuccess extends DriverMenuState{
  final String status = "Offline";

  @override
  List<Object> get props => [status];
}

