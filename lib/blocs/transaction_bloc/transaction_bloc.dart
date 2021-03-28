import 'package:bloc/bloc.dart';
import 'transaction_events.dart';
import 'transaction_state.dart';
import 'package:masivaye/models/models.dart';
import 'package:masivaye/Data/services/services.dart';

class TransactionsBloc extends Bloc<TransactionEvents,TransactionState>{

  final TransactionService _transactionService;

  TransactionsBloc(TransactionService transactionService) :
      assert(transactionService != null),
      _transactionService = transactionService;

  @override
  TransactionState get initialState => TransactionStateInitial();

  @override
  Stream<TransactionState> mapEventToState(TransactionEvents event) async*{
    //handle user events first.
    if(event is UserTransactionViewMap){
      yield* _mapViewMapToState(event);
    }

    if(event is UserTransactionUserHeroClick){
      yield* _mapHeroClickToState(event);
    }

    if(event is UserTransactionDriverHeroClick){
      yield* _mapHeroDriverClickToState(event);
    }

    if(event is TransactionGetTransactions){
      yield* _mapGetterToState(event);
    }

    if(event is TransactionGetTransactionsDriver){
      yield* _mapDriverGetterToState(event);
    }
  }

  Stream<TransactionState> _mapViewMapToState(UserTransactionViewMap event) async*{
    yield TransactionStateLoading();
    yield TransactionStateViewMapSuccess(source: event.source, destination: event.destination);
  }

  Stream<TransactionState> _mapHeroClickToState(UserTransactionUserHeroClick event) async*{
    yield TransactionStateLoading();
    yield TransactionStateUserShowUserHero();
  }

  Stream<TransactionState> _mapHeroDriverClickToState(UserTransactionDriverHeroClick event) async*{
    yield TransactionStateLoading();
    yield TransactionStateUserShowDriverHero();
  }

  Stream<TransactionState> _mapGetterToState(TransactionGetTransactions event) async*{
    yield TransactionStateLoading();

    final list = await _transactionService.getUserTransactions();

    print(list);
    if(list != null){
      yield TransactionReceivedState(transaction: list);
    }else{
      yield TransactionStateFailure();
    }
  }

  Stream<TransactionState> _mapDriverGetterToState(TransactionGetTransactionsDriver event) async*{
    yield TransactionStateLoading();

    final list = await _transactionService.getDriverTransactions();

    if(list != null){
      print(list);
      yield TransactionReceivedState(transaction: list);
    }else{
      yield TransactionStateFailure();
    }
  }
}