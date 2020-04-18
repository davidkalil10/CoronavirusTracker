import 'package:coronvavirustracker/ListaPaises.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Api{


  Future<List<InfoPais>> pesquisar(String pesquisa) async{

    String url = "https://api.thevirustracker.com/free-api?countryTotals=ALL";
    http.Response response;
    response = await http.get(url);
    Map<String, dynamic> retorno = json.decode(response.body);

    String testeChave = retorno["countryitems"].toString();
    //print("VAIII: " + testeChave);

    List<InfoPais> paises = retorno["countryitems"].map<InfoPais>(
        (map){
          return InfoPais.fromJson(map);
        }
    ).toList();

    return paises;

  }

}

class InfoPais{

  String id;
  String title;
  String code;

  InfoPais({this.id, this.title, this.code});


  factory InfoPais.fromJson(Map<String, dynamic> json){//retorna uma unica instancia, economiza memoria

    //print("id é: " + json["10"]["title"].toString());
    InfoPais(
      id: json["1"]["ourid"],
      title: json["1"]["title"],
      code: json["1"]["code"],
    );
    print("listinha: " + InfoPais().toString());
    return InfoPais();

  }


}
