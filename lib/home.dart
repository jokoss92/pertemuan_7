import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'login.dart';
import 'dart:io';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nik = "";
  String nama = "";

  Future<bool> _onWillPop() {
    SweetAlert.show(context,
        subtitle: "Exit Aplications",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        SweetAlert.show(context,
            subtitle: "Exit...", style: SweetAlertStyle.loading);
        new Future.delayed(new Duration(seconds: 2), () {
          exit(0);
        });
      } else {
        Navigator.of(context).pop(false);
      }
      // return false to keep dialog
      return false;
    });
  }

  Future _cekLogin() async {
    //SHAREDPREFERENCES
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin") == false) {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => new Login()));
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future _Logout() async {
    //SHAREDPREFERENCES
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isLogin", false);
    pref.setString("dataMessage", "");
    pref.setString("karNik", "");
    pref.setString("karNama", "");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => new Login()));
  }

  Future _cekUser() async {
    //SHAREDPREFERENCES
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("karNik") != null) {
      setState(() {
        nik = pref.getString("karNik");
        nama = pref.getString("karNama");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _cekLogin();
    _cekUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.android),
          title: Text("Halaman Home"),
        ),
        body: Center(
            child: Column(
          children: <Widget>[
            //TEXT
            Text("Welcome :" + nik + " - " + nama),
            //BUTTON
            _buttonLogout(context),
          ],
        )),
      ),
    );
  }

  Widget _buttonLogout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: new InkWell(
        onTap: () {
          SweetAlert.show(context,
              subtitle: "Logout...", style: SweetAlertStyle.loading);
          new Future.delayed(new Duration(seconds: 2), () {
            _Logout();
          });
        },
        child: new Container(
          //width: 100.0,
          height: 50.0,
          decoration: new BoxDecoration(
            color: Colors.blueAccent,
            border: new Border.all(color: Colors.white, width: 2.0),
            borderRadius: new BorderRadius.circular(10.0),
          ),
          child: new Center(
            child: new Text(
              'Logout',
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}