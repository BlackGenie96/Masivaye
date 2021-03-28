import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../Data/services/services.dart';

class UserLogin extends StatelessWidget{
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(authBloc,authService),
      child: new Scaffold(
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context,state){
            if(state is LoginSuccess){
              Navigator.pop(context);
              print('user login success');
            }

            if(state is LoginFailure){
              _showError(context,'Error in log in information.');
              print('user login failure.');
            }

            if(state is GoToRegister){
              print('go to register.');
              Navigator.of(context).pushReplacementNamed('/user_register');
            }
          },
          child:BlocBuilder<LoginBloc,LoginState>(
            builder: (context,state){
              if(state is LoginLoading){
                return Center(
                  child : CircularProgressIndicator(),
                );
              }

              if(state is LoginObscurePasswordSuccess){
                _obscureText = !_obscureText;
              }

              return SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xffff8a00),Color(0xffff0000)]
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2, left: MediaQuery.of(context).size.width*0.05),
                            alignment: Alignment.bottomLeft,
                            child : Text('Welcome',style:TextStyle(fontSize:18,color:Colors.white,)),
                          ),
                          Container(
                            margin: EdgeInsets.only( left: MediaQuery.of(context).size.width*0.05),
                            alignment: Alignment.bottomLeft,
                            child : Text('Login (User)',style:TextStyle(fontSize: 28,color:Colors.white)),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0),
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft:Radius.circular(70),
                                  topRight: Radius.circular(70),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment : MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: 30),
                                  Container(
                                    child:TextFormField(
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(
                                          color: Color(0xffff0000),
                                        ),
                                        hintText: 'Phone Number',
                                        filled : true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20.0),
                                          borderSide: BorderSide(color: Color(0xffff0000), width: 0.8),
                                        ),
                                      ),
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      autocorrect: false,
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                  ),
                                  SizedBox(height:12.0),
                                  Container(
                                    child: TextFormField(
                                        decoration: InputDecoration(
                                          hintText : 'Password',
                                          hintStyle : TextStyle(
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
                                          suffixIcon: IconButton(
                                            icon: _obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                            color: Color(0xffff0000),
                                            onPressed: ()=> BlocProvider.of<LoginBloc>(context).add(LoginObscurePassword())
                                          ),
                                        ),
                                        obscureText: _obscureText,
                                        autovalidate: true,
                                        controller : _passwordController,
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.7,
                                    height: 70,
                                  ),
                                  const SizedBox(height: 16.0),
                                  RaisedButton(
                                    color: Color(0xffff0000),
                                    textColor: Colors.white,
                                    padding : const EdgeInsets.all(16.0),
                                    shape : new RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                    child: Text('Log In'),
                                    onPressed : state is LoginLoading ? (){} : (){
                                      if((_phoneController.text == "" || _phoneController.text == null) && (_passwordController.text == "" || _passwordController.text == null)){
                                        _showError(context, "Phone Number and Password fields are empty.");
                                      }else if(_phoneController.text == null || _phoneController.text == ""){
                                        _showError(context, "Phone Number field is empty.");
                                      }else if(_passwordController.text == null || _passwordController.text == ""){
                                        _showError(context, "Password field is empty.");
                                      }else{
                                        BlocProvider.of<LoginBloc>(context).add(LoginInWithIdNumButtonPressed(phoneNum: _phoneController.text,password: _passwordController.text));
                                      }
                                    },
                                  ),
                                  SizedBox(height: 25),
                                  /*InkWell(
                                    onTap:()=> Navigator.of(context).pushNamed('/user_forgot_password'),
                                    child: Text('Forgot Password', textAlign:TextAlign.center,style:TextStyle(fontSize:15.0)),
                                  ),*/
                                  SizedBox(height: 15),
                                  InkWell(
                                    onTap: state is LoginLoading ? (){} : (){
                                      BlocProvider.of<LoginBloc>(context).add(LoginRegisterButtonPressed());
                                    } ,
                                    child:Text(
                                      'Don\'t have an account? Register',
                                      textAlign: TextAlign.center,
                                      style:TextStyle(fontSize:15,),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context,String error){
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Theme.of(context).errorColor,
        )
    );
  }
}
