import 'package:bloc/bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../Data/services/user_register_service.dart';

class UserProfileImageBloc extends Bloc<UserProfileEvent, UserProfileState>{

  final UserRegisterService _registerService;

  UserProfileImageBloc(UserRegisterService registerService) :
      assert(registerService != null),
      _registerService = registerService;

  @override
  UserProfileState get initialState => UserProfileInitial();

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async*{
    if(event is ChooseProfileImage){
      yield* _mapChooseEventToState(event);
    }

    if(event is ProfileFinishedButtonPressed){
      yield* _mapPressedButtonToState(event);
    }

    if(event is ImageChosen){
      yield* _mapImageChosenToState(event);
    }
  }

  Stream<UserProfileState> _mapChooseEventToState(ChooseProfileImage event) async*{
    yield UserProfileLoading();
    yield UserChooseImage();
  }

  Stream<UserProfileState> _mapPressedButtonToState(ProfileFinishedButtonPressed event) async*{
    yield UserProfileLoading();

    //initiate api communication.
    try{
      final url = await _registerService.uploadProfileImage(event.pickedImage);
      if(url != null){
        //yield upload success state to bloc
        yield UserProfileSuccess();
      }else{
        yield UserProfileFailure(error: "Could not upload profile image");
      }
    }catch(err){
      throw Exception(err);
    }
  }

  Stream<UserProfileState> _mapImageChosenToState(ImageChosen event) async*{
    yield UserProfileLoading();

    final image = event.pickedImage;
    if(image != null){
      yield UserProfileImageSelected(pickedImage: image);
    }
  }
}