import 'package:bloc/bloc.dart';
import 'login_event.dart';
import 'login_state.dart';
import '../authentication/authentication.dart';
import '../../exceptions/exceptions.dart';
import '../../Data/services/services.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>{
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  LoginBloc(AuthenticationBloc authenticationBloc, AuthenticationService authenticationService)
      : assert(authenticationBloc != null),
        assert(authenticationService != null),
        _authenticationBloc = authenticationBloc,
        _authenticationService = authenticationService;

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if(event is LoginInWithIdNumButtonPressed){
      yield* _mapLoginWithIdNumToState(event);
    }

    if(event is LoginRegisterButtonPressed){
      yield* _mapLoginRegisterPressedToState(event);
    }

    if(event is LoginObscurePassword){
      yield LoginLoading();
      print('password obscured');
      yield LoginObscurePasswordSuccess();
    }
  }

  Stream<LoginState> _mapLoginWithIdNumToState(LoginInWithIdNumButtonPressed event) async*{
    yield LoginLoading();
    try{
      final user = await _authenticationService.signInWithPhoneAndPassword(event.phoneNum, event.password);
      if(user != null){
        //push new authentication event
        _authenticationBloc.add(UserLoggedIn(user:user));
        yield LoginSuccess();
      }else{
        yield LoginFailure(error: 'Something wrong occured');
      }
    }on AuthenticationException catch(e){
      yield LoginFailure(error : e.message);
    }catch(e){
      yield LoginFailure(error : e.message ?? "An unknown error occured.");
    }
  }

  Stream<LoginState> _mapLoginRegisterPressedToState(LoginRegisterButtonPressed event)async*{
    yield LoginLoading();
    yield GoToRegister();
  }
}