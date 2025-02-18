import 'package:flutter/material.dart';

class Barra_pesquisa extends StatefulWidget implements PreferredSizeWidget{
  @override
  State<StatefulWidget> createState() {
    return barra();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();

}

class barra extends State<Barra_pesquisa>{
  @override
  Widget build(BuildContext context) {
    return Container(
              color: Colors.green[200],
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.grey),
                    hintText: "Pesquise pela razão social ou CNPJ",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.search),
                    
                    )
                  ),
                ),
              ),
            );
  }
  
}