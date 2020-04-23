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
  DateTime fromDate = DateTime.utc(2020, DateTime.april, 1); //data inicial da API
  DateTime toDate = DateTime.now();


  _atualizarLinhadoTempo() async{

    var data;
    double novosCasos ;
    double novasMortes ;
    double totalCasos;
    double totalMortes ;
    double totalRecuperacao ;


    String url = "https://api.thevirustracker.com/free-api?countryTimeline=br";

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

      if (retorno["timelineitems"][0][dataRotativaString].toString() == null){

        data = dataRotativa;
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
        pontosCasos.add(DataPoint<DateTime>(value: novosCasos, xAxis: dataRotativa));
      });

    }

  }


  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _atualizarLinhadoTempo();
    return Material(
      child: Center(
        child: Container(
          color: Colors.blueGrey,
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width /1.5,
          child:BezierChart(
            fromDate: fromDate,
            bezierChartScale: BezierChartScale.WEEKLY,
            toDate: toDate,
            selectedDate: toDate,
            series: [
              BezierLine(
                label: "Casos",
                onMissingValue: (dateTime){
                  if(dateTime.day.isEven){
                    return 10.0;
                  }
                  return 5.0;
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
              backgroundColor: Colors.green,
              footerHeight: 30.0,
              snap: false,
              displayYAxis: false,
              //stepsYAxis: 200,
              xAxisTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              yAxisTextStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              bubbleIndicatorColor: Colors.black, // cor da caixa de texto
              bubbleIndicatorLabelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              bubbleIndicatorTitleStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.green),
              bubbleIndicatorValueStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.green),
            ),
          ),
        ),
      ),
    );
  }
}
