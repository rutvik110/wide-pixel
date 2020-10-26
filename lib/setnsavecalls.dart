import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:wallpaper_app/photo.dart';
import 'dart:convert' as json;

import 'package:wallpaper_app/models.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
Future<bool> savefavlist(Photo photo )async{
 
 final path = await getApplicationDocumentsDirectory();

 final  favfile = await File('${path.path}/listoffav.json');
 print(favfile);

 if( await favfile.exists() == false ){
   print('creating favlist in local');
   List<Photo> favphotolist = [];

   favphotolist.add(photo);

   Map<String,List<Photo>>  favlistmap = {
      'favlist' : favphotolist,
   };
   final content = await json.jsonEncode(favlistmap);

  await favfile.writeAsString(content);
  print('created');

  return true;

 } else{

     String favlist = await favfile.readAsString(); 
      
     Map<String,dynamic> jsondecode = json.jsonDecode(favlist);

     List<dynamic> list = jsondecode['favlist']; 

     bool ispresentcheck( list){

            bool present = false;

            for (var photomap in list) {
                if( photomap['url'] == photo.url){

                  present = true;
                  

                  return present;

                } else{
                  present = false;
                 
                }
            }

            return present;

     }
     
     bool ispresent =  ispresentcheck(list);

     if(ispresent){
            // print('present already');
            // if(isfav){

            // }
            int removeatindex =   list.indexWhere((element) => element.containsValue(photo.url));
            
            jsondecode['favlist'].removeAt(removeatindex);
            final content = await json.jsonEncode(jsondecode);
            favfile.writeAsString(content) ;
            print(jsondecode['favlist'].length);
            print('removed from favourite');
            print(photo.name);
            return false;
            
     } else{

          jsondecode['favlist'].add(photo);

      final content = await json.jsonEncode(jsondecode);
     favfile.writeAsString(content) ;
     print(jsondecode['favlist'].length);
     print('added to favourite');
     print(photo.name);
     return true;

     }
    
  
    //  List<Photo> favphotolist = jsondecode[0];
    

 }

  
}

 void addtofav(Photo photo,Photourl photourl,scaffoldkey){
          savephotoorundo(scaffoldkey, photo);
  }


void savephotoorundo(scaffoldkey,Photo photo)async{

  bool isadded = await savefavlist( photo );
  
  scaffoldkey.currentState.showSnackBar(
          SnackBar(
                
                  backgroundColor: Colors.pink[50],
                
                  action: SnackBarAction(label: 'Undo      ', textColor: Colors.black,onPressed: ()async{
                    
                    savephotoorundo(scaffoldkey,photo);

                  }),
                  content: Text(isadded ? '     Added to favourites' :'     Removed from favourites',style: TextStyle(color: Colors.pink[400]),)
          )
  );

}


  void setaswallpaper(Photo photo,Photourl photourl,scaffoldkey,bool isfavtab)async{
      
      final repsonce = await get (photo.url);
      final path = await getApplicationDocumentsDirectory();
                                
      File file = File('${path.path}/${photo.name}.jpg');
      
      file.writeAsBytesSync(repsonce.bodyBytes);
                                
      photourl.seturl(file.path);


     final String results = await WallpaperManager.setWallpaperFromFile(file.path,WallpaperManager.BOTH_SCREENS,);
   
     scaffoldkey.currentState.showSnackBar(
          SnackBar(
               
                  backgroundColor: Colors.pink[50],
                 
                  
                  content: Text('Wallpapaer set',style: TextStyle(color: Colors.pink[400]),)
          )
  );                             
  }






  Future setimageasW(BuildContext context,Photo photo,Photourl photourl,bool isfavtab) {
    
    return showModalBottomSheet(
                       clipBehavior: Clip.hardEdge,
                         shape: BeveledRectangleBorder(
                           borderRadius: BorderRadius.only(
                             topLeft:Radius.circular(20.0),
                              topRight:Radius.circular(20.0),
                           ))
                        ,
                        context: context, builder: (context){
                        
                        return Container(
                            padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                           
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Container(
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.pink[200],
                                      offset: Offset(-15.0, 10.0),
                                    
                                    ),
                                    
                                  ]
                                  // borderRadius: BorderRadius.circular(8.0)
                                ),
                                                                child: Image(
                                                                  
                                  image: CacheImage(photo.url),
                                  height: 200.0,
                                  width: 150.0,
                                  fit: BoxFit.cover,
                                  
                                  ),

                               
                              ),

                              //Image name
                              SizedBox(height:20.0),
                              Text(photo.name,style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.pink[300]
                              ),),
                              SizedBox(height:20.0),
                              //set as wallpaper
                              FlatButton(onPressed: () {
                                Navigator.pop(context,'setwallpaper');
                              },
                              
                              color: Colors.white,
                              
                              child: Text('Set as wallpaper',style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.pink[300]
                              ),),
                              ),



                             //set as wallpaper
                              FlatButton(onPressed: () async{
                                
                              //  savephotoorundo(context, photo);
                                  
                               Navigator.pop(context,'addtofav');
                               
                              },
                              
                              color: Colors.white,
                              
                              child: Text(isfavtab ?'Remove from favourites' :'Add to favourites',style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.pink[300]
                              ),),
                              ),

                            
                            ],
                          ),
                        );

                      });
  }


