import 'dart:convert' as json;
import 'dart:io';

import 'package:flutter/material.dart';




import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:wallpaper_app/setnsavecalls.dart';

import 'dart:math' as math;


import 'package:wallpaper_app/photo.dart';
import 'package:cache_image/cache_image.dart';

import 'package:wallpaper_app/models.dart';
import 'package:wallpaper_app/apicalls.dart';


class FavTab extends StatefulWidget {
  
  Photourl photourl;
  
  FavTab({this.photourl});
  

  @override
  _FavTabState createState() => _FavTabState();
}

class _FavTabState extends State<FavTab> {

  bool isloading = true;
  int pageindexcounter = 1;
  List<Photo> photoslist ;
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final Color myColor = UniqueColorGenerator.getColor();

  Future<List<Photo>> fetchcategories(int pageindex) async{
  
     final path = await getApplicationDocumentsDirectory();

    final  favfile = await File('${path.path}/listoffav.json');
    String favlist = await favfile.readAsString(); 
      
    Map<String,dynamic> jsondecode = json.jsonDecode(favlist);

    List<dynamic> listoffav = jsondecode['favlist']; 

    List<Photo>  listoffavlast = listoffav.map<Photo>((photomap) => Photo(name: photomap['name'],url: photomap['url'])).toList();
    print('error is here?');
    
    return listoffavlast;

 
}

  





  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
        print('fetching');
        fetchcategories(pageindexcounter).then((value) async{ 
            
            

            setState(() {
              photoslist = value;
              isloading = !isloading;
           
            });

            
         
          
          });
    
  }


  @override
  Widget build(BuildContext context) {
    
    



        return ChangeNotifierProvider(
          create: (context)=> Favlist(favlist: photoslist),

                  child: SafeArea(
                child: Scaffold(
                  key: _scaffoldkey,
                  appBar: AppBar(
                    backgroundColor: Colors.pink[200],
                    title: Text('Favourites',style: TextStyle(
                      color: Colors.white
                    )),
                   
                  
                    
                  ),
                  body: Stack(children: [

                    Container(
                        height: MediaQuery.of(context).size.height,

                         decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.pink[300],
                                Colors.pink[100]
                              ],
                                            transform: GradientRotation(90)
                              )
                            ),
                      ),
                      isloading ? Center(child:CircularProgressIndicator()) : Stack(
    
                    children: [
                      
                      
                         photoslist.length !=0 ? Column(
                           crossAxisAlignment:  CrossAxisAlignment.center,
                      children:[
    
                        Expanded(
                            child: ImageGrid(photoslist: photoslist,widget: widget,scaffoldkey:_scaffoldkey,),
                        )
    
                      ],
                    ) : Center(child: Text('no favourites'),),
    
                 
                ]
              ),

                    
                   
                  ],)
              
             

      ),
    ),
        );
  }

 
}


class ImageGrid extends StatelessWidget {
  const ImageGrid({
    Key key,
    @required this.photoslist,
    @required this.widget,
    this.scaffoldkey
  }) : super(key: key);

  final List<Photo> photoslist;
  final FavTab widget;
  final scaffoldkey;

  @override
  Widget build(BuildContext context) {

    final  favlist =Provider.of<Favlist>(context); 
    return GridView.count(
    padding: EdgeInsets.all(5.0),
    
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: 5.0,
    mainAxisSpacing: 10.0,
    children: favlist.getfavlist.map((photo) => 
    
    Container(
    
      decoration: BoxDecoration(
      
        
                                          // color:UniqueColorGenerator.getColor(),
      ),

      child:Stack(
        children: [
                Image(
      
      image:CacheImage(photo.url),fit: BoxFit.fitWidth),
      
      Align(
        alignment: Alignment.bottomCenter,
          child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            FlatButton(onPressed: ()async{
                
               String result = await setimageasW(context, photo, widget.photourl,true);
                                        
               if(result == 'setwallpaper'){
                         setaswallpaper(photo,widget.photourl,scaffoldkey,true);
                } else if(result == 'addtofav'){
                  

                  addorremove( favlist,scaffoldkey,photo,true);

                  



                  
                                            // addtofav(photo,widget.photourl,scaffoldkey);
                                         
                                          }
              
            }, child: Text('View',style: TextStyle(color: Colors.pink[400])),color: Colors.white,),

          ],
      ),
      )
      ],
      )
       
    )
    
    ).toList(),);
  }
}


//badass function i've ever return till this date


void addorremove(Favlist favlist,scaffoldkey,Photo photo,bool remove){

    if(remove){

      favlist.editfavlist(photo.url);

                  scaffoldkey.currentState.showSnackBar(
          SnackBar(
                
                  backgroundColor: Colors.pink[50],
                
                  action: SnackBarAction(label: 'Undo      ', textColor: Colors.black,onPressed: ()async{
                    
                    // favlist.addtofav(photo);
                    addorremove(favlist, scaffoldkey, photo, false);




                  }),
                  content: Text('Removed from favourites',style: TextStyle(color: Colors.pink[400]),)
          ));

    }else{

      favlist.addtofav(photo);
        scaffoldkey.currentState.showSnackBar(
          SnackBar(
                
                  backgroundColor: Colors.pink[50],
                
                  action: SnackBarAction(label: 'Undo      ', textColor: Colors.black,onPressed: ()async{
                    
                    // favlist.addtofav(photo);
                    addorremove(favlist, scaffoldkey, photo, true);




                  }),
                  content: Text('Added to favourites',style: TextStyle(color: Colors.pink[400]),)
          ));

    }

}