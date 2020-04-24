import 'package:flutter/material.dart';
import 'package:bezier_chart/bezier_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:coronvavirustracker/Model/InfoDiaria.dart';


class LinhadoTempo extends StatefulWidget {
  @override
  _LinhadoTempoState createState() => _LinhadoTempoState();
}

class _LinhadoTempoState extends State<LinhadoTempo> {


  List _dadosDiarios = [];
  List<DataPoint> pontosCasos =[];
  DateTime fromDate = DateTime.utc(2019, DateTime.december, 1); //data inicial da API
  DateTime toDate = DateTime.now();


  Future <bool> _atualizarLinhadoTempo(String textoSalvo) async{

    //recupera shared preferences

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textoSalvo = prefs.getString("code") ?? "-";

    });
    print("peguei o: $_textoSalvo");

    var data;
    double novosCasos = 0.0;
    double novasMortes = 0.0;
    double totalCasos = 0.0;
    double totalMortes = 0.0;
    double totalRecuperacao = 0.0;

    String country = _textoSalvo;
    print("olha aqui: $country");
  //  String url = "https://api.thevirustracker.com/free-api?countryTimeline=br";
    String url = "https://api.thevirustracker.com/free-api?countryTimeline=" + country;

    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);


    //Definir data de hoje e subtrair a data inicial para ter os dados , 1/22/20
    var dataHoje = new DateTime.utc(toDate.year, toDate.month, toDate.day); //data hoje limpa
    var dataRotativa = fromDate;

   /* setState(() {
      toDate = dataHoje.subtract(Duration(days: 1));
    });*/

    Duration difference = dataHoje.difference(fromDate);
    int diasBase = difference.inDays; // total de dias a pesquisar

    //Loop para adicionar o JSON na memoria

    for (var i = 0; i <= diasBase; i++){
      dataRotativa = fromDate.add(Duration(days: i));
      var dataRotativaString = formatDate(dataRotativa, [m, '/', dd, '/', yy]).toString(); //mudar data para string para fazer a consulta
     // print(dataRotativaString +": " + retorno["timelineitems"][0][dataRotativaString].toString());

      //Checa o resultado da pesquisa do dia, se nulo adicionar "" para o daily e repetir o dia anterior

      if (retorno["timelineitems"][0][dataRotativaString] == null){

        data = dataRotativa;
        totalCasos = totalCasos;
        totalMortes = totalMortes;
        totalRecuperacao = totalRecuperacao;
        novosCasos = 0.0;
        novasMortes = 0.0;
        print("tamanho: " +pontosCasos.length.toString());

      } else{
        data = dataRotativa;
        novosCasos = retorno["timelineitems"][0][dataRotativaString]["new_daily_cases"].toDouble() as num;
        novasMortes = retorno["timelineitems"][0][dataRotativaString]["new_daily_deaths"].toDouble() as num;
        totalCasos = retorno["timelineitems"][0][dataRotativaString]["total_cases"].toDouble() as num;
        totalMortes = retorno["timelineitems"][0][dataRotativaString]["total_deaths"].toDouble() as num;
        totalRecuperacao = retorno["timelineitems"][0][dataRotativaString]["total_recoveries"].toDouble() as num;

      }

      //Carregar dados na lista da memória e setar no gráfico
      setState(() {
        _dadosDiarios.add(DadoDia(data: data, novosCasos: novosCasos,novasMortes: novasMortes,totalCasos: totalCasos,totalMortes: totalMortes, totalRecuperacao: totalRecuperacao ));
        pontosCasos.add(DataPoint<DateTime>(value: totalCasos, xAxis: dataRotativa));
      });

    }
      return true;
  }



  //Variáveis iniciais
  String _textoSalvo = "";
  Future <bool> _future;


  @override
  void initState() {
    _future = _atualizarLinhadoTempo(_textoSalvo);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    //_recuperar();
    return FutureBuilder<bool>(
        future: _future,
        builder: (context, snapshot){
          switch (snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              print("oh: " + snapshot.toString());
              if (snapshot.hasData){
                print("apareci");
                return Material(
                  child: Center(
                    child: AspectRatio(
                        aspectRatio: (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width? 1.7 : 2.5 ),
                      child: Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        color: Colors.white),
                        child: Padding(
                            padding: EdgeInsets.only(right: 0, left: 0,top: 0,bottom: 0),
                          child: BezierChart(
                            fromDate: fromDate,
                            bezierChartScale: BezierChartScale.WEEKLY,
                            toDate: toDate,
                            selectedDate: toDate,
                            series: [
                              BezierLine(
                                label: "Casos",
                                lineColor: Color(0xff28B4C8),
                                onMissingValue: (dateTime){
                                  if(dateTime.day.isEven){
                                    return 0.0;
                                  }
                                  return 0.0;
                                },
                                data: pontosCasos,
                              ),
                            ],
                            config: BezierChartConfig(
                              verticalIndicatorStrokeWidth: 3.0,
                              verticalIndicatorColor: Colors.black26,
                              pinchZoom: true,
                              showVerticalIndicator: true,
                              verticalIndicatorFixedPosition: false,
                              backgroundColor: Colors.grey,
                              displayDataPointWhenNoValue: false,
                              xLinesColor: Colors.black26,
                              backgroundGradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.white,
                                  Colors.white,
                                  Colors.white,
                                ],
                                /*colors: [
                                  Colors.red[300],
                                  Colors.red[400],
                                  Colors.red[400],
                                  Colors.red[500],
                                  Colors.red,
                                ],*/
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              displayLinesXAxis: true,
                              footerHeight: 60.0,
                              snap: false,
                              displayYAxis: false,
                              //stepsYAxis: 200,
                              xAxisTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                              yAxisTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black26),
                              //bubbleIndicatorColor: Color(0xff28B4C8), // cor da caixa de texto
                              bubbleIndicatorColor: Colors.white.withOpacity(0.9), // cor da caixa de texto
                              bubbleIndicatorLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey,fontFamily: "Righteous",),
                              bubbleIndicatorTitleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blueGrey,fontFamily: "Righteous",),
                              bubbleIndicatorValueStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.blueGrey,fontFamily: "Daysone",),
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                );
              }else{
                print("pobre");
                return Center(
                  child: Text("Nenhum dado a ser exibido"),
                );
              }
              break;
          }
          return Container();
        }
    );
  }
}
