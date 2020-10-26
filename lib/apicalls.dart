
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/models.dart';

Future<List<Photo>>  fetchcuratedlist() async{

  final responce = await http.get(
        'https://api.pexels.com/v1/curated?per_page=80',
        headers: {
          HttpHeaders.authorizationHeader: '563492ad6f917000010000011d49cdd371fd456f84b218da7fe96047',
        }

      );

  final responce2 = await http.get(
        'https://api.pexels.com/v1/curated?per_page=80&page=2',
        headers: {
          HttpHeaders.authorizationHeader: '563492ad6f917000010000011d49cdd371fd456f84b218da7fe96047',
        }

      );

  final responce3 = await http.get(
        'https://api.pexels.com/v1/curated?per_page=80&page=3',
        headers: {
          HttpHeaders.authorizationHeader: '563492ad6f917000010000011d49cdd371fd456f84b218da7fe96047',
        }

      );        

      //decoding responce

      List<dynamic> photos = jsonDecode(responce.body)['photos'];
      List<dynamic> photos2 = jsonDecode(responce2.body)['photos'];
      List<dynamic> photos3 = jsonDecode(responce3.body)['photos'];

      photos.addAll(photos2);
      photos.addAll(photos3);
      //converting to photomodels list
      List<Photo>  listofphotos = photos.map<Photo>((photo) => Photo.fromJson(photo)).toList();

    
   return listofphotos;   

}


Future<List<Photo>>  fetchphotolist(String category,int pageindex) async{

  final responce = await http.get(
        'https://api.pexels.com/v1/search?query=${category}&per_page=80&page=${pageindex}',
        headers: {
          HttpHeaders.authorizationHeader: '563492ad6f917000010000011d49cdd371fd456f84b218da7fe96047',
        }

      );

      //decoding responce

      List<dynamic> photos = jsonDecode(responce.body)['photos'];

      //converting to photomodels list
      List<Photo>  listofphotos = photos.map<Photo>((photo) => Photo.fromJson(photo)).toList();

 

   return listofphotos;   

}


