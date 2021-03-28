import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masivaye/blocs/blocs.dart';
import 'package:masivaye/maps/map_page.dart';
import 'package:masivaye/models/models.dart';
import 'package:flutter/material.dart';
import 'package:masivaye/Data/services/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserTransactionsPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){

    final TransactionService _transactionService = RepositoryProvider.of<TransactionService>(context);

    Widget _tile(TransactionItem item, TransactionsBloc bloc) => Card(
      child:Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height* 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap:(){
                      openUserHero(item, context);
                    },
                    child: Container(
                      child: Hero(
                        tag: '${item.requestId}${item.userId}_tag',
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${item.profileUrl}'),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.18,
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      openDriverHero(item, context);
                    },
                    child: Container(
                      child: Hero(
                        tag: '${item.requestId}${item.driverId}_tag',
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${item.driverProfileUrl}'),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.18,
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      openCarHero(item, context);
                    },
                    child: Container(
                      child: Hero(
                        tag: '${item.requestId}${item.carId}_tag',
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('${item.carProfileUrl}'),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                'Destination : ${item.destinationName}',
                textAlign:TextAlign.center,
                style: TextStyle(
                  color: Color(0xffff0000),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding:const EdgeInsets.all(0),
              child: Text(
                'Distance : ${item.distance} km',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffff0000),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                'Price : E ${item.price}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffff0000),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                'Quantity : ${item.quantity}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffff0000),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Text(
                'Status : ${item.status}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffff0000),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              color:Colors.black,
              textColor: Colors.white,
              child: Text('View in Map'),
              onPressed: ()=> bloc.add(UserTransactionViewMap(source: LatLng(item.sourceLatitude,item.sourceLongitude),destination: LatLng(item.destLatitude,item.destLongitude))),
            ),
          ],
        ),
      ),
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(70)),
      margin: const EdgeInsets.only(top:6.0,bottom: 6.0),
      color: Colors.white,
    );

    return BlocProvider<TransactionsBloc>(
      create:(context) => TransactionsBloc(_transactionService),
      child: new Theme(
        data: Theme.of(context).copyWith(scaffoldBackgroundColor: Color(0xffff0000)),
        child: new Builder(
          builder: (context) => Scaffold(
            appBar:AppBar(
              backgroundColor:Color(0xffff0000),
              iconTheme:IconTheme.of(context).copyWith(
                color:Colors.white,
              ),
              title : Text('My Transactions',style:TextStyle(color:Colors.white)),
              elevation: 0.0
            ),
            body: BlocListener<TransactionsBloc,TransactionState>(
              listener: (context,state){

                if(state is TransactionStateInitial){
                  //perform api call and get the transactions
                  BlocProvider.of<TransactionsBloc>(context).add(TransactionGetTransactions());
                }

                if(state is TransactionStateViewMapSuccess){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MapPage(source: state.source, dest: state.destination,)
                    )
                  );
                }

              },
              child: BlocBuilder<TransactionsBloc,TransactionState>(
                builder: (context,state){
                  if(state is TransactionStateLoading){
                    return Center(
                      child: CircularProgressIndicator()
                    );
                  }

                  if(state is TransactionStateInitial){
                    //perform api call and get the transactions
                    BlocProvider.of<TransactionsBloc>(context).add(TransactionGetTransactions());
                  }

                  if(state is TransactionReceivedState){

                    print(state.transaction);
                    return SafeArea(
                      child: Center(
                        child:ListView.builder(
                          itemCount: state.transaction.length,
                          itemBuilder: (context,index){
                            TransactionItem item = state.transaction[index];
                              return _tile(item,BlocProvider.of<TransactionsBloc>(context));
                            },
                        ),
                      ),
                    );
                  }

                  return SafeArea(
                    child:Center(
                      child :IconButton(
                        icon: Icon(Icons.refresh),
                        color: Colors.white,
                        onPressed:()=> BlocProvider.of<TransactionsBloc>(context).add(TransactionGetTransactions())
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

  void openUserHero(TransactionItem item, BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: new Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('User Profile Image',style:TextStyle(color:Colors.white,)),
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height:15.0),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text('${item.username} ${item.surname}',style:TextStyle(color:Colors.white,)),
                        ),
                        SizedBox(height:5.0),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child : Text('${item.phone}',style:TextStyle(color:Colors.white,)),
                        ),
                        SizedBox(height: 10),
                        Hero(
                          tag: '${item.requestId}${item.userId}_tag',
                          child: Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Image.network("${item.profileUrl}"),
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
      ),
    );
  }

  void openDriverHero(TransactionItem item, BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: new Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Driver Profile Image',style:TextStyle(color:Colors.white,)),
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height:15.0),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text('${item.driverName} ${item.driverSurname}',style:TextStyle(color:Colors.white,)),
                        ),
                        SizedBox(height:5.0),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child : Text('${item.driverPhone}',style:TextStyle(color:Colors.white,)),
                        ),
                        SizedBox(height: 10),
                        Hero(
                          tag: '${item.requestId}${item.driverId}_tag',
                          child: Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Image.network("${item.driverProfileUrl}"),
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
      ),
    );
  }

  void openCarHero(TransactionItem item, BuildContext context){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:(context) => Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.black,
          ),
          child: new Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Car Profile Image',style:TextStyle(color:Colors.white,)),
                backgroundColor: Colors.black,
                iconTheme: IconTheme.of(context).copyWith(
                  color: Colors.white,
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height:15.0),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Text('${item.carName}',style:TextStyle(color:Colors.white,)),
                        ),
                        SizedBox(height:5.0),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child : Text('${item.carPlate}',style:TextStyle(color:Colors.white,)),
                        ),
                        SizedBox(height: 10),
                        Hero(
                          tag: '${item.requestId}${item.carId}_tag',
                          child: Container(
                            width: MediaQuery.of(context).size.width ,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Image.network("${item.carProfileUrl}"),
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
      ),
    );
  }
}