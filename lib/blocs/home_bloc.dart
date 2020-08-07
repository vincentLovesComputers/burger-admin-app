import 'dart:async';

import 'package:burger_world_admin/models/food.dart';
import 'package:burger_world_admin/services/db_api.dart';

class HomeBloc{


  final DatabaseAPi dbApi;

  StreamController<List<Food>> _foodController = StreamController<List<Food>>.broadcast();
  Sink<List<Food>> get addFood => _foodController.sink;
  Stream<List<Food>> get food => _foodController.stream;

  final StreamController<Food> _foodDeleteController = StreamController<Food>.broadcast();
  Sink<Food> get deleteFood => _foodDeleteController.sink;

  HomeBloc(this.dbApi){
    _startListeners();
  }

  void dispose(){
    _foodController.close();
    _foodDeleteController.close();

  }

  void _startListeners() async{
    dbApi.getFoodlist().listen((foodDoc) {
        addFood.add(foodDoc);        
      });

      _foodDeleteController.stream.listen((food) {
        dbApi.deleteFood(food);        
      });


    }
    
  }

