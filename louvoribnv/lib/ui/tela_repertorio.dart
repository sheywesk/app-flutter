import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:louvoribnv/preference/referencia.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;

class TelaRepertorio extends StatefulWidget {
  @override
  _TelaRepertorioState createState() => _TelaRepertorioState();
}

class _TelaRepertorioState extends State<TelaRepertorio> {
  String _dateSelect;
  String _dateFormated;
  var _date = DateTime.now();
  var musica1 = TextEditingController();
  var musica2 = TextEditingController();
  var musica3 = TextEditingController();
  var musica4 = TextEditingController();
  var musica5 = TextEditingController();
  var musica6 = TextEditingController();
  DatabaseReference reference;
  var formKey = GlobalKey<FormState>();
  List<BancoDados> listRepertorio = List();
  BancoDados bancoDados;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bancoDados = BancoDados("", "", "", "");

    reference = database.reference().child("Musicas");

    reference.onChildAdded.listen(_lidarComRepertorio);
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
                             title: Text(listRepertorio[index].dataSelect.toString()),
                            subtitle: Text("${listRepertorio[index].repertorio}")));
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
    listRepertorio.add(BancoDados.fromSnapShot(event.snapshot));
  }

  void _abrirDialog() {
    var alert;
    alert = AlertDialog(
      title: Text("Repertório"),
      content: ListView(
        children: <Widget>[
          Center(
            child: Form(
              key: formKey,
              child: Column(
                  children: <Widget>[

                    TextFormField(
                      maxLengthEnforced: false,
                      controller: musica1,
                      //onSaved: (input) => bancoDados.repertorio = [input],
                      decoration: InputDecoration(
                          labelText: 'Musica1'
                      ),
                    ),
                    TextFormField(
                      maxLengthEnforced: false,
                      controller: musica2,
                      //onSaved: (input) => bancoDados.repertorio = [input],
                      decoration: InputDecoration(
                        labelText: 'Musica2',
                      ),
                    ),
                    TextFormField(
                      maxLengthEnforced: false,
                      controller: musica3,
                    //  onSaved: (input) => bancoDados.repertorio = [input],
                      decoration: InputDecoration(
                        labelText: 'Musica3',
                      ),
                    ),
                    TextFormField(
                      maxLengthEnforced: false,
                      controller: musica4,
                      //onSaved: (input) => bancoDados.repertorio = [input],
                      decoration: InputDecoration(
                        labelText: 'Musica4',
                      ),
                    ),
                    TextFormField(
                      controller: musica5,
                      //onSaved: (input) => bancoDados.repertorio = [input],
                      decoration: InputDecoration(
                        labelText: 'Musica5',
                      ),
                    ),
                    TextFormField(
                      controller: musica6,
                      //onSaved: (input) => bancoDados.repertorio = [input],
                      decoration: InputDecoration(
                        labelText: 'Musica6',
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
    bancoDados.repertorio = "${musica1.text}\n"
                          "${musica2.text}\n"
                          "${musica3.text}\n"
                          "${musica4.text}\n"
                          "${musica5.text}\n"
                          "${musica6.text}\n"
                          "________________\n"
                          "Postado em $_dateFormated";

    reference.push().set(bancoDados.toJson());
  }
}

