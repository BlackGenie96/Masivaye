import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/Data/Repository/appstate.dart';
import 'package:masivaye/Data/services/received_request_service.dart';
import 'package:masivaye/UI/choose_page.dart';
import 'package:masivaye/UI/driver_forgot_password_page.dart';
import 'package:masivaye/UI/local_drivers_page.dart';
import 'package:masivaye/UI/splash_page.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/models/UserAuth.dart';
import 'package:provider/provider.dart';
import 'Data/services/services.dart';
import 'UI/pages.dart';
import 'package:masivaye/maps/map_page.dart';
import 'package:masivaye/maps/destination_map_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //injects the authentication service
    return RepositoryProvider<AuthenticationService>(
        create: (context){
          return AuthenticationService();
        },
        //injects the authentication bloc
        child: BlocProvider<AuthenticationBloc>(
            create: (context){
              final authService = RepositoryProvider.of<AuthenticationService>(context);
              return AuthenticationBloc(authService)..add(AppLoaded());
            },
            child: MaterialApp(
              routes: {
                '/choose_page' : (context) => ChoosePage(),
                '/user_login' : (context) => UserLogin(),
                '/home_page' : (context) => UserHome(),
                '/user_register' : (context) => RepositoryProvider<UserRegisterService>(
                  create: (context){
                    return UserRegisterService();
                  },
                  child: UserRegister(),
                ),
                '/user_profile_image' : (context) => RepositoryProvider<UserRegisterService>(
                  create:(context){
                    return UserRegisterService();
                  },
                  child: UserProfileImage()
                ),
                '/driver_login' : (context) => DriverLogin(),
                '/driver_register' : (context) => RepositoryProvider<DriverRegisterService>(
                  create: (context) => DriverRegisterService(),
                  child: DriverRegister()
                ),
                '/driver_profile_register' : (context) => RepositoryProvider<DriverRegisterService>(
                  create : (context) => DriverRegisterService(),
                  child: DriverProfileRegister()
                ),
                '/user_map_page' : (context) => RepositoryProvider<MapService>(
                  create: (context) => MapService(),
                  child: MapPage(),
                ),
                '/driver_map_page': (context) => RepositoryProvider<MapService>(
                  create: (context) => MapService(),
                  child: DriverMapPage()
                ),
                '/user_forgot_password' : (context) => DriverForgotPasswordInputPhone(),
                '/driver_forgot_password' : (context) => DriverForgotPasswordInputPhone(),
                //'/destination_map' : (context) => DestinationMapPage(),
                '/user_local_drivers_page': (context) => LocalDriversPage(),
                '/received_requests_page' : (context) => RepositoryProvider<ReceivedRequestService>(
                  create: (context) => ReceivedRequestService(),
                  child : ReceivedRequestPage(),
                ),
                '/user_transactions_page' : (context) => RepositoryProvider<TransactionService>(
                  create: (context) => TransactionService(),
                  child: UserTransactionsPage(),
                ),
                '/user_driver_list_page' : (context) => RepositoryProvider<UserDriverListService>(
                  create: (context) => UserDriverListService(),
                  child: UserDriverListPage(),
                ),
                '/driver_transactions_page' : (context) => RepositoryProvider<TransactionService>(
                  create: (context) => TransactionService(),
                  child: DriverTransactionsPage(),
                ),
              },
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.orange,
              ),
              home: BlocListener<AuthenticationBloc,AuthenticationState>(
                listener: (context, state){
                  if(state is AuthenticationAuthenticated){
                    //show home
                    return UserHome(
                      user: state.user,
                    );
                    //Navigator.pushNamed(context,'/home_page',arguments:UserAuth(id :state.user.id,userName: state.user.userName, identityNum : state.user.identityNum, phoneNum : state.user.phoneNum, isDriver:state.user.isDriver));
                  }

                  if(state is DriverAuthenticationAuthenticated){
                    return DriverHome(driver: state.driver);
                  }

                  //return SplashScreenPage();
                  //otherwise show login page
                  return ChoosePage();
                },
                child:BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder:(context, state){
                      if(state is AuthenticationAuthenticated){
                        //show home
                        return UserHome(
                          user: state.user,
                        );
                        //Navigator.pushNamed(context,'/home_page',arguments:UserAuth(id :state.user.id,userName: state.user.userName, identityNum : state.user.identityNum, phoneNum : state.user.phoneNum, isDriver:state.user.isDriver));
                      }

                      if(state is DriverAuthenticationAuthenticated){
                        return DriverHome(driver: state.driver);
                      }

                      //return SplashScreenPage();
                      //otherwise show login page
                      return ChoosePage();
                    }
                )
              )
        )
    ));
  }
}