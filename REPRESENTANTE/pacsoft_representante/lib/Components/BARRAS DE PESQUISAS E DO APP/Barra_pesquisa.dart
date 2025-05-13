import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pacsoft_representante/HOME/PEDIDOS/PG_PEDIDOS.dart';

class Barra_pesquisa extends StatefulWidget implements PreferredSizeWidget {
  const Barra_pesquisa({super.key});

  @override
  State<StatefulWidget> createState() => _BarraPesquisaState();

  @override
  Size get preferredSize => Size.fromHeight(65);
}

class _BarraPesquisaState extends State<Barra_pesquisa> {
  String filtro = '';
  List<Map> clientes = [];

  @override
  void initState() {
    super.initState();
    carregarClientes();
  }

  Future<void> carregarClientes() async {
    final box = await Hive.openBox('clientes');
    setState(() {
      clientes = box.values.cast<Map>().toList();
    });
  }

  List<Map> get clientesFiltrados => clientes.where((cliente) {
    final razao = (cliente['razao_social'] ?? cliente['razaoSocial'] ?? '').toString().toLowerCase();
    final cnpj = (cliente['cnpj'] ?? '').toString().toLowerCase();
    return razao.contains(filtro.toLowerCase()) || cnpj.contains(filtro.toLowerCase());
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.green[200],
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                ),
              ),
            ),
          ),
        ),
        if (filtro.isNotEmpty)
          Container(
            color: Colors.white,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: clientesFiltrados.length,
              itemBuilder: (context, index) {
                final cliente = clientesFiltrados[index];
                return ListTile(
                  title: Text(cliente['razao_social'] ?? cliente['razaoSocial'] ?? ''),
                  subtitle: Text(
                    '${cliente['cnpj'] ?? ''} - ${cliente['cidade'] ?? ''}',
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PgPedidos(
                          razao_social: cliente['razao_social'] ?? cliente['razaoSocial'] ?? '',
                          cnpj: cliente['cnpj'] ?? '',
                          cidade: cliente['cidade'] ?? cliente['cidadeUf'] ?? '',
                          idCliente: cliente['id_cliente'] ?? cliente['idCliente'] ?? '',
                          idRepresentante: cliente['id_representante'] ?? cliente['idRepresentante'] ?? '',
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}