import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/Data/services/services.dart';

class UserRegister extends StatelessWidget{

  UserRegister({Key key}) : super(key: key);

  //controllers for the textfields
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    final UserRegisterService registerService = RepositoryProvider.of<UserRegisterService>(context);
    final AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(authBloc, registerService),
      child: new Theme(
        data:Theme.of(context).copyWith(
          cursorColor: Colors.black,
        ),
        child: new Builder(
          builder:(context) => new  Scaffold(
            body: BlocListener<RegisterBloc,UserRegisterState>(
              listener:(context, state){
                if(state is RegisterFailure){
                  //display snackbar displaying error message.
                  _showError(context, state.error);

                }

                if(state is RegisterSuccess){
                  Navigator.pushReplacementNamed(context, '/user_profile_image');
                }

                if(state is GoToLogin){
                  Navigator.pushReplacementNamed(context, '/user_login');
                }
              },
              child: BlocBuilder<RegisterBloc,UserRegisterState>(
                  builder: (context,state){
                    if(state is RegisterLoading){
                      return Center(
                        child : CircularProgressIndicator(),
                      );
                      //Navigator.pushReplacementNamed(context, '/user_profile_image');
                    }

                    if(state is RegisterObscurePasswordSuccess){
                      _obscurePassword = !_obscurePassword;
                    }

                    if(state is RegisterObscureConfirmSuccess){
                      _obscureConfirm = !_obscureConfirm;
                    }

                    return SafeArea(
                      child: SingleChildScrollView(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient : LinearGradient(
                              colors: [Color(0xffff8a00),Color(0xffff0000)]
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: MediaQuery.of(context).size.width*0.05),
                                alignment: Alignment.bottomLeft,
                                child : Text('Hello',style:TextStyle(fontSize:18,color:Colors.white,)),
                              ),
                              Container(
                                margin: EdgeInsets.only( left: MediaQuery.of(context).size.width*0.05),
                                alignment: Alignment.bottomLeft,
                                child : Text('Register (User)',style:TextStyle(fontSize: 28,color:Colors.white)),
                              ),
                              SizedBox(height:5),
                              Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft : Radius.circular(70),
                                        topRight: Radius.circular(70)
                                    ),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(height:40.0),
                                      Container(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            hintText : 'Firstname',
                                            hintStyle: TextStyle(
                                                color: Color(0xffff0000)
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
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        height: 70,
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
                                            hintText: 'Email Address',
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
                                          controller : _emailController,
                                          keyboardType: TextInputType.emailAddress,
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
                                          controller : _phoneController,
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
                                            suffixIcon: IconButton(
                                              icon : _obscurePassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                              color: Color(0xffff0000),
                                              onPressed: () => BlocProvider.of<RegisterBloc>(context).add(UserRegisterObscurePassword())
                                            ),
                                          ),
                                          obscureText: _obscurePassword,
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
                                                borderSide: BorderSide(color:Color(0xffff0000), width: 0.8),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(20.0),
                                                borderSide: BorderSide(width : 2),
                                              ),
                                              suffixIcon: IconButton(
                                                icon: _obscureConfirm ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                                color: Color(0xffff0000),
                                                onPressed : () => BlocProvider.of<RegisterBloc>(context).add(UserRegisterObscureConfirm())
                                              ),
                                            ),
                                            obscureText: _obscureConfirm,
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
                                          child: Text('Register '),
                                          onPressed: state is RegisterLoading ? (){} : (){
                                            if(_passwordController.text == _confirmController.text){
                                              BlocProvider.of<RegisterBloc>(context).add(
                                                RegisterButtonPressed(
                                                    firstName:_firstNameController.text,
                                                    lastName: _lastNameController.text,
                                                    email: _emailController.text,
                                                    phoneNum: _phoneController.text ,
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
                                            BlocProvider.of<RegisterBloc>(context).add(RegisterLoginButtonPressed());
                                          },
                                          child:Text('Already have an account \? Login',textAlign: TextAlign.center)
                                      ),
                                      SizedBox(height: 20.0),
                                    ],
                                  ),
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