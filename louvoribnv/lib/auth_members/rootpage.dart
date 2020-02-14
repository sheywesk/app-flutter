import 'package:flutter/material.dart';
import 'package:louvoribnv/auth_members/auth.dart';
import 'package:louvoribnv/ui/tela_principal.dart';
import 'package:louvoribnv/ui/telalogin.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootPageState();
}
enum AuthStatus{
  notSignedIn,
  signIn
}
class _RootPageState extends State<RootPage> {


  AuthStatus authStatus = AuthStatus.notSignedIn;


  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((userId){
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signIn;
      });
    });
  }
  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.signIn;
    });
  }
  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    switch( authStatus){
      case AuthStatus.notSignedIn:

          return TelaLogin(
            auth: widget.auth,
          onSignedIn: _signedIn,);

          case AuthStatus.signIn:
          return TelaPrincipal(
            auth: widget.auth ,
            onSignedOut: _signedOut);
    }

  }
}
