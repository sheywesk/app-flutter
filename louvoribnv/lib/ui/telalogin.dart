import 'package:flutter/material.dart';
import 'package:louvoribnv/auth_members/auth.dart';
import 'package:louvoribnv/ui/tela_cadastro.dart';
import 'package:louvoribnv/ui/tela_principal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class TelaLogin extends StatefulWidget {
  TelaLogin({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new TelaLoginState();
}

enum FormType { login, register }

class TelaLoginState extends State<TelaLogin> {
  final _scalffoldKey = GlobalKey<ScaffoldState>();
  var _controlEmail = TextEditingController();
  var formKey = GlobalKey<FormState>();
  var _controlSenha = TextEditingController();
  FormType formType = FormType.login;
  String _email;
  String _senha;
  String _erros = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scalffoldKey,
        backgroundColor: Colors.white,
        body: Container(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          buildImages() + buildInputs() + buildSubmitButtons()),
                ),
              ),
            ],
          ),
        ));
  }

  bool _validateAndSave() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        loginEfetuado();
        String userId = await widget.auth
            .signInWithEmailAndPassword(_controlEmail.text, _controlSenha.text);
        widget.onSignedIn();
      } on PlatformException catch (e) {
        print("Erro : ${e.message}");
        if (e.message ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          _erros = "Email ou senha incorretos ";
        }
        if (e.message ==
            'A network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          _erros = 'Problemas com sua conexão';
        }
        if (e.message ==
            'The password is invalid or the user does not have a password.') {
          _erros = 'Senha incorreta';
        }
        final snackbar = SnackBar(content: Text(_erros));
        _scalffoldKey.currentState.showSnackBar(snackbar);
      }
    }
  }

  void moveCadastro() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => TelaCadastro()));
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => _email = value,
        validator: (value) => value.isEmpty ? "Preencha os campos" : null,
        controller: _controlEmail,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            labelText: 'Email',
            labelStyle: TextStyle(fontSize: 20)),
      ),
      Padding(
        padding: const EdgeInsets.only(
          top: 15.0,
        ),
        child: TextFormField(
          onSaved: (value) => _senha = value,
          validator: (value) => value.isEmpty ? "Preencha os campos" : null,
          controller: _controlSenha,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              labelText: 'Senha',
              labelStyle: TextStyle(fontSize: 20)),
          obscureText: true,
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Center(
          child: FlatButton(
            onPressed: () {
              validateAndSubmit();
            },
            child: Text(
              "ENTRAR",
              style: TextStyle(color: Colors.redAccent, fontSize: 15),
            ),
          ),
        ),
      ),
      FlatButton(
          onPressed: moveCadastro,
          child: Text(
            "Não tem conta? Clique aqui",
            style: TextStyle(fontSize: 15),
          ))
    ];
  }

  void loginEfetuado() {
    final snackbar = SnackBar(
        content: Row(
      children: <Widget>[
        CircularProgressIndicator(),
        Text("  Efetuando login"),
      ],
    ));
    _scalffoldKey.currentState.showSnackBar(snackbar);
  }

  List<Widget> buildImages() {
    return [
      Image.asset(
        "imagens/ibnv.png",
        height: 250,
      ),
    ];
  }
}
