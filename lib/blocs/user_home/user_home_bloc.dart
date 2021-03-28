import 'package:bloc/bloc.dart';
import 'user_home_event.dart';
import 'user_home_state.dart';
import 'package:masivaye/blocs/blocs.dart';

class UserHomeBloc extends Bloc<UserHomeEvent, UserHomeState>{

  final AuthenticationBloc _authenticationBloc;

  UserHomeBloc(AuthenticationBloc authenticationBloc) :
      assert(authenticationBloc != null),
      _authenticationBloc = authenticationBloc;

  @override
  UserHomeState get initialState => UserHomeInitial();

  @override
  Stream<UserHomeState> mapEventToState(UserHomeEvent event) async*{
    if(event is OpenGoogleMapButtonPressed){
      yield* _mapGoogleMapEventToState(event);
    }

    if(event is UserProfileButtonPressed){
      yield* _mapProfileButtonEventToState(event);
    }

    if(event is UserActivityButtonPressed){
      yield* _mapActivityButtonEventToState(event);
    }

    if(event is UserLogoutButtonPressed){
      yield* _mapLogoutEventToState(event);
    }

    if(event is UserProfileHeroClicked){
      yield UserHomeLoading();
      yield UserProfileHeroShow();
    }
  }

  Stream<UserHomeState> _mapGoogleMapEventToState(OpenGoogleMapButtonPressed event) async*{
    print('going first.');
    yield UserHomeLoading();
    yield UserHomeMapsButtonSuccess();
    print('going again.');
  }

  Stream<UserHomeState> _mapProfileButtonEventToState(UserProfileButtonPressed event) async*{
    yield UserHomeLoading();
    Future.delayed(Duration(milliseconds: 500));
    yield UserHomeProfileButtonSuccess();
  }

  Stream<UserHomeState> _mapActivityButtonEventToState(UserActivityButtonPressed event) async*{
    yield UserHomeLoading();
    Future.delayed(Duration(milliseconds: 500));
    yield UserHomeActivityButtonSuccess();
  }

  Stream<UserHomeState> _mapLogoutEventToState(UserLogoutButtonPressed event) async*{
    yield UserHomeLoading();
    Future.delayed(Duration(milliseconds: 500));
    _authenticationBloc.add(UserLoggedOut());
    yield UserLogoutButtonSuccess();
  }
}