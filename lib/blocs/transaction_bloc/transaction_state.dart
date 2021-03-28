import 'package:masivaye/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


abstract class TransactionState extends Equatable{
  @override
  List<Object> get props => [];
}

class TransactionStateInitial extends TransactionState{}

class TransactionStateLoading extends TransactionState{}

class TransactionStateSuccess extends TransactionState{}

class TransactionStateFailure extends TransactionState{}

class TransactionStateUserShowUserHero extends TransactionState{}

class TransactionStateUserShowDriverHero extends TransactionState{}

class TransactionStateViewMapSuccess extends TransactionState{
  final LatLng source;
  final LatLng destination;

  TransactionStateViewMapSuccess({this.source, this.destination});

  @override
  List<Object> get props => [source, destination];
}

class TransactionReceivedState extends TransactionState{
  final List<TransactionItem> transaction;
  TransactionReceivedState({@required this.transaction});

  @override
  List<Object> get props => [transaction];
}
