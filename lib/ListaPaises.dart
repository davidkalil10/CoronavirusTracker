import 'package:coronvavirustracker/Model/Pais.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListaPaises extends StatefulWidget {
  String pesquisa;
  ListaPaises(this.pesquisa);
  int contagemPaises = 0;

  @override
  _ListaPaisesState createState() => _ListaPaisesState();
}

class _ListaPaisesState extends State<ListaPaises> {
  _CarregarPaises() async {
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


    List<Pais> paises = retorno["countryitems"][0].map<Pais>((map) {
      return Pais.fromJson(map);
    }).toList();

    print("resultado lista:" +paises.toString());


    /*for (var i = 1; i < totalPaises; i++){
      print("Nome pais: " + retorno["countryitems"][0][i.toString()]["title"].toString());
      id = retorno["countryitems"][0][i.toString()]["ourid"].toString();
      title = retorno["countryitems"][0][i.toString()]["title"].toString();
      code = retorno["countryitems"][0][i.toString()]["code"].toString();
      print("ID: $id Paisao: $title Paisin: $code");

      //paises.add(Pais(title, code));
    }*/


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
      body: Container(),
    );

    /*return Container(
      child: FutureBuilder<List<InfoPais>>(
        future: _ListarPaises(widget.pesquisa),//valor passado para o metodo da api realizar o filtro
        builder: (context,snapshot){
          return ListView.separated(
            itemBuilder: (ccntext, index){
              List<InfoPais> paises = snapshot.data;
              InfoPais pais = paises[index];

              return GestureDetector(
                onTap: (){},
                child: Row(
                  children: <Widget>[
                    Text("Bandeira"),
                    ListTile(
                      title: Text("Nome grande pais"),
                      subtitle: Text("Sigla pais"),
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context,index) => Divider(
              height: 2,
              color: Colors.grey,
            ),
            itemCount: 10, //tamanho da lista
          );

        },
      ),
    );*/
  }
}
