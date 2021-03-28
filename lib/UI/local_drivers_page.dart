import 'package:flutter/material.dart';

class LocalDriversPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: new Builder(
        builder:(context) => new Scaffold(
          appBar:AppBar(
            backgroundColor: Color(0xffffffff),
            iconTheme: IconTheme.of(context).copyWith(
              color: Color(0xffff0000),
            ),
            elevation: 0.0,
            bottomOpacity: 0.0,
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text('Finding,',style:TextStyle(fontSize:15,fontWeight:FontWeight.w300,color:Color(0xffff0000))),
                      ),
                      SizedBox(height: 2.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text('Local Drivers',style:TextStyle(fontSize:35,fontWeight:FontWeight.bold,color:Color(0xffff0000)),),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff8a00), Color(0xffff0000)],
                          ),
                          borderRadius :BorderRadius.circular(70.0),
                        ),
                        width : MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GestureDetector(
                                onTap:(){
                                  Navigator.pushNamed(context, '/user_map_page');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.location_on, color: Color(0xffff0000)),
                                      SizedBox(width: 5.0),
                                      Text('View Map',style:TextStyle(color:Color(0xffff0000),),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              GestureDetector(
                                onTap:(){
                                  Navigator.pushNamed(context, '/user_driver_list_page');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  height: 70,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(Icons.list, color: Color(0xffff0000)),
                                      SizedBox(width: 5.0),
                                      Text('View List',style:TextStyle(color:Color(0xffff0000),),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}