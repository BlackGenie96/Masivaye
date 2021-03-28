import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:masivaye/models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TransactionEvents extends Equatable{
  @override
  List<Object> get props => [];
}

class UserTransactionsReload extends TransactionEvents{}

class UserTransactionViewMap extends TransactionEvents{
  final LatLng source;
  final LatLng destination;

  UserTransactionViewMap({this.source, this.destination});

  @override
  List<Object> get props => [source, destination];
}

class UserTransactionUserHeroClick extends TransactionEvents{}

class UserTransactionDriverHeroClick extends TransactionEvents{}

class TransactionGetTransactions extends TransactionEvents{}

class TransactionGetTransactionsDriver extends TransactionEvents{}