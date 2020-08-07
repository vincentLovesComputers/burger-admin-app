import 'package:burger_world_admin/blocs/login_bloc.dart';
import 'package:burger_world_admin/services/auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode emailNode;
  FocusNode passwordNode;

  TextEditingController emailController;
  TextEditingController passwordController;
  LoginBloc _loginBloc;

  @override
  void initState() {    
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailNode = FocusNode();
    passwordNode = FocusNode();
    _loginBloc = LoginBloc(Authentication());
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[200],  
        title: Text("Admin Login", style: TextStyle(color: Colors.white, fontSize: 20.0)),
        centerTitle: true
      ),
      body: SingleChildScrollView(
              child: Container(
          color: Colors.blue[200], 
          height: MediaQuery.of(context).size.height,       
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: Text(
                  "Burger World",
                  
                  ),
              ),

              Form(
                key: _formKey,
                child: Column(
                  children:<Widget>[

                    StreamBuilder<Object>(
                      stream: _loginBloc.email,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0.0),
                          child: TextFormField(
                            focusNode: emailNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Email Address"
                            ),
                            autovalidate: true,
                            onChanged: _loginBloc.emailChanged.add,                            
                          ),
                        );
                      }
                    ),


                    StreamBuilder(
                      stream: _loginBloc.password,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0.0),
                          child: TextFormField(
                            focusNode: passwordNode,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"
                            ),
                            autovalidate: true,
                            onChanged: _loginBloc.passwordChanged.add,
                            ),
                          );
                        },                      
                    ),
                    SizedBox(height: 20.0),


                    _buildLoginButton()


                  ]
                ),
              )
              
            ],
          ),
        ),
      )

      
    );
  }

  Widget _buildLoginButton() {
    return StreamBuilder(
      initialData: "Login",
      stream: _loginBloc.loginOrCreateButton,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.data == "Login"){
          return _buttonLogin();
        }
      },
    );
  }

  Column _buttonLogin(){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:12.0),
          child: StreamBuilder(
            stream: _loginBloc.enableLoginCreateButton,
            builder: (context, snapshot) {
              return RaisedButton(
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.grey.shade200)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Login", style: TextStyle(fontSize: 20.0),),
                ),
                onPressed: () async{

                  _loginBloc.loginOrCreateButtonChanged.add("Login");                  
                  
                });
            }
          ),
        ),

        SizedBox(height:10.0),

        Text(
          "Change password",
          style: TextStyle(fontSize:15.0, color:Colors.red),
        )
      ],
      
    );
  }
}