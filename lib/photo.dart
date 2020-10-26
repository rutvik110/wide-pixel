import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';






class Photourl with ChangeNotifier {
  
  String url ;

  String get geturl => url;
  


  void seturl(String newurl)async{
  
      url = newurl;
     
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/lastimagenowfinal.txt');

      file.writeAsString(newurl);
      print('done');
      notifyListeners();
      
  }


// @override
// void didChangeDependencies() =>

  


}

class Isconnectedclass with ChangeNotifier{

  bool isconnected;

  bool get getstatus => isconnected;

  void setstatus(bool status){

    isconnected = status;
    notifyListeners();

  }

}