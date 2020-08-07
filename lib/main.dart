import 'package:burger_world_admin/blocs/home_bloc.dart';
import 'package:burger_world_admin/blocs/home_bloc_provider.dart';
import 'package:burger_world_admin/screens/home.dart';
import 'package:burger_world_admin/services/db.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BurgerWorldAdmin());
}

class BurgerWorldAdmin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return HomeBlocProvider(
      homeBloc: HomeBloc(FirestoreDatabase()),
      child: _buildMaterialApp(Home())
    );
  }

  MaterialApp _buildMaterialApp(Widget homePage){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Burger World App',
        theme: ThemeData(),
        home: homePage,
      );
  }
}

