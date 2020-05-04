import 'package:coronvavirustracker/Home.dart';
import 'package:coronvavirustracker/LinhadoTempo.dart';
import 'package:coronvavirustracker/ListaPaises.dart';
import 'package:coronvavirustracker/Model/Timeline.dart';
import 'package:coronvavirustracker/Navegar.dart';
import 'package:coronvavirustracker/TelaPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';


void main() {

  runApp(MaterialApp(
    home: TelaPrincipal(),
    //home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

