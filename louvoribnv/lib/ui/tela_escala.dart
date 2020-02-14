import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:louvoribnv/preference/referencia.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class TelaEscala extends StatefulWidget {
  @override
  _TelaEscalaState createState() => _TelaEscalaState();
}

class _TelaEscalaState extends State<TelaEscala> {
  String _dateSelect;
  String _dateFormated;
  var _date = DateTime.now();
  var _voz = TextEditingController();
  var _guitarra = TextEditingController();
  var _teclado = TextEditingController();
  var _bateria = TextEditingController();
  var _violao = TextEditingController();
  var _baixo = TextEditingController();
  DatabaseReference reference;
  var formKey = GlobalKey<FormState>();
  List<BancoDados> listEscala = List();
  BancoDados bancoDados;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bancoDados = BancoDados("", "", "", "");

    reference = database.reference().child("Escalas");

    reference.onChildAdded.listen(_lidarComEscala);
  }
  Future _dataSelecionada(BuildContext context) async {
    initializeDateFormatting("pt_BR", null);
    var format = DateFormat.yMMMMd("pt_BR");
    _dateSelect = format.format(DateTime.now());
    _dateFormated = format.format(_date);
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
                                title: Text(listEscala[index].dataSelect.toString()),
                                subtitle: Text("${listEscala[index].escala}")));
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

  void _lidarComEscala(Event event) {
    listEscala.add(BancoDados.fromSnapShot(event.snapshot));
  }

  void _abrirDialog() {
    var alert;
    alert = AlertDialog(
      title: Text("Escala"),
      content: ListView(
        children: <Widget>[
          Center(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[

                  TextFormField(
                    controller: _voz,
                    //onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                        labelText: 'Voz'
                    ),
                  ),
                  TextFormField(
                    controller: _guitarra,
                    //onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                      labelText: 'Guitarra',
                    ),
                  ),
                  TextFormField(
                    controller: _violao,
                    //  onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                      labelText: 'Violão',
                    ),
                  ),
                  TextFormField(
                    controller: _teclado,
                    //onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                      labelText: 'Teclado',
                    ),
                  ),
                  TextFormField(
                    controller: _baixo,
                    //onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                      labelText: 'Baixo',
                    ),
                  ),
                  TextFormField(
                    controller: _bateria,
                    //onSaved: (input) => bancoDados.repertorio = [input],
                    decoration: InputDecoration(
                      labelText: 'Bateria',
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
            FlatButton(
                onPressed: (){
                  _dataSelecionada(context);
                },
                child: Text("DATA"))
          ],
        ),
      ],
    );
    showDialog(context: context, builder: (_) => alert);
  }

  void _lidarComSubmit() {
    bancoDados.dataSelect = _dateSelect;
    bancoDados.escala = "Voz :${_voz.text}\n"
        "Guitarra : ${_guitarra.text}\n"
        "Violão : ${_violao.text}\n"
        "Teclado : ${_teclado.text}\n"
        "Baixo : ${_baixo.text}\n"
        "Bateria : ${_bateria.text}\n"
        "________________\n"
        "Postado em $_dateFormated";

    reference.push().set(bancoDados.toJson());
  }
}

