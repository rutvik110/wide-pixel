import 'package:flutter/material.dart';
import 'dart:math' as math;


class CategoryModel {

  String category;
  List<Photo> listofphotos;

  
  CategoryModel({this.category,this.listofphotos});
}

class Photo {
  String name;
  String url;
  
  Photo({this.name,this.url});
  
  Color getcolor(){

    Color myColor = UniqueColorGenerator.getColor();

    return myColor;

  }
  factory Photo.fromJson(Map<String,dynamic>  photo){

        

        return Photo(
          name: photo['photographer'] ?? 'name',
          url: photo['src']['portrait'] ?? 'url'
        );
  }

  Map<String,dynamic> toJson(){

    return {
        'name' : name,
        'url': url,
    };

  }
}

class UniqueColorGenerator {
  static math.Random random = new math.Random();
  static Color getColor() {
    return Color.fromARGB(
        255, random.nextInt(255), random.nextInt(255), random.nextInt(255));
  }
}

class Favlist with ChangeNotifier{

  List<Photo> favlist;

  Favlist({this.favlist});

  List<Photo>  get getfavlist => favlist;

 

  void editfavlist(String url){

    int removeatindex =   favlist.indexWhere((element) => element.url == url);

    favlist.removeAt(removeatindex);
    notifyListeners();

  }

  void addtofav(Photo photo){

     favlist.add(photo);
     notifyListeners();

  }

  

}

