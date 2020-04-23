import 'dart:developer';
import 'package:coronvavirustracker/LinhadoTempo.dart';
import 'package:coronvavirustracker/Model/Timeline.dart';
import 'package:coronvavirustracker/ListaPaises.dart';
import 'package:coronvavirustracker/Model/Pais.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';



class TelaPrincipal extends StatefulWidget {


  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {



  _atualizarMundo() async {


    String url = "https://api.thevirustracker.com/free-api?global=stats";

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    String testeChave = retorno["results"][0]["total_cases"].toString();
    // String testeChave = retorno["countrydata"]["info"]["title"].toString();
    print("O país éeee: " + testeChave);

    //Mascara para formatação dos milhares
    var f = NumberFormat('#,###', "pt_BR");
    var f2 = NumberFormat('##.##', "pt_BR");
    var d = DateFormat('kk:mm d/MM','pt_BR');

    print("rodei");

    setState(() {

      nomePais = "World";
      totalCasos = f.format(retorno["results"][0]["total_cases"]).toString();
      totalObitos = f.format(retorno["results"][0]["total_deaths"]).toString();
      letalidade = f2.format( ((retorno["results"][0]["total_deaths"]) / (retorno["results"][0]["total_cases"]))*100).toString() + "%";
      childBandeira = Image.asset("imagens/mundo.png", width: 60,height: 60,);
      var now = DateTime.now();
      horaAtualizacao = d.format(now);

    });

  }


  _atualizarCasos() async{

    String country = _textoSalvo;
    print("checando: $country");

    if (country == "-"){
      return _atualizarMundo();
    }


    String url = "https://api.thevirustracker.com/free-api?countryTotal=" + country;

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    //dynamic countryCode = retorno[dropdownValue];
    String testeChave = retorno["countrydata"][0]["info"]["title"].toString();
   // String testeChave = retorno["countrydata"]["info"]["title"].toString();
    print("O país éeee: " + testeChave);

    //Mascara para formatação dos milhares
    var f = NumberFormat('#,###', "pt_BR");
    var f2 = NumberFormat('##.##', "pt_BR");
    var d = DateFormat('hh:mm d/MM','pt_BR');

    setState(() {
      nomePais = retorno["countrydata"][0]["info"]["title"].toString();
      totalCasos = f.format(retorno["countrydata"][0]["total_cases"]).toString();
      totalObitos = f.format(retorno["countrydata"][0]["total_deaths"]).toString();
      letalidade = f2.format( ((retorno["countrydata"][0]["total_deaths"]) / (retorno["countrydata"][0]["total_cases"]))*100).toString() + "%";
      urlBandeira = "https://www.countryflags.io/" + country + "/shiny/64.png";
      childBandeira = Image.network(urlBandeira);
      var now = DateTime.now();
      horaAtualizacao = d.format(now);


    });


  }


  _recuperar() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString("code") ?? "-";
      print("texto lido: $_textoSalvo");
      _atualizarCasos();
    });

  }


  //Variáveis iniciais
 // String dropdownValue = "-";
  String _textoSalvo = "";
  String nomePais ="-";
  String totalCasos = "-";
  String totalObitos = "-";
  String letalidade = "-";
  String urlBandeira = "";
  Widget childBandeira = Container();
  String horaAtualizacao = "--:-- --/--";
  DateFormat formatoHora;
  DateFormat formatoData;
  //var paises = ["-"]; //["BR", "US", "AU", "CA","CH","CL","CN","DK","EU","GB","HK","IN","IS","JP","KR","NZ","PL","RU","SE","SG","TH","TW"]
 // List _paises =[];
 // var _codigoPais = ["-"];


  @override
  void initState() {
    initializeDateFormatting("pt_BR");
    _recuperar();

  }

  @override



  Widget build(BuildContext context) {

    double fatorAjusteGrafico = (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width? 0.53: 0.38 );
    //Widget graficos = Timeline();
    Widget graficos = LinhadoTempo();


    return Scaffold(
      /*appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          opacity: 1
        ),
        backgroundColor: Color(0xff598747),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("CORONAVÍRUS",
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
            Text("TRACKER",
              style: TextStyle(
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: "Righteous",
              ),
            ),
          ],
        ),
      ),*/
      body: Scaffold(
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10,right: 10,left: 10),
                    child: Material(
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Última Atualização",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              fontFamily: "Righteous",
                              color: Color(0xffA6AEB7),
                            ),
                          ),
                          Text(
                            horaAtualizacao,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "Daysone",
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  //Seleção do país
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24),
                      shadowColor: Color(0x802196f3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Selecione o país",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Righteous",
                                  ),
                                ),
                                FlatButton(
                                    onPressed: (){
                                      setState(() {
                                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> ListaPaises()));
                                        //dropdownValue = newValue;
                                        //_atualizarCasos();
                                      });

                                    },
                                    child: Text(
                                      _textoSalvo,
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontFamily: "Daysone",
                                        color: Color(0xff59AA91),
                                      ),
                                    )
                                )
                                ,
                                Text(
                                  nomePais,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    fontFamily: "Daysone",
                                    color: Color(0xff59AA91),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],

                      ),
                    ),
                  ),
                  //Primeiro Card
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24),
                      shadowColor: Color(0x802196f3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Casos Confirmados",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Righteous",
                                  ),
                                ),
                                Text(
                                  totalCasos,
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                    fontFamily: "Daysone",
                                    color: Color(0xff6978FC),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: childBandeira,
                          )
                        ],

                      ),
                    ),
                  ),
                  //Segundo Card
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Material(
                            color: Colors.white,
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(24),
                            shadowColor: Color(0x802196f3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Óbitos",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: "Righteous",
                                        ),
                                      ),
                                      Text(
                                        totalObitos,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 31,
                                          fontFamily: "Daysone",
                                          color: Color(0xffE4B949),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            ),
                          ),
                          Material(
                            color: Colors.white,
                            elevation: 14.0,
                            borderRadius: BorderRadius.circular(24),
                            shadowColor: Color(0x802196f3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Letalidade",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          fontFamily: "Righteous",
                                        ),
                                      ),
                                      Text(
                                        letalidade,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 31,
                                          fontFamily: "Daysone",
                                          color: Color(0xffCD5075),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                 // CircularProgressIndicator(),
                  //Fonte dados
                  /*Padding(
                    padding: EdgeInsets.only(top: 5,left: 20,right: 20),
                    child: Material(
                      color: Colors.white,
                      elevation: 14.0,
                      borderRadius: BorderRadius.circular(24),
                      shadowColor: Color(0x802196f3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Fonte dos dados:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: "Righteous",
                                  ),
                                ),
                                Text(
                                  "TheVirusTracker.com",
                                  style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    fontFamily: "Daysone",
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                      ),
                    ),
                  )*/
                  //Card gráfico
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      child: Material(
                          color: Colors.white,
                          elevation: 14.0,
                          borderRadius: BorderRadius.circular(24),
                          shadowColor: Color(0x802196f3),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: (MediaQuery.of(context).size.width*fatorAjusteGrafico),
                            //height: MediaQuery.of(context).size.height,
                            child: graficos,
                          ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
