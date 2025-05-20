import 'package:flutter/material.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_inferior.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_pesquisa.dart';
import 'package:pacsoft_representante/Components/BARRAS%20DE%20PESQUISAS%20E%20DO%20APP/Barra_superior.dart';
import 'package:pacsoft_representante/HOME/RELATORIO/PG_CLIENTESINATIVOS.dart';
import 'package:pacsoft_representante/HOME/RELATORIO/PG_COMISSAOMES.dart';
import 'package:pacsoft_representante/HOME/RELATORIO/PG_TODOSOSPEDIDOSMES.dart';
import 'package:pacsoft_representante/HOME/RELATORIO/PG_TODOSOSPEDIDOSRELATORIO.dart';

class PgRelatorioLista extends StatefulWidget {
  const PgRelatorioLista({super.key, });

  @override
    State<PgRelatorioLista> createState() => _PgRelatorioListaState();

}

class _PgRelatorioListaState extends State<PgRelatorioLista> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barra_superior(height: 100),
      body: Column(
        children: [
          // Barra de pesquisa
          Barra_pesquisa(),
          // Lista de opções
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text('Pedidos por clientes'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgTodosPedidosRelatorio(), // Substitua pelo widget correto
                      ),
                    );
                    // Navegar para a tela de pedidos por clientes
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.green),
                  title: const Text('Pedidos do mês'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgRelatorioPedidosMes(), // Substitua pelo widget correto
                      ),
                    );
                    // Navegar para a tela de pedidos do mês
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.access_time, color: Colors.green),
                  title: const Text('Clientes sem pedidos em 30 dias'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgClientesInativos(), // Substitua pelo widget correto
                      ),
                    );
                    // Navegar para a tela de clientes sem pedidos
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: Colors.green),
                  title: const Text('Comissão por mês'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgComissaoMes(), // Substitua pelo widget correto
                      ),
                    );
                    // Navegar para a tela de comissão por mês
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: barra_inferior()
    );
  }
}