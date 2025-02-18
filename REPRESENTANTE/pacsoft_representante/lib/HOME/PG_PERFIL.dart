import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/Barra_superior.dart';

class Pg_Perfil extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return perfil();
  }

}


class perfil extends State<Pg_Perfil>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: barra_superior(height: 100),

      body:
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        Barra_pesquisa(),

      Expanded(child:
      Center(
      child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          
          SizedBox(height: 10,),
          Text('Perfil do Representante', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w900, fontSize: 20,),),
          
          Icon(Icons.account_circle_outlined, size: 150,),
          Text(''),
          ElevatedButton(onPressed: (){

          },
          
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 165, 214, 167),
            foregroundColor: Color.fromARGB(255, 0, 0, 0),
            textStyle: TextStyle(fontSize: 18),
          ),

          child: 
          Text('Editar',
          style: 
          TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w700
          )
          ,
          )
          ),


        SizedBox(height: 5,),
        Text('Nome Completo', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),
          SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          textAlign: TextAlign.center,
          enabled: false,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),


        SizedBox(height: 5,),
        Text('CPF', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),
        SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),
          
        SizedBox(height: 5,),
        Text('CNPJ', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),

        SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),



        SizedBox(height: 5,),
        Text('Telefone', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),

          SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),



        SizedBox(height: 5,),
        Text('Agencia', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),

          SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),


        SizedBox(height: 5,),
        Text('Conta Bancária', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),

        SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),

        SizedBox(height: 5,),
        Text('Chave Pix', style: TextStyle(fontSize: 18,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,),
        ),

                SizedBox(
          width: 300,
          height: 40,
          child:TextField(
          enabled: false,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ),
        ),

        SizedBox(height: 10,),

        ],
      ),
      ),
      ),
      )]
      ),

      bottomNavigationBar: barra_inferior(),  
    );
  }
  
}