// ignore: file_names
import 'package:flutter/material.dart';

class barra extends StatefulWidget implements PreferredSizeWidget{

  final double height;

  const barra({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  State<StatefulWidget> createState() {
    return Barra();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
 
}

class Barra extends State<barra>{
  @override
  Widget build(BuildContext context) {
    return AppBar(
        titleSpacing: 30,
        toolbarHeight: 100,
        title: Image.asset('assets/images/logo.png', height: 50),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 30),
          child:  SizedBox(
            child: IconButton(onPressed:(){

            }, icon: Icon(Icons.account_circle_outlined,size: 40,)),
          )
        )
        ],
        backgroundColor: Colors.green[200],
      );

  }
  
}