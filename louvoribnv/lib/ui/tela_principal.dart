import 'package:flutter/material.dart';
import 'package:louvoribnv/auth_members/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:louvoribnv/preference/referencia.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:louvoribnv/ui/tela_escala.dart';
import 'dart:async';

import 'package:louvoribnv/ui/tela_repertorio.dart';
import 'package:louvoribnv/ui/tela_sugestao.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class TelaPrincipal extends StatefulWidget {
  TelaPrincipal({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;


  @override
  TelaPrincipalState createState() {
    return new TelaPrincipalState();
  }
}

enum FormType { repertorio, escala, sugestions }

class TelaPrincipalState extends State<TelaPrincipal> {
  DateTime _date = DateTime.now();
  String _dateSelect = "";
  List<BancoDados> _louvor = List();
  BancoDados bancoDados;
  DatabaseReference reference;
  DatabaseReference referenceR;
  FormType _formType = FormType.escala;

  Future _dataSelecionada(BuildContext context) async {
    initializeDateFormatting("pt_BR", null);
    var format = DateFormat.yMMMMd("pt_BR");
    _dateSelect = format.format(DateTime.now());

    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2016),
        lastDate: DateTime(2020));
    if (picked != _date && picked != null) {
      setState(() {
        _dateSelect = format.format(picked);
        print(_dateSelect);
      });
    }
  }

  //telas do drawer
  Widget buildDrawer() {
    switch (_formType) {
      case FormType.escala:
        return TelaEscala();

        case FormType.repertorio:
        return TelaRepertorio();

      case FormType.sugestions:
        return TelaSugestao();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IBNV',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Text("SAIR"),
            onPressed: _signOut,
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('LOUVOR IBNV'),
            ),
            Divider(),
            ListTile(
              title: Text("Repertório"),
              trailing: Icon(Icons.library_music),
              onTap: () {
                setState(() {
                  _formType = FormType.repertorio;
                });

                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text("Escala"),
              trailing: Icon(Icons.people),
              onTap: () {
                setState(() {
                  _formType = FormType.escala;
                });

                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: Text('Sugestões'),
              trailing: Icon(Icons.speaker_notes),
              onTap: () {
                setState(() {
                  _formType = FormType.sugestions;
                });

                Navigator.pop(context);
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: buildDrawer(),
     /* floatingActionButton: FloatingActionButton(
        onPressed: _showAlert,
        child: Icon(Icons.add),
        mini: true,
      ),*/
    );
  }

  void _signOut() async {
    await widget.auth.signOut();
    widget.onSignedOut();
  }

  String dateFormatado() {
    var agora = DateTime.now();
    initializeDateFormatting("pt_BR", null);

    var format = DateFormat.yMMMMd("pt_BR");
    return format.format(agora);
  }

  void _lidarComEscala(Event event) {

    _louvor.add(BancoDados.fromSnapShot(event.snapshot));
  }
}
