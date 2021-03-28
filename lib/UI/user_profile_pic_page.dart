import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/Data/services/user_register_service.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class UserProfileImage extends StatelessWidget{

  File _pickedImage;
  bool _imageChosen = false;
  var ext;

  @override
  Widget build(BuildContext context) {
    final UserRegisterService registerService = RepositoryProvider.of<UserRegisterService>(context);

    void _pickImage(UserProfileImageBloc bloc) async{
      final imageSource = await showDialog<ImageSource>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Select image source: '),
            actions : <Widget>[
              MaterialButton(
                child: Text('Camera'),
                onPressed: () => Navigator.pop(context, ImageSource.camera)
              ),
              MaterialButton(
                child: Text('Gallery'),
                onPressed: ()=> Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          )
      );

      if(imageSource != null){
        final file = await ImagePicker.pickImage(source: imageSource);
        if(file != null){
          bloc.add(ImageChosen(pickedImage: file));
        }
      }
    }

    //method to handle hero
    void _goToProfile(){
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Theme(
            data: Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black,
            ),
            child: new Builder(
              builder: (context) => Scaffold(
                appBar:AppBar(
                  backgroundColor: Colors.black,
                  iconTheme:IconTheme.of(context).copyWith(
                    color: Colors.white,
                  ),
                  title: Text('Profile Picture')
                ),
                body: Center(
                  child: Hero(
                    tag: 'user_profile_image',
                    child: Container(
                      width : MediaQuery.of(context).size.width *0.95,
                      height : MediaQuery.of(context).size.height *0.8,
                      child: _imageChosen ? Image(image:FileImage(_pickedImage)) : Image.asset('assets/camera.png'),
                    ),
                  )
                ),
              ),
            ),
          ),
        )
      );
    }

    return BlocProvider<UserProfileImageBloc>(
      create: (context) => UserProfileImageBloc(registerService),
      child: new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        child: new Builder(
          builder: (context) => new Scaffold(
            body: BlocListener<UserProfileImageBloc, UserProfileState>(
              listener: (context, state){
                if(state is UserChooseImage){
                  _pickImage(BlocProvider.of<UserProfileImageBloc>(context));
                }

                if(state is UserProfileSuccess){
                  print('go to home');
                  Navigator.pop(context);
                }

                if(state is UserProfileFailure){
                  _showError(context, state.error);
                }
              },
              child : BlocBuilder<UserProfileImageBloc, UserProfileState>(
                builder: (context, state){

                  if(state is UserProfileLoading){
                    return Center(child: CircularProgressIndicator());
                  }

                  if(state is UserProfileImageSelected){
                    _pickedImage = state.pickedImage;
                    _imageChosen = true;
                  }

                  return SafeArea(
                    child: Center(
                      child:SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: 40.0),
                              GestureDetector(
                                onTap:(){
                                  print('Go to profile Image hero');
                                  _goToProfile();
                                },
                                child: Hero(
                                  tag: 'user_profile_image',
                                  child: Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Color(0xffff0000), width: 5),
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: _imageChosen ? FileImage(_pickedImage) : AssetImage('assets/camera.png'),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 35.0),
                              RaisedButton(
                                  color:Color(0xffff0000),
                                  textColor: Colors.white,
                                  padding : const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                  child: Text('Select Image'),
                                  onPressed: (){
                                    BlocProvider.of<UserProfileImageBloc>(context).add(ChooseProfileImage());
                                  }
                              ),
                              SizedBox(height: 25.0),
                              RaisedButton(
                                  color:Colors.black,
                                  textColor: Colors.white,
                                  padding : const EdgeInsets.all(16.0),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                  child: Text('Finish'),
                                  onPressed: (){
                                    BlocProvider.of<UserProfileImageBloc>(context).add(ProfileFinishedButtonPressed(pickedImage: _pickedImage));
                                  }
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, String error){
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).errorColor,
        )
    );
  }
}