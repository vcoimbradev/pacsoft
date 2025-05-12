import 'package:flutter/material.dart';

class Barra_pesquisa extends StatefulWidget implements PreferredSizeWidget{
  const Barra_pesquisa({super.key});

  @override
  State<StatefulWidget> createState() {
    return barra();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();

}

class barra extends State<Barra_pesquisa>{
  String filtro = '';

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
                  onChanged: (value) {
                    setState(() {
                      filtro = value;
                    });
                  },
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
  
  List<Map<String, String>> clientes = [
    {'razaoSocial': 'Empresa A', 'cnpj': '12345678901234'},
    {'razaoSocial': 'Empresa B', 'cnpj': '23456789012345'},
    // Adicione mais clientes conforme necessário
  ];

  List<Map<String, String>> get clientesFiltrados => clientes.where((cliente) =>
    cliente['razaoSocial']!.toLowerCase().contains(filtro.toLowerCase()) ||
    cliente['cnpj']!.toLowerCase().contains(filtro.toLowerCase())
  ).toList();
}