import 'package:burger_world_admin/blocs/auth_bloc.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationBlocProvider extends InheritedWidget{
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider({Key key, Widget child, this.authenticationBloc}): super(key: key, child: child);

  static AuthenticationBlocProvider of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(AuthenticationBlocProvider) as AuthenticationBlocProvider);    
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) {
    authenticationBloc != old.authenticationBloc;            
  }


}