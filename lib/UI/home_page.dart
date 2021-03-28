import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/authentication/authentication.dart';
import 'package:masivaye/models/UserAuth.dart';

class HomePage extends StatelessWidget{
  final UserAuth user;

  const HomePage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBlock = BlocProvider.of<AuthenticationBloc>(context);
    return Scaffold(
      appBar:AppBar(
        title:Text('Home Page'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Welcome, ${user.firstName} ${user.lastName}',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 12.0,),
              FlatButton(
                textColor:Theme.of(context).primaryColor,
                child: Text('Logout'),
                onPressed: (){
                  //add userLogged out to authentication event stream
                  authBlock.add(UserLoggedOut());
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}