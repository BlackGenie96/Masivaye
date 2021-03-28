import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:masivaye/blocs/blocs.dart';

class ChoosePage extends StatelessWidget{

  ChoosePage({Key key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChooseBloc>(
      create: (context) => ChooseBloc(),
      child: BlocListener<ChooseBloc,ChooseState>(
          listener: (context, state){
            if(state is UserChosen){
              //user has been chosen, go to user login
              Navigator.pushNamed(context,'/user_login');
            }

            if(state is DriverChosen){
              Navigator.pushNamed(context,'/driver_login');
            }
          },
          child: Theme(
              data : Theme.of(context).copyWith(
                scaffoldBackgroundColor: Colors.white,
              ),
              child: Builder(
                  builder: (context) => Scaffold(
                      body: SafeArea(
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [Color(0xffff8a00),Color(0xffff0000)]
                                    )
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.contain,
                                            image: AssetImage('assets/masivaye_type1.png'),
                                          )
                                      ),
                                    ),
                                    SizedBox(height: 15.0),
                                    Text('Mas\'vaye. Let\'s go!',textAlign:TextAlign.center,style:TextStyle(fontStyle: FontStyle.italic,color:Colors.white,),),
                                    SizedBox(height: 45.0),
                                    GestureDetector(
                                      onTap:(){
                                        BlocProvider.of<ChooseBloc>(context).add(UserChoice());
                                      },
                                      child:Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          color: Colors.white,
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('I need a ride', style:TextStyle(color: Color(0xffff0000))),
                                            Icon(Icons.arrow_forward, color:Color(0xffff0000))
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 25.0),
                                    GestureDetector(
                                      onTap:(){
                                        BlocProvider.of<ChooseBloc>(context).add(DriverChoice());
                                      },
                                      child:Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20.0),
                                          border: Border.all(color: Colors.white, width: 1.5),
                                        ),
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        height: 50,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('I\'m a driver', style: TextStyle(color: Colors.white,)),
                                            Icon(Icons.arrow_forward, color: Colors.white,)
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15.0)
                                  ],
                                )
                            ),
                          )
                      )
                  )
              )
          )
      ),
    );
  }
}