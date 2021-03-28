import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'choose_page.dart';

class DriverForgotPasswordInputPhone extends StatefulWidget{

  @override
  _DriverForgotPasswordInputPhoneState createState() => new _DriverForgotPasswordInputPhoneState();
}

class _DriverForgotPasswordInputPhoneState extends State<DriverForgotPasswordInputPhone>{

  TextEditingController _phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child : new Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Forgot Password',style: TextStyle(color:Colors.white),),
            backgroundColor: Color(0xffff8a00),
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text('Please confirm your Phone Number below :', textAlign:TextAlign.center, style: TextStyle(fontSize: 15)),
                    ),
                    SizedBox(),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 70,
                      child : TextFormField(
                        controller: _phone,
                        decoration: InputDecoration(
                          labelText : "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          hintText : "PHONE NUMBER",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          filled : true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffff8a00), width: 1.5),
                            borderRadius : BorderRadius.circular(20.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffff8a00), width: 0.8),
                            borderRadius : BorderRadius.circular(20.0),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    SizedBox(height: 15.0),
                    GestureDetector(
                      onTap:(){
                        confirmDriverNumber();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          gradient: LinearGradient(
                              colors: [Color(0xffff0000), Color(0xffff8a00)]
                          ),
                        ),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize:MainAxisSize.min,
                          children: <Widget>[
                            Text('Continue',style:TextStyle(color:Colors.white,)),
                            Icon(Icons.arrow_forward, color: Colors.white,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //handle server call
  Future<void> confirmDriverNumber() async{
    final url = "https://vybe.ashio.me/masivaye/confirm_number.php";
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      "driver_phone" : _phone.text
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body : json.encode(data)
    );

    print(response.body);

    if(response.statusCode == 200){
      final res = json.decode(response.body);

      if(res['success'] == 1){
        print("Go wait for the confirmation code to arrive");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context)=> DriverForgotPasswordInputCodePage(phone: _phone.text.toString())
          ),
        );
      }else{
        print("This driver number is not registered in the database.");
      }
    }else{
      throw Exception("Error from confirm driver number server api response.");
    }
  }
}

///*********************************************************************************************************************************///
//this class is to handle waiting for the code from the server to confirm driver and allow redefinition of password,
class DriverForgotPasswordInputCodePage extends StatefulWidget{

  final String phone;
  DriverForgotPasswordInputCodePage({this.phone});
  @override
  _DriverForgotPasswordInputCodePage createState() => new _DriverForgotPasswordInputCodePage();
}

class _DriverForgotPasswordInputCodePage extends State<DriverForgotPasswordInputCodePage>{

  final String phone;
  _DriverForgotPasswordInputCodePage({this.phone});
  TextEditingController _first = new TextEditingController();
  TextEditingController _second = new TextEditingController();
  TextEditingController _third = new TextEditingController();
  TextEditingController _fourth = new TextEditingController();
  TextEditingController _fifth = new TextEditingController();

  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
      ),
      child: new Builder(
        builder: (context) => new Scaffold(
          appBar: AppBar(
            iconTheme: IconTheme.of(context).copyWith(
              color: Colors.white,
            ),
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffff0000), Color(0xffff8a00)],
                    ),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color:Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width* 0.85,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('Confirmation Code', textAlign:TextAlign.center,style:TextStyle(color:Color(0xffff0000)),),
                                SizedBox(height: 15.0),
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: 80,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.12,
                                          child: TextFormField(
                                            controller: _first,
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: '-',
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.12,
                                          child : TextFormField(
                                            controller: _second,
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: '-',
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.12,
                                          child: TextFormField(
                                            controller: _third,
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: '-',
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.12,
                                          child: TextFormField(
                                            controller: _fourth,
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: '-',
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          width : MediaQuery.of(context).size.width * 0.12,
                                          child: TextFormField(
                                            controller: _fifth,
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: '-',
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Color(0xffff0000), width:1.5)
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                RaisedButton(
                                  color: Color(0xffff0000),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                                  padding: const EdgeInsets.all(16.0),
                                  child : Text('Confirm'),
                                  onPressed: () => _confirmConfirmationCode(),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        GestureDetector(
                          onTap:(){
                            print('re requesting for the confirmation code.');
                            confirmDriverNumber();
                          },
                          child:Container(
                            decoration: BoxDecoration(
                                color:Colors.white,
                                borderRadius: BorderRadius.circular(70.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.refresh, color: Color(0xffff0000)),
                                SizedBox(width:5),
                                Text('Re-send Confirmation Code'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0)
                      ]
                  ),
                ),
              )
            ),
          ),
        ),
      ),
    );
  }

  Future<void> confirmDriverNumber() async{
    final url = "https://vybe.ashio.me/masivaye/confirm_number.php";
    Map<String, String> headers = {"Content-Type": "application/json"};
    Map<String, dynamic> data = {
      "driver_phone" : phone
    };

    http.Response response = await http.post(
        url,
        headers: headers,
        body : json.encode(data)
    );

    print(response.body);

    if(response.statusCode == 200){
      final res = json.decode(response.body);

      if(res['success'] == 1){
        print("Go wait for the confirmation code to arrive");
      }else{
        print("This driver number is not registered in the database.");
      }
    }else{
      throw Exception("Error from confirm driver number server api response.");
    }
  }

  Future<void> _confirmConfirmationCode() async{
    final url = "https://vybe.ashio.me/masivaye/confirmation_code.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data = {
      "first" : _first.text,
      "second" : _second.text,
      "third" : _third.text,
      "fourth" : _fourth.text,
      "fifth" : _fifth.text,
      "phone" : phone
    };

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    //handle the response from the server,
    print(response.body);

    if(response.statusCode == 200){
      final res = json.decode(response.body);
      if(res["success"] == 1){
        //go to enter new password page
        print('go enter a new password for this driver');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context)=> DriverForgotPasswordNewPassword(phone: phone)
          )
        );
      }else{
        print(res["message"]);
      }
    }else{
      throw Exception('Error in confirming the confirmation code on sever api.');
    }
  }

}


///********************************************************************************************************************************///
//this class allows the user to enter the new  password and logs them in upon completion.
class DriverForgotPasswordNewPassword extends StatefulWidget{

  final String phone;
  DriverForgotPasswordNewPassword({this.phone});
  @override
  _DriverForgotPasswordNewPasswordState createState() => new _DriverForgotPasswordNewPasswordState(phone: phone);
}

class _DriverForgotPasswordNewPasswordState extends State<DriverForgotPasswordNewPassword>{

  final String phone;
  _DriverForgotPasswordNewPasswordState({this.phone});

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconTheme.of(context).copyWith(
          color:Colors.white,
        )
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffff0000), Color(0xffff8a00)]
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text('New Password', textAlign:TextAlign.center, style:TextStyle(color:Colors.white,fontSize: 28)),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70.0),
                      color: Colors.white,
                    ),
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 70,
                            child: TextFormField(
                              controller: newPassword,
                              decoration: InputDecoration(
                                hintText : 'New Password',
                                hintStyle: TextStyle(
                                  color: Color(0xffff0000),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffff0000), width: 1.5),
                                  borderRadius : BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffff0000), width: 0.8),
                                  borderRadius : BorderRadius.circular(20.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: _obscurePassword ? Icon(Icons.visibility): Icon(Icons.visibility_off),
                                  color: Color(0xffff0000),
                                  onPressed: (){
                                    setState((){
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscurePassword,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 70,
                            child: TextFormField(
                              controller: confirmPassword,
                              decoration: InputDecoration(
                                hintText : 'Confirm Password',
                                hintStyle: TextStyle(
                                  color: Color(0xffff0000),
                                ),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffff0000), width: 1.5),
                                  borderRadius : BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xffff0000), width: 0.8),
                                  borderRadius : BorderRadius.circular(20.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: _obscureConfirm ? Icon(Icons.visibility): Icon(Icons.visibility_off),
                                  color: Color(0xffff0000),
                                  onPressed: (){
                                    setState((){
                                      _obscureConfirm = !_obscureConfirm;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _obscureConfirm,
                              keyboardType: TextInputType.visiblePassword
                            ),
                          ),
                          SizedBox(height: 25.0),
                          RaisedButton(
                            color: Colors.black,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
                            padding: const EdgeInsets.all(16.0),
                            child: Text('Submit'),
                            onPressed: ()=> _uploadNewPassword()
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  SharedPreferences prefs;

  Future<void> _uploadNewPassword() async{

    final url = "https://vybe.ashio.me/masivaye/new_password.php";
    Map<String,String> headers = {"Content-Type": "application/json"};
    Map<String,dynamic> data;
    if(newPassword.text == confirmPassword.text){
      data = {
        "driver_phone" : phone,
        "new_password" : newPassword.text
      };
    }else if(newPassword.text == null || newPassword.text == ""){
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('New Password field must be filled'),
            backgroundColor: Theme.of(context).errorColor,
          )
      );

      return;
    }else if(confirmPassword.text == null || confirmPassword.text == ""){
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Confirm Password must be filled'),
            backgroundColor: Theme.of(context).errorColor,
          )
      );

      return;
    }else{
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Theme.of(context).errorColor,
          )
      );
      return;
    }

    http.Response response = await http.post(
      url,
      headers: headers,
      body: json.encode(data)
    );

    print(response.body);
    if(response.statusCode == 200){
      final res = json.decode(response.body);

      if(res["success"] == 1){
        print(res["message"]);
        saveToPreferences(res['id'], res['name'], res['surname'], res['idNum'], res['phone']);
        return ChoosePage();
      }else{
        print(res["message"]);
      }
    }
  }

  void saveToPreferences(int id, String name, String surname, int Id, String phone) async{
    prefs = await SharedPreferences.getInstance();

    prefs.setBool('driverLogged', true);
    prefs.setInt('driverId', id);
    prefs.setString('driverFirstName', name);
    prefs.setString('driverLastName', surname);
    prefs.setInt('driverIdNum',Id);
    prefs.setString('driverPhoneNum', phone);
    prefs.setString('driverProfileUrl', " ");

  }
}