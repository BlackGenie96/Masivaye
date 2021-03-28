import 'package:bloc/bloc.dart';
import 'package:masivaye/blocs/authentication/authentication.dart';
import 'register_event.dart';
import 'register_state.dart';
import '../../exceptions/exceptions.dart';
import '../../Data/services/services.dart';

class RegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState>{
  final AuthenticationBloc _authenticationBloc;
  final UserRegisterService _registerService;

  RegisterBloc(AuthenticationBloc authenticationBloc,UserRegisterService userRegisterService)
      : assert(userRegisterService != null),
        assert(authenticationBloc != null),
        _authenticationBloc = authenticationBloc,
        _registerService = userRegisterService;

  @override
  UserRegisterState get initialState => RegisterInitial();

  @override
  Stream<UserRegisterState> mapEventToState(UserRegisterEvent event) async*{
    if(event is RegisterButtonPressed){
      yield* _mapRegisterButtonPressedToState(event);
    }

    if(event is RegisterLoginButtonPressed){
      yield* _mapRegisterLoginToState(event);
    }

    if(event is UserRegisterObscurePassword){
      yield RegisterLoading();
      yield RegisterObscurePasswordSuccess();
    }

    if(event is UserRegisterObscureConfirm){
      yield RegisterLoading();
      yield RegisterObscureConfirmSuccess();
    }
  }

  Stream<UserRegisterState> _mapRegisterButtonPressedToState(RegisterButtonPressed event) async*{
    yield RegisterLoading();

    try{
      final user = await _registerService.registerUser(event.firstName, event.lastName, event.email, event.phoneNum, event.password);
      if(user != null){
        //push user logged in to auth
        _authenticationBloc.add(UserLoggedIn(user:user));
        yield RegisterSuccess();
      }else{
        yield RegisterFailure(error: "Could not register user. Problem in api.");
      }
    }on RegisterException catch(e){
      yield RegisterFailure(error: e.message);
    }on AuthenticationException catch(e){
      yield RegisterFailure(error: e.message);
    }catch(e){
      yield RegisterFailure(error: e.message ?? "An unknown error occured.");
    }
  }

  Stream<UserRegisterState> _mapRegisterLoginToState(RegisterLoginButtonPressed event) async*{
    yield RegisterLoading();

    Future.delayed(Duration(milliseconds: 500));
    yield GoToLogin();
  }
}