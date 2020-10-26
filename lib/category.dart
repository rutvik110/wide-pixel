import 'package:flutter/material.dart';

import 'package:wallpaper_app/images.dart';
import 'package:wallpaper_app/photo.dart';

class Categorysection extends StatefulWidget {
  final Photourl photo;
  
  Categorysection({this.photo});
  @override
  _CategorysectionState createState() => _CategorysectionState();
}

class _CategorysectionState extends State<Categorysection> {

   List<List<String>> categoryfinallist = [ 
     
     ['Abstract','assets/images/abstract.jpg',],
     ['Awesome','assets/images/awesome.jpg',],
     ['Wildlife','assets/images/animals.jpg'],
     ['Nature','assets/images/nature.jpg'],
     ['Popular','assets/images/popular.jpg',],     
     ['Candid','assets/images/candid.jpg',],
     ['Space','assets/images/space.jpg',],
     
     
    
     ];

  
  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.pink[200],
              title: Text('Categories',style: TextStyle(color: Colors.white),),
              
            ),
        body: Container(
        
         padding: EdgeInsets.only(
           left: 5.0,right: 5.0,
         ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink[200],
                  Colors.pink[100]
                ],
                transform: GradientRotation(90)
              )
            ),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding:EdgeInsets.only(bottom: 50.0),
            itemCount: categoryfinallist.length,
            itemBuilder: (context,index){
              List<List<String>> categorylist =categoryfinallist;
              return InkWell(
                onTap: (){
                  print(index);
                  Navigator.push(context, MaterialPageRoute(builder: (context){
              return Imagesection(photourl:widget.photo,category:categorylist[index][0],);
            }));
                },
                            child: Categorycontainer(category: categorylist[index][0],assetpath: categorylist[index][1],),
              );

            }),
        )
        
      ),
    );
  }
}

class Categorycontainer extends StatelessWidget {
  final String category;
  final String assetpath;
  Categorycontainer({
    Key key,
    this.category,
    this.assetpath
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 120.0,
                margin: EdgeInsets.symmetric(
                  horizontal: 5.0,vertical: 10.0
                ),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
            
                                
                  image: DecorationImage(
                    
                    image: AssetImage(
                      assetpath,
                    ),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  color: Colors.white,
                  child: Text(category,style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.pink[300],
                 
                    
                  ),),
                ),
              );
  }
}


