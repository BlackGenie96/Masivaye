import 'package:bloc/bloc.dart';
import 'package:masivaye/models/models.dart';
import 'package:masivaye/exceptions/exceptions.dart';
import 'driver_map_event.dart';
import 'driver_map_state.dart';
import 'package:masivaye/Data/services/services.dart';

class DriverMapBloc extends Bloc<DriverMapEvent, DriverMapState>{

  MapService _mapService;

  DriverMapBloc(MapService mapService) :
      assert(mapService != null),
      _mapService = mapService;

  @override
  DriverMapState get initialState => DriverMapStateInitial();

  @override
  Stream<DriverMapState> mapEventToState(DriverMapEvent event) async*{
    if(event is DriverMapShowCurrentRequests){
      yield* _mapCurrentRequestsToState(event);
    }

    if(event is DriverMapShowRouteToCustomer){
      yield* _mapShowRouteToCustomerToState(event);
    }

    if(event is DriverMapShowCustomerInformation){
      yield* _mapShowCustomerInfoToState(event);
    }

    if(event is DriverMapFindMyLocation){
      yield DriverMapStateLoading();
      yield DriverMapStateFindMyLocation();
    }
  }

  Stream<DriverMapState> _mapCurrentRequestsToState(DriverMapShowCurrentRequests event) async*{
    yield DriverMapStateLoading();
    //TODO: yet to really think throu after designing database.
  }

  Stream<DriverMapState> _mapShowRouteToCustomerToState(DriverMapShowRouteToCustomer event) async*{
    yield DriverMapStateLoading();

    final customer = await _mapService.getCustomerLocation(event.userId);
    if(customer != null){
      yield DriverMapStateShowRouteToCustomer(customer: customer);
    }else{
      yield DriverMapStateFailure(error : "Could not retrieve user location from server api.");
    }
  }

  Stream<DriverMapState> _mapShowCustomerInfoToState(DriverMapShowCustomerInformation event) async*{
    yield DriverMapStateLoading();
    yield DriverMapStateShowCustomerInfo(user: event.user);
  }
}