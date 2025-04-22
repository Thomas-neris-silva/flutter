import 'package:flutter/material.dart';
import 'package:flutter_application_1/Tela1.dart';
import 'package:url_launcher/url_launcher.dart';

class Detalhes extends StatelessWidget {
  final Pessoa pessoa;
  //passando parâmetro da pessoa especifica
  Detalhes({required this.pessoa});
  
ligar(String telefone) async {
  final Uri telefoneUrl = Uri(scheme: "tel", path: telefone);
  if(await canLaunchUrl(telefoneUrl)){
    await launchUrl(telefoneUrl);
  }
}

enviarEmail(String email) async {
  final Uri emailUrl = Uri(scheme: "mailto", path: email);
  if(await canLaunchUrl(emailUrl)){
    await launchUrl(emailUrl);
  }
}

abrirWhats(String telefone) async {
  final Uri whatsUrl = Uri.parse("https://wa.me/$telefone");
  if(await canLaunchUrl(whatsUrl)){
    await launchUrl(whatsUrl);
  }
}

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detalhes do contato"),
      backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 100, color: Colors.blue,),
              SizedBox(height: 20,),
              Text(pessoa.nome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("Nome: ${pessoa.nome}", style: TextStyle(fontSize: 18)),
              Text("Email: ${pessoa.email}", style: TextStyle(fontSize: 18)),
              Text("Telefone: ${pessoa.telefone}", style: TextStyle(fontSize: 18)),
              Text("Endereço: ${pessoa.endereco}", style: TextStyle(fontSize: 18)),
              Text("Cidade: ${pessoa.cidade}", style: TextStyle(fontSize: 18)),

              SizedBox(height: 200), 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(onPressed: () => ligar(pessoa.telefone), icon: Icon(Icons.phone), label: Text("Ligar")),
                  SizedBox(width: 10),
                  ElevatedButton.icon(onPressed: () => enviarEmail(pessoa.email), icon: Icon(Icons.email), label: Text("E-mail")),
                  SizedBox(width: 10),
                  ElevatedButton.icon(onPressed: () => abrirWhats(pessoa.telefone), icon: Icon(Icons.phone_iphone), label: Text("Whatsapp")),
                  SizedBox(width: 10),
                ],
              ),

              

            ],
          ),
        )
      ),

      
    
    );
  }
}