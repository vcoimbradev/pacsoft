import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return homepagestage();
  }
}

class homepagestage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN", selectionColor: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body:Center(
        child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
        botao()]
      ),
      )
      )
    );
  }
}

class botao extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return ElevatedButton(
      onPressed:(){
        print("pressionado");
      }, 
      child: const Text("ENTRAR")
      );
  }
  
}