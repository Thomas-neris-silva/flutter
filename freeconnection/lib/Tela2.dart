import 'package:flutter/material.dart';
import 'package:flutter_application_1/Tela1.dart';
import 'package:flutter_application_1/Detalhes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabelaPai extends StatefulWidget {
  @override
  Tabela createState() => Tabela();
}

class Tabela extends State<TabelaPai> {
  

  @override
  void initState() {
    super.initState();
    buscarPessoas();
  }
final List<Pessoa> pessoas = [];

Future<void> excluir(String id) async{
  final url = Uri.parse("https://free-839f4-default-rtdb.firebaseio.com/pessoa/$id.json");
  final resposta = await http.delete(url);

  if(resposta.statusCode == 400){
    setState(() {
      pessoas.clear();
      buscarPessoas();
    });

  };
}

  Future<void> buscarPessoas() async {
    final url = Uri.parse(
        "https://free-839f4-default-rtdb.firebaseio.com/pessoa.json");
    final resposta = await http.get(url);
    // decodificando o arquivo json que recebemos
    final Map<String, dynamic>? dados = jsonDecode(resposta.body);
    // se os dados da lista não forem nulos
    if (dados != null) {
      // forEach é o loop de repetição que lista um a um
      dados.forEach((id, dadosPessoa) {
        //aqui atualizar a lista e adicionar a pessoa por vês
        setState(() {
          Pessoa pessoaNova = Pessoa(
              id,
              dadosPessoa["nome"] ?? '',
              dadosPessoa["email"] ?? '',
              dadosPessoa["telefone"] ?? '',
              dadosPessoa["endereco"] ?? '',
              dadosPessoa["cidade"] ?? '');
          pessoas.add(pessoaNova);
        });
      });
    }
  }

  Future<void> abrirWhats(String telefone) async {
    final url = Uri.parse("https://wa.me/$telefone");
    if (!await launchUrl(url)) {
      throw Exception('Não pode iniciar $url');
    }
  }

  //Tabela({required this.pessoas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Contatos"),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: pessoas.length, // Quandidade de itens da lista
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(pessoas[index].nome),
                subtitle: Text(
                  "Email: " + pessoas[index].email
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => abrirWhats(pessoas[index].telefone),
                      icon: Icon(Icons.message, color: Colors.green,),
                    ),
                    IconButton(
                      onPressed: () => excluir(pessoas[index].id),
                      icon: Icon(Icons.restore_from_trash_rounded, color: Colors.red,),
                    ),
                  ],
                ),
                onTap: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context)=> Detalhes(pessoa:pessoas[index])));
                },

              );
            }),
      ),
    );
  }
}
