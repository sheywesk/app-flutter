import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:louvoribnv/auth_members/auth.dart';
import 'package:flutter/services.dart';


class TelaCadastro extends StatefulWidget {
  TelaCadastro({this.auth,this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  String _senha;
  String _email;
  String _funcao;
  String _nome;
  String _erro ="";
  bool _erroBool= false;
  var _controlSenha = TextEditingController();
  var _controlEmail = TextEditingController();
  var _controlNome = TextEditingController();
  var _controlFuncao = TextEditingController();
  var formKeyt = GlobalKey<FormState>();
  var _scalffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scalffoldKey,
      appBar: AppBar(
        title: Text('Cadastro',
          style: TextStyle(
              color: Colors.white
          ),),

      ),
      body: Container(
        child: ListView(
          children: <Widget>[

            Form(
              key: formKeyt,

              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      TextFormField(
                        onSaved: (value) => _nome = value,
                        validator: (value) =>
                        value.isEmpty ? "Preencha os campos" : null,
                        controller: _controlNome,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Nome',
                            labelStyle: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 15),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          onSaved: (value) => _email = value,
                          controller: _controlEmail,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              labelText: 'Email',
                              labelStyle: TextStyle(fontSize: 20)),
                        ),
                      ),
                      TextFormField(

                        validator: (arg) =>
                        arg.isEmpty ? "Preencha os campos" : null,
                        onSaved: (value) => _senha = value,
                        controller: _controlSenha,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Senha',
                            labelStyle: TextStyle(fontSize: 20)),
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: TextFormField(

                          validator: (value) =>
                          value.isEmpty ? "Preencha os campos" : null,
                          onSaved: (value) => _funcao = value,
                          controller: _controlFuncao,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              labelText: 'Função',
                              hintText: 'guitarrista,tecladista',
                              labelStyle: TextStyle(fontSize: 20)),
                        ),
                      ),
                      FlatButton(
                          padding: const EdgeInsets.only(top: 40),

                          onPressed: _criarCadastro,

                          child: Text('CADASTRAR', style: TextStyle(
                              color: Colors.redAccent, fontSize: 15),))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  bool _validateAndSave() {

    if(formKeyt.currentState.validate()) {
      formKeyt.currentState.save();
      return true;
    }
    return false;
  }


  void _criarCadastro() async {
   try {
     if (_validateAndSave()) {
       cadastroEfetuado();
       formKeyt.currentState.save();
       //String userId = await widget.auth.createUserWithEmailAndPassword(_email,_senha) ;
       FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _senha);
       Navigator.pop(context);
     }

   }on PlatformException catch(e) {
          if(e.message == 'The email address is already in use by another account.'){
            _erroBool = false;
            cadastroEfetuado();
          }
   }
  }
  void cadastroEfetuado() {
    final snackbar = SnackBar(

        content:_erroBool == true? Row(
          children: <Widget>[
            CircularProgressIndicator(),
            Text("  Efetuando cadastro"),
          ],
        ): Text("Este endereço de email ja está sendo usado.")

    );
    _scalffoldKey.currentState.showSnackBar(snackbar);
  }
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Email inválido';
    else
      return null;
  }
}