import 'package:flutter/material.dart';

class SplashScreenPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffff8a00),Color(0xffff0000)]
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffff0000), width: 2.5),
                        shape:BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          fit:BoxFit.contain,
                          image : AssetImage('assets/masivaye_type1.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text('Mas\'vaye. Let\'s go!',textAlign:TextAlign.center,style:TextStyle(fontStyle: FontStyle.italic,color:Colors.white,),),
                    SizedBox(height: 15.0),
                    GestureDetector(
                      onTap:(){
                        //go to terms and agreements
                        Navigator.of(context).pushReplacementNamed('/choose_page');
                      },
                      child: Container(
                        child: Icon(Icons.arrow_forward_ios,color: Color(0xffff0000)),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape:BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}