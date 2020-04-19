import 'package:coronvavirustracker/Model/Pais.dart';
import 'package:coronvavirustracker/TelaPrincipal.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getflutter/getflutter.dart';

class ListaPaises extends StatefulWidget {



  @override
  _ListaPaisesState createState() => _ListaPaisesState();
}

class _ListaPaisesState extends State<ListaPaises> {

  List _paises = [];


  _CarregarPaises() async {
    _paises.add(Pais(title: "World", code: "-"));
    String id;
    String title;
    String code;


    String url = "https://api.thevirustracker.com/free-api?countryTotals=ALL";
    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    int totalPaises = retorno["countryitems"][0].length; //tamanho dos itens

    int i = 1;
    var testeChave =
        retorno["countryitems"][0][i.toString()]["title"].toString();
    // int numPaises = testeChave.length;
    print("VAIII: " + totalPaises.toString());
    print("VAIII: " + testeChave);



    for (var i = 1; i < totalPaises; i++){
      //print("Nome pais: " + retorno["countryitems"][0][i.toString()]["title"].toString());
      id = retorno["countryitems"][0][i.toString()]["ourid"].toString();
      title = retorno["countryitems"][0][i.toString()]["title"].toString();
      code = retorno["countryitems"][0][i.toString()]["code"].toString();
     // print("ID: $id Paisao: $title Paisin: $code");

      setState(() {
        _paises.add(Pais(title: title, code: code));
      });


    }
      print("sera: " + _paises[1].title);

  }

  TextEditingController _controllerPais = TextEditingController();
  String paisEscolhido = "-";

  _salvar() async{

    String paisSelecionado = paisEscolhido;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("code", paisSelecionado);
    print("Salvar: $paisSelecionado");
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> TelaPrincipal()));


  }



  @override
  void initState() {
    _CarregarPaises();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, opacity: 1),
        backgroundColor: Color(0xff598747),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "CORONAVÍRUS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
            /*Text("//",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Righteous",
                ),
            ),*/
            Icon(Icons.assessment),
            Text(
              "TRACKER",
              style: TextStyle(
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: ListView.separated(
            itemBuilder: (context, indice){
              return ListTile(
                leading: GFAvatar(
                  backgroundImage: NetworkImage("https://www.countryflags.io/" + _paises[indice].code.toString() + "/shiny/64.png") ?? Image.asset("imagens/mundo.png"),
                  backgroundColor: Colors.white,
                  shape: GFAvatarShape.standard,
                ),
                onTap: (){
                  print("pais: " + _paises[indice].title);
                  setState(() {
                    paisEscolhido = _paises[indice].code.toString();
                  });
                  _salvar();
                },
                title: Text(
                  _paises[indice].title,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Righteous",
                    )
                ) ,
                subtitle: Text(
                    _paises[indice].code,
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Righteous",
                    )
                ),
              );
            },
            separatorBuilder: (context,indice) => Divider(
              height: 2,
              color: Colors.grey,
            ),
            itemCount: _paises.length
        ),
      ),
    );

  }
}
