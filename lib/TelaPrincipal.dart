import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';



class TelaPrincipal extends StatefulWidget {


  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  TextEditingController _controllerPaises = TextEditingController();


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
      childBandeira = Image.asset("imagens/mundo.png", width: 65,height: 65,);
      var now = DateTime.now();
      horaAtualizacao = d.format(now);

    });




  }

  _atualizarDropList() async{

    String url = "https://api.thevirustracker.com/free-api?countryTotals=ALL";

  }


  _atualizarCasos() async{

    String country = dropdownValue;
    String url = "https://api.thevirustracker.com/free-api?countryTotal=" + country;

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);
    dynamic countryCode = retorno[dropdownValue];
    String testeChave = retorno["countrydata"][0]["info"]["title"].toString();
   // String testeChave = retorno["countrydata"]["info"]["title"].toString();
    print("O país éeee: " + testeChave);

    //Mascara para formatação dos milhares
    var f = NumberFormat('#,###', "pt_BR");
    var f2 = NumberFormat('##.##', "pt_BR");

    setState(() {
      nomePais = retorno["countrydata"][0]["info"]["title"].toString();
      totalCasos = f.format(retorno["countrydata"][0]["total_cases"]).toString();
      totalObitos = f.format(retorno["countrydata"][0]["total_deaths"]).toString();
      letalidade = f2.format( ((retorno["countrydata"][0]["total_deaths"]) / (retorno["countrydata"][0]["total_cases"]))*100).toString() + "%";
      urlBandeira = "https://www.countryflags.io/" + country + "/shiny/64.png";
      childBandeira = Image.network(urlBandeira);

      /*Widget childImage;
      try{
        childImage = Image.network(urlBandeira);
        print("deu bom");
        return  childBandeira = childImage;
      } on Error {

        childImage = Image.network("https://www.countryflags.io/AR/shiny/64.png");
        print("deu ruim");
        return childBandeira = childImage;
      }*/






    });



  }



  //Variáveis iniciais
  String dropdownValue = "BR";
  String nomePais ="-";
  String totalCasos = "-";
  String totalObitos = "-";
  String letalidade = "-";
  String urlBandeira = "";
  Widget childBandeira = Container();
  String horaAtualizacao = "--:-- --/--";
  DateFormat formatoHora;
  DateFormat formatoData;

  @override
  void initState() {
    initializeDateFormatting("pt_BR");
    _atualizarMundo();


  }

  @override





  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Scaffold(
        body: Column(
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
                          DropdownButton<String>(
                            value: dropdownValue,
                            onChanged: (String newValue){
                              setState(() {
                                dropdownValue = newValue;
                                _atualizarCasos();
                              });
                            },
                            items: <String>["BR", "US", "AU", "CA","CH","CL","CN","DK","EU","GB","HK","IN","IS","JP","KR","NZ","PL","RU","SE","SG","TH","TW"].map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: "Daysone",
                                    color: Color(0xff59AA91),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
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
                             fontSize: 40,
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
                                    fontSize: 33,
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
                                    fontSize: 33,
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
            )
          ],
        ),
      ),
    );
  }
}
