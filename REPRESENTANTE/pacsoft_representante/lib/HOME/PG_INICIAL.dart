import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/Appbar.dart';
import 'package:pacsoft_representante/Components/Navegation.dart';

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
      appBar: barra(height: 100),

      body: Container( //MENU DE ATALHO E PESQUISA

               
        child: Column(

          children: [

            Container(
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
            ),
            
              SizedBox(height: 10,),
            Text("Bem Vindo, !", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w300, fontSize: 20),),

              SizedBox(height: 10,),

              Column(
                children: [
                Text("Atalhos", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w800, fontSize: 18,),textAlign: TextAlign.start),
                ],
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                
                children: [
                Column(
                  children: [
                    Image.asset('assets/images/tempo.png',width: 80),
                    Text("Últimos pedidos", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15),),
                  ],
                ),

                Column(
                  children: [
                    Image.asset('assets/images/pendente.png',width: 80),
                    Text("Pedidos pendentes", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15),),
                  ],
                ),
                ]
            ),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                  children: [
                    Image.asset('assets/images/preco.png',width: 80),
                    Text("Preços", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15),),
                  ],
                ),
            
            

                Column(
                  children: [
                    Image.asset('assets/images/comissao.png',width: 80),
                    Text("Comissão", style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15),),
                  ],
                )
              ],
            ),
               
            
            

            Expanded( //LINHA DEBAIXO
              child: Column(
              children: [

                Divider(thickness: 2,color: Colors.black,),
                SizedBox(height: 10,),
                
                Text('Resumo do mês', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w900, fontSize: 20),),
                
                SizedBox(height: 10,),

              Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
                  children: [
                  
                Column(
                  children: [
                      Text('Total de\npedidos', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15),textAlign: TextAlign.center,),
                      Text('25', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w900, fontSize: 50, color: Colors.green[200]),),
                    ],  
                  ),

                Column(
                    children: [
                      Text('Pedidos em\naberto', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15), textAlign: TextAlign.center,),
                      Text('12', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w900, fontSize: 50, color: Colors.green[200]),),
                    ],
                  ),
                  
                
                Column(
                  children: [
                    Text('Pedidos\nentregues', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w500, fontSize: 15),textAlign: TextAlign.center,),
                    Text('13', style: TextStyle(fontFamily: 'Lato', fontWeight: FontWeight.w900, fontSize: 50, color: Colors.green[200]),),
                  ]
              ),
              ]),
              ],
              
            )),
          ],
      ),
      ),
      
      bottomNavigationBar: Navigation()
    );
  }

}