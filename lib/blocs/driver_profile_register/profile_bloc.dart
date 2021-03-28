import 'package:bloc/bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:masivaye/Data/services/services.dart';

class DriverProfileRegisterBloc extends Bloc<DriverProfileRegisterEvent, DriverProfileRegisterState>{

  final DriverRegisterService _registerService;

  DriverProfileRegisterBloc(DriverRegisterService registerService) :
      assert(registerService != null),
      _registerService = registerService;

  @override
  DriverProfileRegisterState get initialState => DriverProfileRegisterInitial();

  @override
  Stream<DriverProfileRegisterState> mapEventToState(DriverProfileRegisterEvent event) async*{
    if(event is DriverRegisterUploadButtonPressed){
      yield* _mapDriverRegisterButtonToState(event);
    }

    if(event is DriverProfileImageHeroClicked){
      yield* _mapDriverProfilePicToState(event);
    }

    if(event is CarProfileImageHeroClicked){
      yield* _mapCarProfilePicToState(event);
    }

    if(event is DriverProfileImageSelected){
      yield* _mapDriverProfileSelectedToState(event);
    }

    if(event is CarProfileImageSelected){
      yield* _mapCarProfileSelectedToState(event);
    }

    if(event is ChooseDriverProfileImage){
      yield DriverProfileRegisterLoading();
      yield ChooseDriverState();
    }

    if(event is ChooseCarProfileImage){
      yield DriverProfileRegisterLoading();
      yield ChooseCarState();
    }
  }

  Stream<DriverProfileRegisterState> _mapDriverRegisterButtonToState(DriverRegisterUploadButtonPressed event) async*{
    yield DriverProfileRegisterLoading();

    try{
      final finished = await _registerService.uploadDriverProfile(event.driverImage, event.carName, event.numberPlate, event.seats, event.carImage);
      if(finished != null){
        yield DriverProfileRegisterSuccess();
      }else{
        yield DriverProfileRegisterFailure(error: 'Error uploading driver profile 2');
      }
    }catch(err){
      throw Exception(err);
    }

  }

  Stream<DriverProfileRegisterState> _mapDriverProfilePicToState(DriverProfileImageHeroClicked event) async*{
    yield DriverProfileRegisterLoading();
    yield DriverProfileRegisterDriverHeroDisplay();
  }

  Stream<DriverProfileRegisterState> _mapCarProfilePicToState(CarProfileImageHeroClicked event) async* {
    yield DriverProfileRegisterLoading();
    yield DriverProfileRegisterCarHeroDisplay();
  }

  Stream<DriverProfileRegisterState> _mapDriverProfileSelectedToState(DriverProfileImageSelected event) async*{
    yield DriverProfileRegisterLoading();
    yield DriverImageSelected(driverImage: event.driverImage);
  }

  Stream<DriverProfileRegisterState> _mapCarProfileSelectedToState(CarProfileImageSelected event) async*{
    yield DriverProfileRegisterLoading();
    yield CarImageSelected(carImage: event.carImage);
  }
}