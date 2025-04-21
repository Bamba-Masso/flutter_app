import 'package:flutter/material.dart';
void main()=> runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home:homePage(),
  )
);

class homePage extends StatelessWidget{
  @override
  Widget build(BuildContext content){
 return Scaffold(
  body: Container(
    padding:EdgeInsets.symmetric(vertical: 30),
    width:double.infinity,
    decoration:BoxDecoration(
      gradient:LinearGradient(
        begin: Alignment.topCenter,
        colors: [
        Colors.orange[900]!,
        Colors.orange[400]!
      ]
      )
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 100,),
          Padding(padding: EdgeInsets.all(5),
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children:<Widget>[
            //  Text("Login", style:TextStyle(color:Colors.white, fontSize: 40),),
            //  SizedBox(height: 10,),
             Text("Bienvenue", style:TextStyle(color:Colors.white, fontSize: 40),)
             ],
          ),
          ),
          SizedBox(height: 10,),
           Expanded(child: Container(
            decoration: BoxDecoration
            (
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(80),topRight: Radius.circular(80)),
             
            ),


            //  child: Padding(
              // padding: EdgeInsets.all(20),
            //   child: Column(
            //     children:<Widget>[
            //       SizedBox(height: 60,),
            //       Container(
            //         padding: EdgeInsets.all(20),
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(10),
            //           boxShadow: [BoxShadow(
            //             color: Color.fromRGBO(225, 95, 27, 3),
            //             blurRadius: 20,
            //             offset: Offset(0, 10)
            //           )]

            //         ),
            //         child: Column(
            //           children:<Widget>[
            //             Container(
            //               decoration: BoxDecoration(
            //                 border: Border(bottom:BorderSide(color:Colors.grey[200]!))
            //               ),


            //             )
            //           ],
            //         ),
            //       )
            //     ],
            //   ),
            //  ),
           ))

        ],
    ),
  )
 
 ) ;
  }
}