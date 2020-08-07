import 'package:burger_world_admin/blocs/editFoodEntry_bloc.dart';
import 'package:flutter/material.dart';

class EditBlocProvider extends InheritedWidget{
  final FoodEditBloc foodEditBloc;

  const EditBlocProvider({Key key, Widget child, this.foodEditBloc}): super(key:key, child:child);


  static EditBlocProvider of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(EditBlocProvider) as EditBlocProvider);
  }

  @override
  bool updateShouldNotify(EditBlocProvider old) {
    foodEditBloc != old.foodEditBloc;
  }
}