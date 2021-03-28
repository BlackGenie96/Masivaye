import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/authentication/authentication.dart';
import 'package:masivaye/blocs/user_home/user_home.dart';
import 'package:masivaye/models/models.dart';
import 'package:masivaye/Data/services/services.dart';
import 'package:masivaye/maps/map_page.dart';

class UserHome extends StatelessWidget{
  final UserAuth user;

  UserHome({@required this.user});

  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);

    void viewProfileHero(){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => new Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            child: new Builder(
              builder: (context) => new Scaffold(
                appBar:AppBar(
                  title: Text('Profile Picture',style: TextStyle(color: Colors.white,)),
                  backgroundColor: Colors.black,
                  iconTheme: IconTheme.of(context).copyWith(
                    color: Colors.white,
                  ),
                ),
                body: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height : MediaQuery.of(context).size.height * 0.7,
                    child: user.profileImageUrl == null ? null : Image.network(user.profileImageUrl),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return BlocProvider<UserHomeBloc>(
      create: (context) => UserHomeBloc(authBloc),
      child : new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        child : new Builder(
          builder: (context) => new Scaffold(
            body: BlocListener<UserHomeBloc, UserHomeState>(
              listener: (context, state){

                if(state is UserHomeMapsButtonSuccess){
                  Navigator.pushNamed(context,'/user_local_drivers_page');
                }

                if(state is UserProfileHeroShow){
                  viewProfileHero();
                }

                if(state is UserHomeActivityButtonSuccess){
                  Navigator.pushNamed(context, '/user_transactions_page');
                }

                if(state is UserLogoutButtonSuccess){
                  Navigator.pushReplacementNamed(context,'/');
                }

                if(state is UserHomeFailure){

                }

              },
              child: BlocBuilder<UserHomeBloc, UserHomeState>(
                builder: (context, state){
                  if(state is UserHomeLoading){
                    return Center(
                      child : CircularProgressIndicator()
                    );
                  }

                  return SafeArea(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Container(
                          alignment:Alignment.center,
                          decoration : BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xffff8a00), Color(0xffff0000)]
                            )
                          ),
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment : CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child : Text('Welcome,',style:TextStyle(color:Colors.white,fontSize:15,fontWeight:FontWeight.w300),textAlign:TextAlign.start),
                              ),
                              SizedBox(height: 2.0),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 15.0
                                ),
                                child: Text('Menu',style:TextStyle(color:Colors.white,fontSize:35,fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 10),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 15.0,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: (){
                                        BlocProvider.of<UserHomeBloc>(context).add(UserProfileHeroClicked());
                                      },
                                      child: Hero(
                                        tag: 'user_profile_image_hero',
                                        child:Container(
                                          width: 80,
                                          height: 80,
                                          child: CircleAvatar(
                                            backgroundImage: user.profileImageUrl == null ? null : NetworkImage(user.profileImageUrl),
                                          )
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          '${user.firstName} ${user.lastName}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Text(
                                          '${user.email}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ),
                              SizedBox(height: 25.0),
                              GestureDetector(
                                onTap:(){
                                  print('Go to maps activity.');
                                  //Navigator.pushNamed(context,'/map_page');
                                  BlocProvider.of<UserHomeBloc>(context).add(OpenGoogleMapButtonPressed());
                                },
                                child : Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left : 15.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.location_on,color: Color(0xffff0000)),
                                      SizedBox(width: 2.0),
                                      Text(
                                        'Find Local Drivers',
                                        textAlign: TextAlign.center,
                                        style:TextStyle(
                                          color: Color(0xffff0000),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius : BorderRadius.circular(50.0),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.0),
                              GestureDetector(
                                onTap:(){
                                  print('Go to activity page.');
                                  BlocProvider.of<UserHomeBloc>(context).add(UserActivityButtonPressed());
                                },
                                child : Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.history,color:Color(0xffff0000)),
                                      SizedBox(width: 2.0),
                                      Text(
                                        'View My Activity',
                                        textAlign: TextAlign.center,
                                        style:TextStyle(
                                          color:Color(0xffff0000),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    color:Colors.white,
                                    borderRadius : BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: 25.0),
                              GestureDetector(
                                onTap:(){
                                  print('Logout');
                                  BlocProvider.of<UserHomeBloc>(context).add(UserLogoutButtonPressed());
                                },
                                child : Container(
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left :15.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.arrow_forward,color: Color(0xffff0000)),
                                      SizedBox(width: 2.0),
                                      Text(
                                          'Logout',
                                          textAlign: TextAlign.center,
                                          style:TextStyle(
                                            color:Color(0xffff0000),
                                          )
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius : BorderRadius.circular(50.0),
                                      color:Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}