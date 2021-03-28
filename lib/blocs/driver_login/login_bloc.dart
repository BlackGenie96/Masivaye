import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../authentication/authentication.dart';
import '../../exceptions/exceptions.dart';
import '../../Data/services/authentication_service.dart';

class DriverLoginBloc extends Bloc<DriverLoginEvent, DriverLoginState>{
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  DriverLoginBloc(AuthenticationBloc authenticationBloc, AuthenticationService authenticationService) :
      assert(authenticationBloc != null),
      assert(authenticationService != null),
      _authenticationBloc = authenticationBloc,
      _authenticationService = authenticationService;

  @override
  DriverLoginState get initialState => DriverLoginInitial();

  @override
  Stream<DriverLoginState> mapEventToState(DriverLoginEvent event) async*{
    if(event is DriverLoginWithPhoneNumButtonPressed){
      yield* _mapDriverLoginToState(event);
    }

    if(event is DriverLoginRegisterButtonPressed){
      yield* _mapDriverLoginRegisterToState(event);
    }

    if(event is DriverPasswordObscure){
      yield DriverLoginLoading();
      yield DriverPasswordObscureSuccess();
    }

    if(event is DriverLoginWithFaceBook){
      //TODO : handle this
    }

    if(event is DriverLoginWithGooglePlus){
      //TODO : handle this
    }
  }

  Stream<DriverLoginState> _mapDriverLoginToState(DriverLoginWithPhoneNumButtonPressed event) async*{
    yield DriverLoginLoading();

    try{
      final driver = await _authenticationService.signInWithDriverPhoneAndPassword(event.phoneNum, event.password);
      if(driver != null){
        _authenticationBloc.add(DriverLoggedIn(driver: driver));
        yield DriverLoginSuccess();
      }else{
        yield DriverLoginFailure(error: "Something wrong occured.");
      }
    }on AuthenticationException catch(e){
      yield DriverLoginFailure(error:e.message);
    }catch(e){
      yield DriverLoginFailure(error: e ?? "An unknown error occured");
    }
  }

  Stream<DriverLoginState> _mapDriverLoginRegisterToState(DriverLoginRegisterButtonPressed event) async*{
    yield DriverLoginLoading();
    yield GoToDriverRegister();
  }
}