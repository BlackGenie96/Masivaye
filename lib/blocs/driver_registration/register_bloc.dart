import 'package:bloc/bloc.dart';
import 'package:masivaye/blocs/authentication/authentication.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../exceptions/exceptions.dart';
import '../../Data/services/services.dart';

class DriverRegisterBloc extends Bloc<DriverRegisterEvent, DriverRegisterState>{

  final AuthenticationBloc _authenticationBloc;
  final DriverRegisterService _registerService;

  DriverRegisterBloc(AuthenticationBloc authenticationBloc, DriverRegisterService registerService) :
      assert(authenticationBloc != null),
      assert(registerService != null),
      _authenticationBloc = authenticationBloc,
      _registerService = registerService;

  @override
  DriverRegisterState get initialState => DriverRegisterInitial();

  @override
  Stream<DriverRegisterState> mapEventToState(DriverRegisterEvent event) async*{
    if(event is DriverRegisterButtonPressed){
      yield* _mapOnClickEventToState(event);
    }

    if(event is DriverRegisterLoginButtonPressed){
      yield* _mapDriverLoginClickToState(event);
    }

    if(event is DriverRegisterObscureTextPassword){
      yield DriverRegisterLoading();
      yield DriverRegisterObscurePasswordSuccess();
    }

    if(event is DriverRegisterObscureTextConfirm){
      yield DriverRegisterLoading();
      yield DriverRegisterObscureConfirmSuccess();
    }
  }

  Stream<DriverRegisterState> _mapOnClickEventToState(DriverRegisterButtonPressed event) async*{
    yield DriverRegisterLoading();

    try{
      final driver = await _registerService.registerDriver(event.firstName, event.lastName, event.idNum, event.phoneNum, event.password);
      if(driver != null){
        _authenticationBloc.add(DriverLoggedIn(driver: driver));
        yield DriverRegisterSuccess();
      }else{
        yield DriverRegisterFailure(error: 'Error registering the driver');
      }
    }on AuthenticationException catch(e){
      throw AuthenticationException(message: e.message);
    }catch(e){
      throw Exception('An unknown error occured.');
    }
  }

  Stream<DriverRegisterState> _mapDriverLoginClickToState(DriverRegisterLoginButtonPressed event) async*{
    yield DriverRegisterLoading();
    yield DriverGoToLogin();
  }
}