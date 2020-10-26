import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/home.dart';
import 'package:wallpaper_app/photo.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
void main() {
  runApp(MyApp());
}

Stream<bool> checkconnectivity(){
        //  final isconnected = Provider.of<Isconnectedclass>(context);
      ConnectivityWrapper.instance.onStatusChange;
      print(ConnectivityWrapper.instance.onStatusChange.toString());
    return ConnectivityWrapper.instance.onStatusChange.map((event) {
        print(event);
        if(event == ConnectivityStatus.CONNECTED){
          print('connected');
          // isconnected.setstatus(true);
         
          return true;
        }else if(event == ConnectivityStatus.DISCONNECTED){
          print('disconnected');
          // isconnected.setstatus(true);
          return false;
        }

      // return event == ConnectivityStatus.CONNECTED ? Isconnected(event:event) : null;

    });

  }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<Photourl>(create:(context)=> Photourl()),
          ChangeNotifierProvider<Isconnectedclass>(create:(context)=> Isconnectedclass()),
        ],
       
        child: Mainwrapper())
      
    );
  }
}

class Mainwrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<bool>.value(
          value:checkconnectivity() ,
          child: Wrapper(
        
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {


  String lastpath;

  void getlastpath()async{
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/lastimagenowfinal.txt');

      if(await file.exists()){
       String lastimage = await file.readAsString();
     
       
       setState(() {
         lastpath = lastimage;
       });
        


     }else{
        setState(() {
          lastpath = 'assets/images/default.jpg';
        });
     }

  } 



  
 
 

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlastpath();

    // isconfuture = checkconnectivity();

  }

  @override
  Widget build(BuildContext context) {
      final  photourl =Provider.of<Photourl>(context);

      bool isconnected = Provider.of<bool>(context);
      final isconnectedclass = Provider.of<Isconnectedclass>(context);
        isconnectedclass.setstatus( isconnected);
       if(isconnected ){
                   return Home(
                lastpath: lastpath,
                photourl: photourl,
              );
            } else{

              
             return   Scaffold(body :Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                Text("Looks like you are offline.\nYou will be reconnected once you're online.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  
                ),),
               
              ],
            ),));
            }
      
    
  }
}



class Isconnected {
  ConnectivityStatus event;
  Isconnected({ this.event});
  
}

