import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class cadastrarpostagem extends StatefulWidget {
  final String username;
  cadastrarpostagem({required this.username});
@override
  cadastrarpostagemestado createState() => cadastrarpostagemestado();
   
  }
class cadastrarpostagemestado extends State<cadastrarpostagem>{
  @override
  Widget build(BuildContext context){
    final titulocontrole = TextEditingController();
    final conteudocontrole = TextEditingController();
    final imagemcontrole = TextEditingController();


Future<void> cadastrarpostagem() async {
  final titulo = titulocontrole.text;
  final conteudo = conteudocontrole.text;
  final imagem = imagemcontrole.text;

  if(titulo.isNotEmpty && conteudo.isNotEmpty){
    final url = Uri.parse("https://free-839f4-default-rtdb.firebaseio.com/postagem.json");
    final resposta = await http.post(
      url, body: jsonEncode({
        'titulo': titulo,
        'conteudo': conteudo,
        'imagem': imagem

  }),
    );
  }
}
    return Scaffold(
       appBar: AppBar(
      title: Text('cadastre seu post!',),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      ),
      body: Padding(padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titulocontrole,
            decoration: InputDecoration(labelText: 'titulo de postagem'),
          ),
           TextField(
            controller: conteudocontrole,
            decoration: InputDecoration(labelText: 'conteudo de postagem'),
          ), 
          TextField(
            controller: imagemcontrole,
            decoration: InputDecoration(labelText: 'link de postagem'),
          ), 
          SizedBox(),
          ElevatedButton(onPressed: cadastrarpostagem, child: Text("postar")),

        ],
      ),
      ),
    );
   }
  }

class verpostagens extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ver postagens!",),
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String,dynamic>>>(
        future: null,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text("Erro ao carregar postagens!"),);
          }
          if(snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text("Sem postagens para exibir!"),);
          }
        },
        ),
    );
  }
}