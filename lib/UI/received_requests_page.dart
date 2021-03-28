import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/maps/destination_map_page.dart';
import 'package:masivaye/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/Data/services/services.dart';

class ReceivedRequestPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final ReceivedRequestService _service = RepositoryProvider.of<ReceivedRequestService>(context);

    return BlocProvider<ReceivedRequestBloc>(
      create: (context) => ReceivedRequestBloc(_service),
      child: new Theme(
        data: Theme.of(context).copyWith(
          scaffoldBackgroundColor: Color(0xffff0000),
        ),
        child: new Builder(
          builder: (context) => new Scaffold(
              appBar: new AppBar(
                backgroundColor: Color(0xffff0000),
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
                elevation: 0,
              ),
              body: BlocListener<ReceivedRequestBloc, ReceivedState>(
                  listener: (context, state){

                    if(state is ReceivedStateAccept){
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => DestinationMapPage(
                            requestId: state.request.requestId,
                            source: LocationData.fromMap({"latitude":state.request.sourceLatitude,"longitude":state.request.sourceLongitude}),
                            destination: LocationData.fromMap({"latitude":state.request.destLatitude, "longitude":state.request.destLongitude}),
                            userLocation: LocationData.fromMap({"latitude":state.request.userLatitude, "longitude":state.request.userLongitude})
                          )
                        ),
                      );
                    }

                    if(state is ReceivedStateDecline){
                      Navigator.pushReplacementNamed(context, '/');
                    }

                    if(state is ReceivedStateInitial){
                      BlocProvider.of<ReceivedRequestBloc>(context).add(ReceivedEventGetRequests());
                    }

                    if(state is ReceivedStateLocate){
                      print("req"+state.request.requestId.toString());
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => DestinationMapPage(
                                requestId: state.request.requestId,
                                source: LocationData.fromMap({"latitude":state.request.sourceLatitude,"longitude":state.request.sourceLongitude}),
                                destination: LocationData.fromMap({"latitude":state.request.destLatitude, "longitude":state.request.destLongitude}),
                                userLocation: LocationData.fromMap({"latitude":state.request.userLatitude, "longitude":state.request.userLongitude})
                            )
                        ),
                      );
                    }

                  },
                  child: BlocBuilder<ReceivedRequestBloc,ReceivedState>(
                      builder: (context, state){
                        if(state is ReceivedStateLoading){
                          return Center(
                              child: CircularProgressIndicator()
                          );
                        }

                        if(state is ReceivedStateInitial){
                          BlocProvider.of<ReceivedRequestBloc>(context).add(ReceivedEventGetRequests());
                        }

                        if(state is ReceivedStateRequestsRetrieved){
                          return SafeArea(
                            child: SingleChildScrollView(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 35.0),
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
                                                child: Text('New',style:TextStyle(color:Colors.white,fontSize:13,fontWeight:FontWeight.w300)),
                                              ),
                                              SizedBox(height: 2),
                                              Padding(
                                                padding:const EdgeInsets.only(left: 15.0),
                                                child: Text('Request',style:TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.bold)),
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
                                    SizedBox(height:20.0),
                                    Container(
                                      decoration:BoxDecoration(
                                        color:Colors.white,
                                        borderRadius: BorderRadius.circular(70.0),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: 12.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('${state.request.username} ${state.request.usersurname}',style:TextStyle(color:Colors.black)),
                                          ),
                                          SizedBox(height: 7.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('Phone No.: ${state.request.phoneNum}',style:TextStyle(color:Colors.black)),
                                          ),
                                          SizedBox(height: 7.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('Destination : ${state.request.destinationName}',style:TextStyle(color:Colors.black)),
                                          ),
                                          SizedBox(height: 17.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('Distance : ${state.request.distance} km',style:TextStyle(color:Colors.black)),
                                          ),
                                          SizedBox(height: 7.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('Price (E 6.50/km) : E ${state.request.price}.',style:TextStyle(color:Colors.black)),  //TODO: consider adding the price dynamically using a server or something.
                                          ),
                                          SizedBox(height: 7.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('Payment Method : ${state.request.paymentMethod}',style:TextStyle(color:Colors.black)),
                                          ),
                                          SizedBox(height: 7.0),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 15.0),
                                            child: Text('No. of People : ${state.request.quantity}',style:TextStyle(color:Colors.black)),
                                          ),
                                          SizedBox(height: 15.0),
                                          GestureDetector(
                                            onTap:(){
                                              BlocProvider.of<ReceivedRequestBloc>(context).add(ReceivedEventAccept(request: state.request));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(50.0),
                                                border:Border.fromBorderSide(BorderSide(color:Colors.black,width:1)),
                                                color: Colors.white,
                                              ),
                                              width : MediaQuery.of(context).size.width * 0.5,
                                              height: 70,
                                              child: Text('Accept',style:TextStyle(color:Colors.black,fontSize: 20)),
                                              alignment:Alignment.center,
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          GestureDetector(
                                            onTap: (){
                                              BlocProvider.of<ReceivedRequestBloc>(context).add(ReceivedEventDecline(requestId: state.request.requestId));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  color:Colors.black
                                              ),
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              height: 70,
                                              child: Text("Decline",style:TextStyle(color:Colors.white,fontSize:20)),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                          GestureDetector(
                                            onTap: (){
                                              BlocProvider.of<ReceivedRequestBloc>(context).add(ReceivedEventLocate(requestId: state.request));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  color:Color(0xffff0000),
                                              ),
                                              width: MediaQuery.of(context).size.width * 0.5,
                                              height: 70,
                                              child: Text("Locate",style:TextStyle(color:Colors.white,fontSize:20)),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          SizedBox(height: 15.0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return SafeArea(
                          child: Center(
                            child: Text('No requests at the moment',style:TextStyle(color:Colors.white,)),
                          ),
                        );
                      }
                  )
              )
          ),
        ),
      ),
    );
  }
}