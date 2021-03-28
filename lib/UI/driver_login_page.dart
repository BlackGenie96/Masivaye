import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../Data/services/services.dart';

class DriverLogin extends StatelessWidget{

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authService = RepositoryProvider.of<AuthenticationService>(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocProvider<DriverLoginBloc>(
      create: (context) => DriverLoginBloc(authBloc,authService),
      child: new Scaffold(
        body: BlocListener<DriverLoginBloc, DriverLoginState>(
          listener:(context, state){
            if(state is GoToDriverRegister){
              Navigator.pushReplacementNamed(context, '/driver_register');
            }

            if(state is DriverLoginFailure){
              _showError(context,state.error);
            }

            if(state is DriverLoginSuccess){
              Navigator.pop(context);
            }

          },
          child: BlocBuilder<DriverLoginBloc, DriverLoginState>(
            builder : (context, state){
              if(state is DriverLoginLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(state is DriverPasswordObscureSuccess){
                _obscureText = !_obscureText;
              }

              return SafeArea(
                child:Center(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:[Color(0xffff8a00), Color(0xffff0000)]
                        ),
                      ),
                      child : Column(
                        mainAxisSize: MainAxisSize.min,
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
                            child : Text('Login (Driver)',style:TextStyle(fontSize: 28,color:Colors.white)),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(70),
                                topRight: Radius.circular(70),
                              ),
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                      hintStyle: TextStyle(
                                        color: Color(0xffff0000),
                                      ),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide(color:Color(0xffff0000), width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide(color : Color(0xffff0000), width: 0.8),
                                      ),
                                    ),
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    autocorrect: false,
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                ),
                                SizedBox(height: 12.0),
                                Container(
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        color: Color(0xffff0000),
                                      ),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide(color:Color(0xffff0000), width: 2),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        borderSide: BorderSide(color : Color(0xffff0000), width: 0.8),
                                      ),
                                      suffixIcon: IconButton(
                                        icon :_obscureText ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                        color: Color(0xffff0000),
                                        onPressed: () => BlocProvider.of<DriverLoginBloc>(context).add(DriverPasswordObscure())
                                      ),
                                    ),
                                    obscureText: _obscureText,
                                    controller: _passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    autocorrect: false,
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                ),
                                SizedBox(height: 16.0),
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
                                      BlocProvider.of<DriverLoginBloc>(context).add(DriverLoginWithPhoneNumButtonPressed(phoneNum: _phoneController.text, password: _passwordController.text));
                                    }
                                  },
                                ),
                                SizedBox(height: 25,),
                                InkWell(
                                  onTap: state is LoginLoading ? (){} : (){
                                    BlocProvider.of<DriverLoginBloc>(context).add(DriverLoginRegisterButtonPressed());
                                  } ,
                                  child:Text('Don\'t have an account? Register',textAlign: TextAlign.center,style:TextStyle(fontSize:15,)),
                                ),
                                SizedBox(height: 25),
                                /*InkWell(
                                  onTap:()=> Navigator.of(context).pushNamed('/user_forgot_password'),
                                  child: Text('Forgot Password', textAlign:TextAlign.center,style:TextStyle(fontSize:15.0)),
                                ),*/
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          ),
        )
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