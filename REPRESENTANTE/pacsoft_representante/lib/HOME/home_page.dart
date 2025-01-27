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
        title: Text("BAGSOFT", selectionColor: Colors.black, 
        
        style: TextStyle(
          fontFamily: 'Etno',
          fontWeight: FontWeight.w300,
        ),
        
        ),
        backgroundColor: Colors.green[200],
      ),

      body:Center(
        child: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 250, 239, 233),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
        Image.asset('assets/images/logo.jpg'),
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