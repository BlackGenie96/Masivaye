import 'package:bloc/bloc.dart';
import 'package:masivaye/Data/services/services.dart';
import 'driver_list_event.dart';
import 'driver_list_state.dart';

class UserDriverListBloc extends Bloc<UserDriverListEvent, UserDriverListState>{

  UserDriverListService _listService;

  UserDriverListBloc(UserDriverListService listService) :
      assert(listService != null),
      _listService = listService;

  @override
  UserDriverListState get initialState => UserDriverListInitial();

  @override
  Stream<UserDriverListState> mapEventToState(UserDriverListEvent event) async*{
    if(event is DriverItemClicked){
      yield UserDriverListLoading();
      yield UserDriverListItemClickSuccess();
    }

    if(event is DriverConfirmed){
      yield UserDriverListLoading();
      yield UserDriverListDriverSelected();
    }
  }
}