import 'package:flutter/material.dart';
import 'login.dart';
import 'home.dart';

class Routes{
  Routes(){
    runApp(new MaterialApp(
      title: "Login System",
      debugShowCheckedModeBanner: false,
      home: new Login(),
      onGenerateRoute: (RouteSettings settings){
        switch (settings.name) {
          case '/login':
          return new MyCustomRoute(
            builder: (_) => new Login(),
            settings: settings
          );
          case '/home':
          return new MyCustomRoute(
            builder: (_) => new Home(),
            settings: settings
          );
        }
      },));
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T>{
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
  :super(builder:builder, settings:settings);
}