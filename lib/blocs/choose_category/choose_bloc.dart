import 'package:bloc/bloc.dart';
import 'choose_event.dart';
import 'choose_state.dart';

class ChooseBloc extends Bloc<ChooseEvent, ChooseState>{

  ChooseBloc();

  @override
  ChooseState get initialState => ChooseInitial();

  Stream<ChooseState> mapEventToState(ChooseEvent event) async*{
    if(event is UserChoice){
      yield ChooseLoading();
      yield UserChosen();
    }

    if(event is DriverChoice){
      yield ChooseLoading();
      yield DriverChosen();
    }
  }
}