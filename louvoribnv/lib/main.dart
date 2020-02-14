import 'package:flutter/material.dart';
import 'package:louvoribnv/auth_members/auth.dart';
import 'package:louvoribnv/auth_members/rootpage.dart';
import 'package:louvoribnv/ui/telalogin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'IBNV',

        theme: ThemeData(
            primarySwatch: Colors.red
        ),
        home: RootPage(auth: Auth())
    );
  }
}


