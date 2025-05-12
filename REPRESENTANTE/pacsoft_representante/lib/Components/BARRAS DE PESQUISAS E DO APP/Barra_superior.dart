// ignore: file_names
import 'package:flutter/material.dart';
import 'package:pacsoft_representante/BANCODEDADOS.dart';
import 'package:pacsoft_representante/HOME/LOGIN/PG_LOGIN.dart';
import 'package:pacsoft_representante/HOME/PERFIL/PG_PERFIL.dart';

class barra_superior extends StatefulWidget implements PreferredSizeWidget{

  final double height;

  const barra_superior({super.key, required this.height});

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

class Barra extends State<barra_superior>{
  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 30,
        toolbarHeight: 100,
        title: Image.asset('assets/images/logo.png', height: 50),
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right: 30),
          child:  SizedBox(
            child: IconButton(onPressed:(){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => Pg_Perfil(), fullscreenDialog: false)
              );
            }, icon: Icon(Icons.account_circle_outlined,size: 40,)),
          )
        ),

        Padding(padding: EdgeInsets.only(right: 30),
          child:  SizedBox(
            child: IconButton(
              onPressed: () {
                // Limpa o usuário logado
                DBHelper.Nomedorepresentante = null;
                // Redireciona para a tela de login e remove todas as telas anteriores
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.logout_outlined, size: 40),
            ),
          )
        )

        ],
        backgroundColor: Color(0xFFA5D6A7),
      );
  }
  
}