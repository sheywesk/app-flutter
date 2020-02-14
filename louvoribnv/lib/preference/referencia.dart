import 'package:firebase_database/firebase_database.dart';

class BancoDados {
  String key;
  String escala;
  String repertorio;
  String sugestao;
  String dataSelect;

  BancoDados(this.escala,this.repertorio,this.dataSelect,this.sugestao);


  BancoDados.fromSnapShot(DataSnapshot snapshot):
        key = snapshot.key,
        repertorio = snapshot.value['repertorio'],
        escala = snapshot.value['escala'],
        dataSelect = snapshot.value['data'],
        sugestao = snapshot.value['sugestao'];


  toJson() {
    return {
      'escala': escala,
      'data' :dataSelect,
      'repertorio': repertorio,
      'sugestao' : sugestao
    };
  }
}
