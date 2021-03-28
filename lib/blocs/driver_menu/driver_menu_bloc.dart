import 'package:bloc/bloc.dart';
import 'driver_menu_events.dart';
import 'driver_menu_state.dart';
import 'package:masivaye/blocs/blocs.dart';

class DriverMenuBloc extends Bloc<DriverMenuEvent, DriverMenuState>{

  AuthenticationBloc _authBloc;

  DriverMenuBloc(AuthenticationBloc authBloc) :
      assert(authBloc != null),
      _authBloc = authBloc;

  @override
  DriverMenuState get initialState => DriverMenuInitial();

  @override
  Stream<DriverMenuState> mapEventToState(DriverMenuEvent event) async*{
    if(event is DriverMenuMapsButtonPressed){
      yield* _mapMapsEventToState(event);
    }

    if(event is DriverMenuProfileButtonPressed){
      yield* _mapProfileEventToState(event);
    }

    if(event is DriverMenuLogoutButtonPressed){
      yield* _mapLogoutEventToState(event);
    }

    if(event is DriverMenuViewRequestsEvent){
      yield DriverMenuLoading();
      yield DriverMenuViewRequestsState();
    }

    if(event is DriverMenuTransactions){
      yield DriverMenuLoading();
      yield DriverMenuTransactionsSuccess();
    }

    if(event is DriverMenuChangeToOnline){
      yield DriverMenuLoading();
      yield DriverMenuChangeToOnlineSuccess();
    }

    if(event is DriverMenuChangeToBusy){
      yield DriverMenuLoading();
      yield DriverMenuChangeToBusySuccess();
    }

    if(event is DriverMenuChangeToOffline){
      yield DriverMenuLoading();
      yield DriverMenuChangeToOfflineSuccess();
    }
  }

  Stream<DriverMenuState> _mapMapsEventToState(DriverMenuMapsButtonPressed event) async*{
    yield DriverMenuLoading();
    Future.delayed(Duration(milliseconds : 500));
    yield DriverMenuMapsButtonSuccess();
  }

  Stream<DriverMenuState> _mapProfileEventToState(DriverMenuProfileButtonPressed event) async*{
    yield DriverMenuLoading();
    Future.delayed(Duration(milliseconds: 500));
    yield DriverMenuProfileButtonSuccess();
  }

  Stream<DriverMenuState> _mapLogoutEventToState(DriverMenuLogoutButtonPressed event) async*{
    yield DriverMenuLoading();
    _authBloc.add(DriverLoggedOut());
    print('driver logging out');
    yield DriverMenuLogoutButtonSuccess();
  }

}