import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/Data/services/services.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class DriverProfileRegister extends StatelessWidget{

  File _driverPic;
  File _carPic;
  bool _driverPicChosen = false;
  bool _carPicChosen = false;
  var _driverExt;
  var _carExt;
  final _carNameController = TextEditingController();
  final _numberPlateController = TextEditingController();
  final _seatsController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final DriverRegisterService _registerService = RepositoryProvider.of<DriverRegisterService>(context);
    void _pickDriverImage(DriverProfileRegisterBloc bloc) async{
      final imageSource = await showDialog<ImageSource>(
        context: context,
        builder : (context) => AlertDialog(
          title: Text('Select image source:'),
          actions: <Widget>[
            MaterialButton(
              child: Text('Camera'),
              onPressed : () => Navigator.pop(context, ImageSource.camera)
            ),
            MaterialButton(
              child: Text('Gallery'),
              onPressed: () => Navigator.pop(context, ImageSource.gallery)
            ),
          ]
        )
      );

      if(imageSource != null){
        final file = await ImagePicker.pickImage(source:imageSource);
        if(file != null){
          bloc.add(DriverProfileImageSelected(driverImage: file));
        }
      }
    }

    void _pickCarImage(DriverProfileRegisterBloc bloc) async{
      final imageSource = await showDialog<ImageSource>(
          context: context,
          builder : (context) => AlertDialog(
              title: Text('Select image source:'),
              actions: <Widget>[
                MaterialButton(
                    child: Text('Camera'),
                    onPressed : () => Navigator.pop(context, ImageSource.camera)
                ),
                MaterialButton(
                    child: Text('Gallery'),
                    onPressed: () => Navigator.pop(context, ImageSource.gallery)
                ),
              ]
          )
      );

      if(imageSource != null){
        final file = await ImagePicker.pickImage(source:imageSource);
        if(file != null){
          bloc.add(CarProfileImageSelected(carImage: file));
        }
      }
    }


    //methods to handle hero clicks
    void _goToDriverProfileImage(){
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => Theme(
            data : Theme.of(context).copyWith(
              scaffoldBackgroundColor: Colors.black
            ),
            child: Builder(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('Driver Profile'),
                  backgroundColor: Colors.black,
                  iconTheme : IconTheme.of(context).copyWith(
                    color : Colors.white,
                  ),
                ),
                body: Center(
                  child : Hero(
                    tag: 'driver_profile_image',
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: _driverPicChosen ? Image(image:FileImage(_driverPic)) : Image.asset('assets/camera.png')
                    ),
                  ),
                )
              ),
            )
          )
        )
      );
    }

    void _goToCarProfileImage(){
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => Theme(
                  data : Theme.of(context).copyWith(
                    scaffoldBackgroundColor: Colors.black
                  ),
                  child: Builder(
                    builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text('Car Image'),
                          backgroundColor: Colors.black,
                          iconTheme : IconTheme.of(context).copyWith(
                            color : Colors.white,
                          ),
                        ),
                        body: Center(
                          child : Hero(
                            tag: 'car_profile_image',
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: MediaQuery.of(context).size.height * 0.8,
                                child: _carPicChosen ? Image(image:FileImage(_carPic)) : Image.asset('assets/camera.png')
                            ),
                          ),
                        )
                    ),
                  )
              )
          )
      );
    }

    return BlocProvider<DriverProfileRegisterBloc>(
      create: (context) => DriverProfileRegisterBloc(_registerService),
      child: new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        child: new Builder(
          builder: (context) => new Scaffold(
            body: BlocListener<DriverProfileRegisterBloc, DriverProfileRegisterState>(
              listener:(context, state){

                if(state is DriverProfileRegisterSuccess){
                  Navigator.pop(context);
                }

                if(state is DriverProfileRegisterFailure){
                  _showError(context, state.error);
                }

                if(state is DriverProfileRegisterDriverHeroDisplay){
                  //call the driver hero
                  _goToDriverProfileImage();
                }

                if(state is DriverProfileRegisterCarHeroDisplay){
                  //call the car hero
                  _goToCarProfileImage();
                }

                if(state is ChooseDriverState){
                  _pickDriverImage(BlocProvider.of<DriverProfileRegisterBloc>(context));
                }

                if(state is ChooseCarState){
                  _pickCarImage(BlocProvider.of<DriverProfileRegisterBloc>(context));
                }

              },
              child: BlocBuilder<DriverProfileRegisterBloc, DriverProfileRegisterState>(
                builder: (context, state){
                  if(state is DriverProfileRegisterLoading){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if(state is DriverImageSelected){
                    _driverPic = state.driverImage;
                    _driverPicChosen = true;
                  }

                  if(state is CarImageSelected){
                    _carPic = state.carImage;
                    _carPicChosen = true;
                  }

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff8a00),Color(0xffff0000)]
                          ),
                        ),
                        alignment: Alignment.center,
                        width : MediaQuery.of(context).size.width,
                        child : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment : CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: MediaQuery.of(context).size.width*0.05),
                              alignment: Alignment.bottomLeft,
                              child : Text('Register(Driver)',style:TextStyle(fontSize:28,color:Colors.white,)),
                            ),
                            Container(
                              margin: EdgeInsets.only( left: MediaQuery.of(context).size.width*0.05),
                              alignment: Alignment.bottomLeft,
                              child : Text('Continued',style:TextStyle(fontSize: 18,color:Colors.white)),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(70),
                                  topRight: Radius.circular(70),
                                ),
                                color : Colors.white,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 10.0),
                                  GestureDetector(
                                    onTap: (){
                                      //go to hero on click
                                      BlocProvider.of<DriverProfileRegisterBloc>(context).add(DriverProfileImageHeroClicked());
                                    },
                                    child: Hero(
                                      tag : 'driver_profile_image',
                                      child : Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Color(0xffff0000), width : 5),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: _driverPicChosen ? FileImage(_driverPic) : AssetImage('assets/camera.png'),
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  RaisedButton(
                                    color: Color(0xffff0000),
                                    textColor: Colors.white,
                                    child : Text('Select Driver Profile', style:TextStyle(fontSize: 18)),
                                    padding : const EdgeInsets.all(16.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                    onPressed : (){
                                      BlocProvider.of<DriverProfileRegisterBloc>(context).add(ChooseDriverProfileImage());
                                    },
                                  ),
                                  SizedBox(height: 35.0),
                                  Container(
                                    width : MediaQuery.of(context).size.width * 0.8,
                                    height: 70,
                                    child: TextFormField(
                                      controller: _carNameController,
                                      decoration: InputDecoration(
                                          hintText : 'Car Model / Name',
                                          hintStyle : TextStyle(
                                            color: Color(0xffff0000),
                                          ),
                                          filled : true,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            borderSide: BorderSide(color: Color(0xffff0000), width : 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(30.0),
                                            borderSide : BorderSide(color: Color(0xffff0000), width: 0.8),
                                          )
                                      ),
                                      keyboardType : TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: 70,
                                    child: TextFormField(
                                      controller : _numberPlateController,
                                      decoration: InputDecoration(
                                        hintText : 'Number Plate',
                                        hintStyle: TextStyle(
                                            color: Color(0xffff0000)
                                        ),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide(color: Color(0xffff0000), width : 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide(color : Color(0xffff0000), width : 0.8),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    height: 70,
                                    child: TextFormField(
                                      controller: _seatsController,
                                      decoration: InputDecoration(
                                        hintText: 'Number of Passanger Seats',
                                        hintStyle: TextStyle(
                                          color: Color(0xffff0000),
                                        ),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide(color:Color(0xffff0000), width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: BorderSide(color: Color(0xffff0000), width: 0.8),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(height: 25.0),
                                  GestureDetector(
                                    onTap: (){
                                      //go to hero on click
                                      BlocProvider.of<DriverProfileRegisterBloc>(context).add(CarProfileImageHeroClicked());
                                    },
                                    child: Hero(
                                      tag : 'car_profile_image',
                                      child : Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color:Color(0xffff8a00), width: 5),
                                          ),
                                          child: CircleAvatar(
                                            backgroundImage: _carPicChosen ? FileImage(_carPic) : AssetImage('assets/camera.png'),
                                          )
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30.0),
                                  RaisedButton(
                                    color: Color(0xffff8a00),
                                    textColor: Colors.white,
                                    child : Text('Select Car Image', style:TextStyle(fontSize: 18)),
                                    padding : const EdgeInsets.all(16.0),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                    onPressed : (){
                                      BlocProvider.of<DriverProfileRegisterBloc>(context).add(ChooseCarProfileImage());
                                    },
                                  ),
                                  SizedBox(height: 15.0,),
                                  RaisedButton(
                                    color: Colors.black,
                                    textColor : Colors.white,
                                    child : Text('Finish',style: TextStyle(fontSize: 18)),
                                    padding: const EdgeInsets.all(16.0),
                                    onPressed: (){
                                      BlocProvider.of<DriverProfileRegisterBloc>(context).add(DriverRegisterUploadButtonPressed(
                                          driverImage: _driverPic,
                                          carName: _carNameController.text,
                                          numberPlate: _numberPlateController.text,
                                          carImage: _carPic,
                                          seats: _seatsController.text
                                      ));
                                    },
                                    shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  SizedBox(height: 25.0),
                                ],
                              ),
                            ),
                          ],
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

  void _showError(BuildContext context, String error){
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).errorColor,
        )
    );
  }
}