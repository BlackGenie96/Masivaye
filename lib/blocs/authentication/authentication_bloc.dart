import 'package:bloc/bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import '../../Data/services/services.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{
  final AuthenticationService _authenticationService;

  AuthenticationBloc(AuthenticationService authenticationService)
      : assert(authenticationService != null),
        _authenticationService = authenticationService;

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppLoaded){
      yield* _mapAppLoadedToState(event);
    }

    if(event is UserLoggedIn){
      yield* _mapUserLoggedInToState(event);
    }

    if(event is UserLoggedOut){
      yield* _mapUserLoggedOutToState(event);
    }

    if(event is DriverLoggedIn){
      yield* _mapDriverLoggedInToState(event);
    }

    if(event is DriverLoggedOut){
      yield* _mapDriverLoggedOutToState(event);
    }
  }

  Stream<AuthenticationState> _mapAppLoadedToState(AppLoaded event) async*{
    yield AuthenticationLoading(); // to display splash screen

    try{
      final currentUser = await _authenticationService.getCurrentUser();
      final currentDriver = await _authenticationService.getCurrentDriver();

      if(currentUser != null){
        yield AuthenticationAuthenticated(user: currentUser);
        return;
      }

      if(currentDriver != null){
        yield DriverAuthenticationAuthenticated(driver: currentDriver);
        return;
      }

      yield AuthenticationNotAuthenticated();

    }catch(e){
      yield AuthenticationFailure(message: e.message ?? "An unknown error has occured.");
    }
  }

  Stream<AuthenticationState> _mapUserLoggedInToState(UserLoggedIn event) async*{
    yield AuthenticationLoading();
    yield AuthenticationAuthenticated(user: event.user);
  }

  Stream<AuthenticationState> _mapDriverLoggedInToState(DriverLoggedIn event) async*{
    yield AuthenticationLoading();
    print('Driver has been logged in.');
    yield DriverAuthenticationAuthenticated(driver:event.driver);
  }

  Stream<AuthenticationState> _mapUserLoggedOutToState(UserLoggedOut event) async*{
    yield AuthenticationLoading();
    await _authenticationService.signOut();
    yield AuthenticationNotAuthenticated();
  }

  Stream<AuthenticationState> _mapDriverLoggedOutToState(DriverLoggedOut event) async*{
    yield AuthenticationLoading();
    await _authenticationService.driverSignOut();
    yield AuthenticationNotAuthenticated();
  }
}