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
        backgroundColor: const Color.fromARGB(255, 165, 214, 167),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 250, 239, 233),
        child: Align(
          alignment: Alignment(0, -1),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start, 
        children:[
        Image.asset('assets/images/logo.png', height: 250, width: 200),
        Text('CPF E CNPJ', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),
        SizedBox(
          width: 300,
          child:TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Digite seu CNPJ ou CPF',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),
        SizedBox(height: 10,),
        Text('SENHA', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),
        SizedBox(
          width: 300,
          child:TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Digite sua senha',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),
        SizedBox(height: 10,),
        botao()]
      ),
      ),
      ),
    );
  }
}

class botao extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:(){
        print("pressionado");
      }, 
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(fontSize: 20),
          backgroundColor: Color.fromARGB(255, 165, 214, 167),
          foregroundColor: Color.fromARGB(255, 0, 0, 0)
      ),
      child: Text("ENTRAR",
       style: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,
        ),)
      );
  } 
}