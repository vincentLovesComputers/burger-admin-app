import 'package:burger_world_admin/blocs/home_bloc.dart';
import 'package:flutter/cupertino.dart';

class HomeBlocProvider extends InheritedWidget{

  final HomeBloc homeBloc;
  final String uid;

  const HomeBlocProvider({Key key, Widget child,this.uid, this.homeBloc}) : super(key: key, child: child);

  static HomeBlocProvider of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(HomeBlocProvider) as HomeBlocProvider);
  }  
  


  @override
  bool updateShouldNotify(HomeBlocProvider old) {
        homeBloc != old.homeBloc;
  }

}