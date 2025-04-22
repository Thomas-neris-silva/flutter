
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:http/http.dart' as http;

void main(){
  runApp(Preconfiguracao());
}

class Preconfiguracao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginEstado createState() => LoginEstado();
}

class LoginEstado extends State<Login> {
  final emailControle = TextEditingController();
  final senhaControle = TextEditingController();
  bool estaCarregado = false;
  String mensagemErro = '';
  bool ocultado = true;

  Future<void> logar() async {
    setState(()  { 
      estaCarregado = true;
      mensagemErro = '';

    });
    final url = Uri.parse('https://free-839f4-default-rtdb.firebaseio.com/usuario.json');
    final resposta = await http.get(url);
    // se tudo estiver certo...
    if(resposta.statusCode == 200){
      final Map<String, dynamic>? dados = jsonDecode(resposta.body);

      if(dados != null){
        bool usuarioValido = false;
        String nomeUsuario = '';
        dados.forEach((key,valor){
          if(valor['email'] == emailControle.text && valor['senha'] == senhaControle.text ){
            usuarioValido = true;
            nomeUsuario = valor['nome'];
          }
        });
        if(usuarioValido == true){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Aplicativo(nomeUsuario:nomeUsuario)));
        }
      }
      
    }else{
      setState(() {
        mensagemErro = 'Email ou senha inválidos';
        estaCarregado = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela de Login'), 
      backgroundColor: Colors.lightBlue, foregroundColor: Colors.white,),
      body: Padding(
       padding: EdgeInsets.all(50.0),
        child: Column(
          children: [
           SizedBox(height: 20,), 
            Row( 
              children: [              
                Card.outlined(child: _SampleCard(cardName: 'FreeLancer', nomeIcone: Icons.catching_pokemon,)),
                Card.outlined(child: _SampleCard(cardName: 'Contratador', nomeIcone: Icons.person_pin_rounded,)),
              ],
            ),
                      
            SizedBox(height: 75,),
            TextField(
              controller: emailControle,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: senhaControle,
              obscureText: ocultado,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.blue,
                suffixIcon: IconButton(
                  icon: Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      ocultado = !ocultado; 
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30,),
            estaCarregado ? CircularProgressIndicator() : ElevatedButton(onPressed: logar, child: Text('Entrar')),
            SizedBox(height: 30,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => cadastro()));
            }, child: Text('Não tem uma conta? Cadastre-se'),),

          mensagemErro.isNotEmpty ? Text(mensagemErro, style: TextStyle(color: Colors.red),):SizedBox(),
          ],
        ),
      ),

    );
  }
}
// classe dos cards 
class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName, required this.nomeIcone});
  final String cardName;
  final IconData nomeIcone;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // Centraliza horizontalmente
          children: [
            Icon(nomeIcone, size: 50), // Tamanho do ícone ajustável
            const SizedBox(height: 10), // Espaçamento entre ícone e texto
            Text(
              cardName,
              style: const TextStyle(fontSize: 16), // Ajuste de estilo opcional
            ),
          ],
        ),
      ),
    );
  }
}
// classe cadastro 

class cadastro extends StatefulWidget {
  @override
  cadastroEstado createState() => cadastroEstado();
}

class cadastroEstado extends State<cadastro> {
  final nomecontrole = TextEditingController();
  final emailcontrole = TextEditingController();
  final senhacontrole = TextEditingController();
  bool estaCarregado = false;
  String erro ='';
  bool ocultado = true;

Future<void> cadastrar() async {
  setState(() { estaCarregado = true; });
  final nome = nomecontrole.text;
  final email = emailcontrole.text;
  final senha = senhacontrole.text;

  final url = Uri.parse('https://free-839f4-default-rtdb.firebaseio.com/usuario.json');
  final resposta = await http.post(
    url,
    body:jsonEncode({
      'nome': nome,
      'email': email,
      'senha': senha,
    }),
    headers: {'Content-Type':'application/json'},
  );
  if(resposta.statusCode == 200){
    Navigator.pop(context);
  }else{
    setState(() {
      erro = "Erro ao cadastrar usuário";
    });
    setState(() {
      estaCarregado = false;});
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('cadastro de novo usuário'),
      backgroundColor: Colors.blue, foregroundColor: Colors.black,),
      body: Padding(padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
 Icon(Icons.person_pin, size: 100, color: Colors.blue,),
            SizedBox(height: 20,),
            TextField(
              controller: nomecontrole,
              decoration: InputDecoration(
                labelText: 'Seu Nome',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
              TextField(
              controller: emailcontrole,
              decoration: InputDecoration(
                labelText: 'Seu E-mail',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
                prefixIconColor: Colors.blue,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: senhacontrole,
              obscureText: ocultado,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Colors.blue,
                suffixIcon: IconButton(
                  icon: Icon(ocultado ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      ocultado = !ocultado; 
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30,),

            estaCarregado ? CircularProgressIndicator() : ElevatedButton(
              onPressed: cadastrar, child: Text('cadastrar'),
            ),
            erro.isNotEmpty ? Text(erro, style: TextStyle(color: Colors.red)): SizedBox(),
        ],
      ),
      ),
    );
  }
}

