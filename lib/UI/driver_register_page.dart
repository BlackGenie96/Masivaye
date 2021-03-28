import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/Data/services/services.dart';

class DriverRegister extends StatelessWidget{

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _idNumController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureTextPassword = true;
  bool _obscureTextConfirm = true;

  @override
  Widget build(BuildContext context) {
    final DriverRegisterService _registerService = RepositoryProvider.of<DriverRegisterService>(context);
    final AuthenticationBloc _authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<DriverRegisterBloc>(
      create : (context) => DriverRegisterBloc(_authBloc, _registerService),
      child: new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        child: new Builder(
          builder: (context) => Scaffold(
            body: BlocListener<DriverRegisterBloc,DriverRegisterState>(
              listener: (context, state){
                if(state is DriverRegisterSuccess){
                  //go to driver profile
                  Navigator.pushReplacementNamed(context, '/driver_profile_register');
                }

                if(state is DriverRegisterFailure){
                  _showError(context, state.error);
                }

                if(state is DriverGoToLogin){
                  Navigator.pushReplacementNamed(context, '/driver_login');
                }
              },
              child: BlocBuilder<DriverRegisterBloc, DriverRegisterState>(
                builder: (context, state){
                  if(state is DriverRegisterLoading){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                    //Navigator.pushReplacementNamed(context, '/driver_profile_register');
                  }

                  if(state is DriverRegisterObscurePasswordSuccess){
                    _obscureTextPassword = !_obscureTextPassword;
                  }


                  if(state is DriverRegisterObscureConfirmSuccess){
                    _obscureTextConfirm = !_obscureTextConfirm;
                  }

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff8a00), Color(0xffff0000)],
                          ),
                        ),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: MediaQuery.of(context).size.width*0.05),
                              alignment: Alignment.bottomLeft,
                              child : Text('Hello',style:TextStyle(fontSize:18,color:Colors.white,)),
                            ),
                            Container(
                              margin: EdgeInsets.only( left: MediaQuery.of(context).size.width*0.05),
                              alignment: Alignment.bottomLeft,
                              child : Text('Register (Driver)',style:TextStyle(fontSize: 28,color:Colors.white)),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(70),
                                    topRight: Radius.circular(70)
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child : Column(
                                children: <Widget>[
                                  SizedBox(height: 15),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.7,
                                    height: 70,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText : 'Firstname',
                                        hintStyle: TextStyle(
                                            color: Color(0xffff0000),
                                        ),
                                        filled : true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color: Color(0xffff0000), width: 0.8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(width : 2),
                                        ),
                                      ),
                                      controller: _firstNameController,
                                      keyboardType: TextInputType.text,
                                      autocorrect: false,
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                      child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText: 'Lastname',
                                            filled : true,
                                            hintStyle: TextStyle(
                                                color : Color(0xffff0000)
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              borderSide : BorderSide(color: Color(0xffff0000), width: 2),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius :BorderRadius.circular(20.0),
                                              borderSide: BorderSide(color:Color(0xffff0000), width: 0.8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              borderSide: BorderSide(width : 2),
                                            ),
                                          ),
                                          controller : _lastNameController,
                                          keyboardType: TextInputType.text,
                                          autocorrect : false
                                      ),
                                      width : MediaQuery.of(context).size.width *0.7,
                                      height : 70
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Identity Number (ID)',
                                        filled : true,
                                        hintStyle: TextStyle(
                                            color : Color(0xffff0000)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide : BorderSide(color: Color(0xffff0000), width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius :BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color:Color(0xffff0000), width : 0.8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(width : 2),
                                        ),
                                      ),
                                      controller : _idNumController,
                                      keyboardType: TextInputType.number,
                                    ),
                                    width : MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText: 'Phone Number',
                                        filled : true,
                                        hintStyle: TextStyle(
                                            color : Color(0xffff0000)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide : BorderSide(color: Color(0xffff0000), width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius :BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color:Color(0xffff0000), width: 0.8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(width : 2),
                                        ),
                                      ),
                                      controller : _phoneNumController,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        hintText : 'Password',
                                        filled : true,
                                        hintStyle: TextStyle(
                                            color : Color(0xffff0000)
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide : BorderSide(color:Color(0xffff0000), width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius :BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color:Color(0xffff0000), width: 0.8),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(width : 2),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureTextPassword ? Icons.visibility : Icons.visibility_off,
                                            color: Color(0xffff0000),
                                          ),
                                          onPressed: () => BlocProvider.of<DriverRegisterBloc>(context).add(DriverRegisterObscureTextPassword())
                                        ),
                                      ),
                                      obscureText: _obscureTextPassword,
                                      controller : _passwordController,
                                      keyboardType: TextInputType.visiblePassword,
                                    ),
                                    width : MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText: 'Confirm Password',
                                          filled : true,
                                          hintStyle: TextStyle(
                                              color : Color(0xffff0000)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide : BorderSide(color: Color(0xffff0000), width: 2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius :BorderRadius.circular(20.0),
                                            borderSide: BorderSide(color:Color(0xffff0000), width :0.8),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.0),
                                            borderSide: BorderSide(width : 2),
                                          ),
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscureTextConfirm ? Icons.visibility : Icons.visibility_off,
                                                color: Color(0xffff0000),
                                              ),
                                              onPressed: () => BlocProvider.of<DriverRegisterBloc>(context).add(DriverRegisterObscureTextConfirm())
                                          ),
                                        ),
                                        obscureText: _obscureTextConfirm,
                                        controller : _confirmController,
                                        keyboardType: TextInputType.visiblePassword
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                  ),
                                  SizedBox(height: 35.0),
                                  RaisedButton(
                                      color: Color(0xffff0000),
                                      textColor: Colors.black,
                                      padding: const EdgeInsets.all(16.0),
                                      shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                      child: Text('Register'),
                                      onPressed: state is RegisterLoading ? (){} : (){
                                        if(_passwordController.text == _confirmController.text){
                                          BlocProvider.of<DriverRegisterBloc>(context).add(
                                            DriverRegisterButtonPressed(
                                                firstName:_firstNameController.text,
                                                lastName: _lastNameController.text,
                                                idNum: _idNumController.text,
                                                phoneNum: _phoneNumController.text ,
                                                password: _passwordController.text),
                                          );
                                        }else{
                                          _showError(context, "Error : Password do not match");
                                        }
                                      }
                                  ),
                                  SizedBox(height: 20.0),
                                  InkWell(
                                      onTap: state is RegisterLoading ? (){} : (){
                                        BlocProvider.of<DriverRegisterBloc>(context).add(DriverRegisterLoginButtonPressed());
                                      },
                                      child:Text('Already have an account \? Login',textAlign: TextAlign.center)
                                  ),
                                  SizedBox(height: 20.0),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        )
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