import 'package:flutter/material.dart';

class PgInicial  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return pginicialstage();
  }
  
}

class pginicialstage extends State<PgInicial>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("BAGSOFT", selectionColor: Colors.black, 
        
        style: TextStyle(
          fontFamily: 'Etno',
          fontWeight: FontWeight.w300,
        ),
        ),
        backgroundColor: Colors.green[200],
      ),
    );
  }

}