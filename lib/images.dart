

import 'package:flutter/material.dart';

import 'package:wallpaper_app/setnsavecalls.dart';

import 'dart:math' as math;


import 'package:wallpaper_app/photo.dart';
import 'package:cache_image/cache_image.dart';

import 'package:wallpaper_app/models.dart';
import 'package:wallpaper_app/apicalls.dart';


class Imagesection extends StatefulWidget {
  final Photourl photourl;
  final String category;
  final List<Photo> photolist;

  Imagesection({this.photolist,this.photourl,this.category});

  @override
  _ImagesectionState createState() => _ImagesectionState();
}

class _ImagesectionState extends State<Imagesection> {

  bool isloading = true;
  int pageindexcounter = 1;
  List<Photo> photoslist = [];
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final Color myColor = UniqueColorGenerator.getColor();

  Future<List<CategoryModel>> fetchcategories(int pageindex) async{
  
     Future<CategoryModel> photomodellist =   fetchphotolist(widget.category,pageindex).then(
        
        (value) {
        
         
         CategoryModel categorymodel=  CategoryModel(
                                            category: widget.category,
                                            listofphotos: value,
                                            ) ;
        
            setState(() {
             
       
              photoslist = categorymodel.listofphotos;
           
            });
       
         return categorymodel;
         });

    return null;
 
}





  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    
        print('fetching');
        fetchcategories(pageindexcounter).then((value) async{ 

          // await Future.delayed(Duration(seconds: 1));
          

            isloading = !isloading;
            print('fetching done');
         
          
          });
    
  }


  @override
  Widget build(BuildContext context) {
    
    var positioned = Positioned(
                    bottom: 20.0,
                    width: MediaQuery.of(context).size.width,
                    
    
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                             width: 280.0,
                     
                      
                      decoration: BoxDecoration(
                        
                       
                        
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                       
                        children: [
                          InkWell(
                         
                            child: Icon(Icons.arrow_left_outlined,size: 60.0,color: Colors.pink[300]),
                             onTap: (){
                              
                                  
                                  if(pageindexcounter > 1){
                                     pageindexcounter-=1;
                                     setState(() {
                                    isloading=!isloading;
                                  });
                               
                                    fetchcategories(pageindexcounter).whenComplete(() async{
                                  
                                      await Future.delayed(Duration(milliseconds: 500));
                                      isloading=!isloading;
                                      
                                      
                                   
                                  }
                                  );
                                    
                                  }
                                 
                              
                             }),
                             Transform.rotate(
            // angle: 45.0,
            angle:math.pi / 4.0,
            
                      child:Padding(
                        padding: EdgeInsets.all(15.0),
                        
                                              child: FloatingActionButton(
                backgroundColor: Colors.pink[300],
                elevation: 14.0,
                
            
                splashColor: Colors.pink[400],
                shape: RoundedRectangleBorder(

                    
                  
                ),
                
                child: Transform.rotate(
                  angle:-math.pi / 4.0,
                  child: Text(pageindexcounter.toString(),style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                  )),)
              ),
                      ),
          ),
          InkWell(
            
                           
                            child: Icon(Icons.arrow_right_outlined,size: 60.0,color: Colors.pink[300]),
                             onTap: (){
                              
                                  
                              
                                     pageindexcounter+=1;
                                     setState(() {
                                    isloading=!isloading;
                                  });
                               
                                    fetchcategories(pageindexcounter).whenComplete(() async{
                                  
                                      await Future.delayed(Duration(milliseconds: 500));
                                      isloading=!isloading;
                                      
                                      
                                   
                                  }
                                  );
                                    
                                 
                                 
                              
                             }),
                          
                         
                        ],
                      ),
                    ),
                                  ),
                  );




        return SafeArea(
              child: Scaffold(
                key: _scaffoldkey,
                appBar: AppBar(
                  backgroundColor: Colors.pink[200],
                  title: Text(widget.category,style: TextStyle(color: Colors.white),),
                
                  
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
                    isloading ? Center(child:CircularProgressIndicator(
                       backgroundColor: Colors.pink[300],
                    )) : Stack(
    
                  children: [
                    
                    
                       photoslist.length !=0 ? Column(
                         crossAxisAlignment:  CrossAxisAlignment.center,
                    children:[
    
                      Expanded(
                          child: ImageGrid(photoslist: photoslist, widget: widget,scaffoldkey:_scaffoldkey,),
                      )
    
                    ],
                  ) : Center(child: Text('no results'),),
    
               
              ]
            ),

                  
                  positioned
                ],)
            
           

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
  final Imagesection widget;
  final scaffoldkey;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
    padding: EdgeInsets.all(5.0),
    
    crossAxisCount: 2,
    childAspectRatio: 0.7,
    crossAxisSpacing: 5.0,
    mainAxisSpacing: 10.0,
    children: photoslist.map((photo) => 
    
    Container(
    
      decoration: BoxDecoration(
      
       color: photo.getcolor()
      ),

      child:Stack(
        fit: StackFit.expand,
        children: [
                Image(
      
      image:CacheImage(photo.url),fit: BoxFit.cover,),
      
      Align(
        alignment: Alignment.bottomCenter,
          child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [

            FlatButton(onPressed: ()async{
              savephotoorundo(scaffoldkey,photo);
            }, child: Icon(Icons.favorite_border_rounded,color: Colors.pink[400]),color: Colors.white,),
            FlatButton(onPressed: ()async{

               String result = await setimageasW(context, photo, widget.photourl,false);
                                        
               if(result == 'setwallpaper'){
                         setaswallpaper(photo,widget.photourl,scaffoldkey,false);
                } else if(result == 'addtofav'){
                                            addtofav(photo,widget.photourl,scaffoldkey);
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


//  "To safely refer to a widget's ancestor in its dispose() method, "
//             'save a reference to the ancestor by calling dependOnInheritedWidgetOfExactType() '
//             "in the widget's didChangeDependencies() method."

