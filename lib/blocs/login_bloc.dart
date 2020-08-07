import 'dart:async';

import 'package:burger_world_admin/resources/validators.dart';
import 'package:burger_world_admin/services/auth_api.dart';

class LoginBloc with Validators{

  final AuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid;
  bool _passwordValid;

  final StreamController<String> _emailController = StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);


  final StreamController<String> _passwordController = StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  


  final StreamController<bool> _enableLoginCreatloginButtonController = StreamController<bool>();
  Sink<bool> get enableLoginCreateButtonChanged => _enableLoginCreatloginButtonController.sink;
  Stream<bool> get enableLoginCreateButton => _enableLoginCreatloginButtonController.stream;

  
  final StreamController<String> _loginOrCreateButtonController = StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged => _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton => _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController = StreamController<String>();
  Sink get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream get loginIrCreate => _loginOrCreateController.stream;

  LoginBloc(this.authenticationApi){
    _startListenersIfEmailAndPasswordAreValid();
  }

  void dispose(){
    _emailController.close();
    _passwordController.close();
    _enableLoginCreatloginButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();


  }

  void _updateEnableLoginCreateButtonStream(){
    if(_emailValid == true && _passwordValid  == true){
      enableLoginCreateButtonChanged.add(true);
    }else{
      enableLoginCreateButtonChanged.add(false);
    }
  }

  void _startListenersIfEmailAndPasswordAreValid(){
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();

    }).onError((error){
      _email = "";
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    password.listen((password) {
      _email = password;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();

    }).onError((error){
      _password = "";
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    loginIrCreate.listen((action) {
      action == "Login" ? _login() : null;      
    });
  }

  Future<String> _login() async{
    String _result = "";
    if(_emailValid && _passwordValid){
      await authenticationApi.signInWithEmailAndPassword(email: _email, password: _password).then((user){
        _result = "Success";
      }).catchError((error){
        _result = error;
      });
      return _result;
    }else{
      return "Email and Password are not valid";
    }

  }












}