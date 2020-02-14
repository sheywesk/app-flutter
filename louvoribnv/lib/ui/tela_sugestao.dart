import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:louvoribnv/preference/referencia.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class TelaSugestao extends StatefulWidget {
  @override
  _TelaSugestaoState createState() => _TelaSugestaoState();
}

class _TelaSugestaoState extends State<TelaSugestao> {
  String _dateSelect;
  String _dateFormated;
  var _date = DateTime.now();
  var _sugestao = TextEditingController();

  DatabaseReference reference;
  var formKey = GlobalKey<FormState>();
  List<BancoDados> listSugestao = List();
  BancoDados bancoDados;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bancoDados = BancoDados("", "", "", "");

    reference = database.reference().child("sugestao");

    reference.onChildAdded.listen(_lidarComRepertorio);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: <Widget>[
              Expanded(

                  child :FirebaseAnimatedList(
                      query: reference,
                      itemBuilder: (_, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return Card(
                            child: ListTile(
                                title: Text("Sugestão"),
                                subtitle: Text("${listSugestao[index].sugestao}")));
                      }))

            ],
          )


      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirDialog();
        },
        child: Icon(Icons.add),
        mini: true,
      ),
    );
  }

  void _lidarComRepertorio(Event event) {
    listSugestao.add(BancoDados.fromSnapShot(event.snapshot));
  }

  void _abrirDialog() {
    var alert;
    alert = AlertDialog(
      title: Text("Sugestão"),
      content: ListView(
        children: <Widget>[
          Center(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[

                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: _sugestao,
                    maxLines: null,
                    //onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                        labelText: 'Sugestão'
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  _lidarComSubmit();
                },
                child: Text("SALVAR")),

          ],
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _lidarComSubmit() {
    bancoDados.sugestao = "${_sugestao.text}";
                            //"Postado em $_dateFormated";

    reference.push().set(bancoDados.toJson());
  }
}

