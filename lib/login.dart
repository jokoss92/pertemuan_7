import 'home.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:device_id/device_id.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passController = TextEditingController();

  List data;
  String _deviceid = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.android),
        title: Text('Login Form'),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            _username(context),
            _password(context),
            _buttonLogin(context),
            Text("id :" + _deviceid.toString()),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initDeviceId();
    _cekLogin();
  }

  Future<void> initDeviceId() async {
    String deviceid;

    deviceid = await DeviceId.getID;

    if (!mounted) return;

    setState(() {
      _deviceid = deviceid;
      print('Token : $_deviceid');
    });
  }

  Future _getLogin(String userName, String userPass, String token) async {
    String url = "http://192.168.43.167/apiSikar/index.php/login?userName=" +
        userName +
        "&userPass=" +
        userPass +
        "&token=" +
        token;
        print('URL : $url');
    var res = await http
        .get(Uri.encodeFull(url), headers: {'accept': 'application/json'});

    var response = json.decode(res.body);
    print('responnya : $response');
    setState(() {
      data = response["data"];
    });
    if (response['status'] == true) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLogin", true);
      pref.setString("dataMessage", response['message']);
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isLogin", false);
      pref.setString("dataMessage", response['message']);
      print('object');
    }
  }

  Future _cekLogin() async {
    //SHAREDPREFERENCES
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isLogin")) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new Home()));
    }
  }

  String validatePass(String value) {
    if (value.length < 4) {
      return 'Password Minimal 4 Karakter';
    }
    return null;
  }

  String validateUser(String value) {
    if (value.isEmpty) {
      return 'Username harus diisi';
    }
    return null;
  }

  void _showAlert(String pesan) {
    SweetAlert.show(context,
        title: "ERROR", subtitle: pesan, style: SweetAlertStyle.error);
  }

  void submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      print(nameController.value.text);
      final userName = nameController.value.text;
      final userPass = passController.value.text;
      final token = _deviceid;

      _getLogin(userName, userPass, token);
      FocusScope.of(context).requestFocus(new FocusNode());
      print('tes');

      // Simulate a service call
      Future.delayed(Duration(seconds: 1), () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        if (pref.getBool("isLogin") == true) {
          pref.setString("karNik", data[0]['karNik']);
          pref.setString("karNama", data[0]['karNama']);
          //pindah ke home
          SweetAlert.show(context,
              subtitle: "Checking Username...", style: SweetAlertStyle.loading);
          new Future.delayed(new Duration(seconds: 2), () {
            Navigator.pushReplacementNamed(context, "/home");
          });
        } else {
          String pesan = pref.getString("dataMessage").toUpperCase().toString();
          _showAlert(pesan);
        }
      });
    }
  }

  Widget _username(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: nameController,
        validator: validateUser,
        key: Key('username'),
        decoration:
            InputDecoration(hintText: 'username', labelText: 'username'),
        style: TextStyle(fontSize: 20.0, color: Colors.black),
      ),
    );
  }

  Widget _password(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: passController,
        validator: validatePass,
        key: Key('password'),
        decoration:
            InputDecoration(hintText: 'password', labelText: 'password'),
        style: TextStyle(fontSize: 20.0, color: Colors.black),
        obscureText: true,
      ),
    );
  }

  Widget _buttonLogin(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: new InkWell(
        onTap: () {
          submit();
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
              'Login',
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}