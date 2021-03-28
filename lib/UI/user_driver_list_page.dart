import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/Data/services/services.dart';
import 'package:masivaye/maps/map_page.dart';
import 'package:masivaye/models/models.dart';
import 'package:masivaye/blocs/blocs.dart';

class UserDriverListPage extends StatelessWidget{

  TextEditingController radiusController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserDriverListService _service = RepositoryProvider.of<UserDriverListService>(context);

    Widget _tile(DriverLocation driver, DriverListBloc bloc) => InkWell(
      onTap:(){
        bloc.add(DriverListSelectedDriver(driver:  driver, quantity: quantityController.text));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        color: Colors.white,
        elevation: 2,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text('${driver.driverName} ${driver.driverSurname}',style:TextStyle(color:Colors.black)),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child : Text('${driver.driverPhone}',style:TextStyle(color:Colors.black))
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left:15.0),
                child: Text('${driver.carModel}',style:TextStyle(color:Colors.black)),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text('No. Of Seats : ${driver.seats}',style:TextStyle(color:Colors.black)),
              ),
              Row(
                mainAxisAlignment : MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Icon(driver.rating >= 1 ? Icons.star: driver.rating > 0 ? Icons.star_half: Icons.star_border, color:Colors.red),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Icon(driver.rating >= 2 ? Icons.star: driver.rating > 1 ? Icons.star_half: Icons.star_border, color:Colors.red),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Icon(driver.rating >= 3 ? Icons.star: driver.rating > 2 ? Icons.star_half: Icons.star_border, color:Colors.red),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Icon(driver.rating >= 4 ? Icons.star: driver.rating > 3 ? Icons.star_half: Icons.star_border, color:Colors.red),
                  ),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Icon(driver.rating == 5 ? Icons.star: driver.rating > 4 ? Icons.star_half: Icons.star_border, color:Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Text('${driver.rating}',style:TextStyle(color:Colors.black),textAlign:TextAlign.center),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return BlocProvider<DriverListBloc>(
      create: (context) => DriverListBloc(_service),
      child: new Scaffold(
        appBar: new PreferredSize(
          child: Container(
            alignment:Alignment.centerLeft,
            padding: new EdgeInsets.only(
              top : MediaQuery.of(context).padding.top,
            ),
            child: new Padding(
              padding: const EdgeInsets.only(
                left: 15,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                color:Colors.white,
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xffff8a00), Color(0xffff0000)]
              ),
            ),
          ),
          preferredSize: new Size(
              MediaQuery.of(context).size.width,
              60
          ),
        ),
        body: BlocListener<DriverListBloc, DriverListState>(
          listener: (context, state){

            if(state is DriverListSelectedDriverSuccess){
              Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => ConfirmDriver(location: state.driver, quantity: state.quantity,)
                ),
              );
            }

          },
          child: BlocBuilder<DriverListBloc, DriverListState>(
            builder: (context, state){
              if(state is DriverListLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(state is DriverListRadiusReloadSuccess){
                return SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xffff8a00), Color(0xffff0000)],
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.45,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left:15.0),
                                        child: Text('Viewing',textAlign:TextAlign.start,style:TextStyle(color:Colors.white,fontSize:13,fontWeight:FontWeight.w300)),
                                      ),
                                      SizedBox(height: 2),
                                      Padding(
                                        padding:const EdgeInsets.only(left: 15.0),
                                        child: Text('Driver List',style:TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width* 0.45,
                                    height: 50,
                                    child: Image.asset('assets/logo4.png',scale: 4),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            /*Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              height: 60,
                              child : TextFormField(
                                controller: quantityController,
                                decoration: InputDecoration(
                                  hintText: 'How many are you ?',
                                  hintStyle: TextStyle(
                                      color: Color(0xffff0000)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(color:Color(0xffff0000), width: 0.5),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                style:TextStyle(color:Colors.white),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                              height: 60,
                              child : TextFormField(
                                controller: radiusController,
                                style: TextStyle(color:Colors.white,),
                                decoration: InputDecoration(
                                  hintText: 'Search Distance (km)',
                                  hintStyle: TextStyle(
                                      color: Color(0xffff0000)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                    borderSide: BorderSide(color:Color(0xffff0000), width: 0.5),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),*/
                            ListView.builder(
                              itemCount: state.driverList.length,
                              itemBuilder: (context, index){
                                DriverLocation driver = state.driverList[index];
                                return _tile(driver,BlocProvider.of<DriverListBloc>(context));},
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ],
                        ),
                      ),
                    ),
                );
              }

              return SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffff8a00), Color(0xffff0000)],
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left:15.0),
                                    child: Text('Viewing',textAlign:TextAlign.start,style:TextStyle(color:Colors.white,fontSize:13,fontWeight:FontWeight.w300)),
                                  ),
                                  SizedBox(height: 2),
                                  Padding(
                                    padding:const EdgeInsets.only(left: 15.0),
                                    child: Text('Driver List',style:TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width* 0.45,
                                height: 50,
                                child: Image.asset('assets/logo4.png',scale: 4),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          height: 60,
                          child : TextFormField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              hintText: 'How many are you ?',
                              hintStyle: TextStyle(
                                  color: Color(0xffff0000)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(color:Color(0xffff0000), width: 0.5),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 60,
                          child : TextFormField(
                            controller: radiusController,
                            decoration: InputDecoration(
                              hintText: 'Search Distance (km)',
                              hintStyle: TextStyle(
                                  color: Color(0xffff0000)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(color: Color(0xffff0000), width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide(color:Color(0xffff0000), width: 0.5),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Center(
                          child : Column(
                            children: <Widget>[
                              Text('Please try again. (Make sure the to boxes are filled.)'),
                              IconButton(
                                  icon: Icon(Icons.refresh),
                                  color: Colors.white,
                                  onPressed:()=> BlocProvider.of<DriverListBloc>(context).add(DriverListEditRadiusReload(radius: radiusController.text,quantity: quantityController.text))
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ),
              );
            }
          ),
        )
      ),
    );
  }
}