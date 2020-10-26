
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:wallpaper_app/models.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_app/category.dart';

import 'package:wallpaper_app/setnsavecalls.dart';
import 'package:wallpaper_app/photo.dart';
import 'package:cache_image/cache_image.dart';
import 'package:wallpaper_app/apicalls.dart';

import 'package:wallpaper_app/favlist.dart';
class Home extends StatefulWidget {
  final Photourl photourl;
  final String lastpath;
  
  Home({this.lastpath,this.photourl});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  bool isloading = true;

  List<Photo> curatedphotoslist;
   
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  
  String dpath;
  bool isthere;
  String newurl;
  

// /data/user/0/com.example.wallpaper_app/app_flutter


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchcuratedlist().then((value) async{

     
      
      
   
       
       setState(() {
        curatedphotoslist = value;
        isloading = !isloading;
        widget.photourl.seturl(widget.lastpath);

     });

     
      
    
      
      
      
      
         });
   

    
  }

  @override
  Widget build(BuildContext context) {

  //  final  photourl =Provider.of<Photourl>(context);
  
    return SafeArea(
      
      child: isloading ? Scaffold(body: Center(child: CircularProgressIndicator(
        backgroundColor: Colors.pink[300],
      
      ))) : Scaffold(
        
        key: _scaffoldkey,
        
          floatingActionButton:Transform.rotate(
            // angle: 45.0,
            angle:math.pi / 4.0,
            origin: Offset(0, 0),
                      child:Padding(
                        padding: EdgeInsets.all(15.0),
                        
                                              child: FloatingActionButton(
                backgroundColor: Colors.pink[300],
                elevation: 14.0,
                
            
                splashColor: Colors.pink[400],
                shape: RoundedRectangleBorder(

                    
                  
                ),
                onPressed: ()async{
                    
                             Navigator.push(context, MaterialPageRoute(builder: (context){
                              return Categorysection(photo:widget.photourl);
                                    }));
                                  
                                  },
                child: Transform.rotate(
                  angle:-math.pi / 4.0,
                  child: Icon(Icons.wallpaper)),
              ),
                      ),
          ),

          body: Container(

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink[300],
                  Colors.pink[100]
                ],
                transform: GradientRotation(90)
              )
            ),
            child: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [

                   SliverAppBar(
                    
                     leading:IconButton(onPressed: (){
                Navigator.push(context,MaterialPageRoute(builder: (context){
                    return FavTab(photourl: widget.photourl,);
                }));
              }, icon: Icon(Icons.favorite ,color: Colors.white,)),
                      backgroundColor: Colors.pink[200],
                    //  actions: [Icon(Icons.settings,color: Colors.white,),SizedBox(width: 15.0,)],
                      stretch: true,
                      floating: true,snap: true,
                      pinned: true,
                      expandedHeight: 250.0,
                     flexibleSpace: FlexibleSpaceBar(
                       title: Text('Wide Pixel',style: TextStyle(
                         fontSize: 18.0
                       )),
                       centerTitle: true,
                       background: Image(
                         
                         image: widget.photourl.geturl != 'assets/images/default.jpg'  ? FileImage(File(widget.photourl.geturl)): AssetImage('assets/images/default.jpg'),
                         fit: BoxFit.cover,),
                         
                     ),
                   ),

                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                        sliver: SliverGrid.extent(
                        
                         maxCrossAxisExtent: 150.0,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.7,
                            children: curatedphotoslist.map((photo)=> Container(

                                        decoration: BoxDecoration(
                                          
                                          color:UniqueColorGenerator.getColor(),
                                          
                                          ),
                                      child: InkWell(
                                        onTap: ()async{
                                         String result = await setimageasW(context,photo,widget.photourl,false);
                                         print(result);
                                          if(result == 'setwallpaper'){
                                           setaswallpaper(photo, widget.photourl,_scaffoldkey,false);
                                          } else if(result == 'addtofav'){
                                            savephotoorundo(_scaffoldkey, photo);
                                          }
                                         
                                        },
                                                                          child: Image(
                                          image: CacheImage(
                                           photo.url
                                           
                                          ),fit: BoxFit.cover,
                                        ),
                                      ),

                                    ) ).toList(),
                      ),
                    ),

             
                        
                         
                         ]
            ),
          )
      
    ));
  }



}


