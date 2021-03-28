import 'package:bloc/bloc.dart';
import 'driver_list_event.dart';
import 'driver_list_state.dart';
import 'package:masivaye/Data/services/services.dart';

class DriverListBloc extends Bloc<DriverListEvent, DriverListState>{

  final UserDriverListService _service;

  DriverListBloc(UserDriverListService service) :
      assert(service != null),
      _service = service;

  @override
  DriverListState get initialState => DriverListInitial();

  @override
  Stream<DriverListState> mapEventToState(DriverListEvent event) async*{
    if(event is DriverListEditRadiusReload){
      yield* _mapRadiusEditToState(event);
    }

    if(event is DriverListSelectedDriver){
      yield* _mapSelectedDriverToState(event);
    }
  }

  Stream<DriverListState> _mapSelectedDriverToState(DriverListSelectedDriver event)async*{
    yield DriverListLoading();
    yield DriverListSelectedDriverSuccess(driver: event.driver, quantity: event.quantity);
  }

  Stream<DriverListState> _mapRadiusEditToState(DriverListEditRadiusReload event) async*{
    yield DriverListLoading();

    try{
      final driverList = await _service.getLocalDrivers(radius: event.radius, quantity: event.quantity);

      if(driverList != null && driverList.isNotEmpty){
        yield DriverListRadiusReloadSuccess(driverList: driverList);
      }else{
        yield DriverListFailure();
      }
    }catch(err){
      throw Exception(err);
    }
  }
}