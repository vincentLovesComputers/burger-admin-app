import 'dart:async';
import 'dart:io';

import 'package:burger_world_admin/models/food.dart';
import 'package:burger_world_admin/services/db_api.dart';

class FoodEditBloc{
  final DatabaseAPi dbApi;
  final bool add;
  Food selectedFood;
  File foodImage;

  final StreamController<String> _foodNameController = StreamController<String>.broadcast();
  Sink<String> get foodNameEditChanged => _foodNameController.sink;
  Stream<String> get foodName => _foodNameController.stream;

  final StreamController<String> _foodDescriptionController = StreamController<String>.broadcast();
  Sink<String> get foodDescriptionChanged => _foodDescriptionController.sink;
  Stream<String> get foodDescription => _foodDescriptionController.stream;

  final StreamController<String> _foodPriceController = StreamController<String>.broadcast();
  Sink<String> get foodPriceChanged => _foodPriceController.sink;
  Stream<String> get foodPrice => _foodPriceController.stream;

  final StreamController<List> _foodIngredientsController = StreamController<List>.broadcast();
  Sink<List> get foodIngredientsChanged => _foodIngredientsController.sink;
  Stream<List> get foodIngredients => _foodIngredientsController.stream;

  final StreamController<File> _getImageUrlController = StreamController<File>.broadcast();
  Sink<File> get imageUrlChanged => _getImageUrlController.sink;
  Stream<File> get imageUrl => _getImageUrlController.stream;

  final StreamController<String> _saveFoodController = StreamController<String>.broadcast();
  Sink<String> get saveFoodChanged => _saveFoodController.sink;
  Stream<String> get saveFood => _saveFoodController.stream;

  FoodEditBloc(this.add, this.selectedFood, this.dbApi){
    _startListeners().then((finished) => getFood(add, selectedFood));
  }

  void dispose(){
    _foodNameController.close();
    _foodDescriptionController.close();
    _foodPriceController.close();
    _saveFoodController.close();
    _foodIngredientsController.close();
    _getImageUrlController.close();

  }

  Future<bool> _startListeners() async{
    _foodPriceController.stream.listen((foodPrice) {
      selectedFood.foodPrice = foodPrice;      
    });

    _foodNameController.stream.listen((foodName) {
      selectedFood.foodName = foodName;      
    });

    _foodDescriptionController.stream.listen((foodDescription) {
      selectedFood.foodDescription = foodDescription;      
    });

    _foodIngredientsController.stream.listen((foodIngredients) {
      selectedFood.ingredients = foodIngredients;
    });

    _getImageUrlController.stream.listen((foodUrl) {
      foodImage = foodUrl;      
    });



    

    _saveFoodController.stream.listen((action) {
      if(action == "Save"){
        _saveFood();
      }      
    });
    return true;
  }

  void _saveFood(){
    Food food = Food(
      documentID: selectedFood.documentID,
      foodName: selectedFood.foodName,
      foodDescription: selectedFood.foodDescription,
      foodPrice: selectedFood.foodPrice,
      ingredients: selectedFood.ingredients,

    );

    add? dbApi.addFood(food, foodImage): dbApi.updateFood(food, foodImage);
  }

  void getFood(bool add, Food food){
    if(add){
      selectedFood = Food();
      selectedFood.foodName = "";
      selectedFood.foodDescription = "";
      selectedFood.foodPrice = "";  
      selectedFood.image = "";
      selectedFood.ingredients = [];    
    }else{
      selectedFood.foodName = food.foodName;
      selectedFood.foodDescription = food.foodDescription;
      selectedFood.foodPrice = food.foodPrice;
      selectedFood.image = food.image;
      selectedFood.ingredients = food.ingredients;
    }

    foodNameEditChanged.add(selectedFood.foodName);
    foodPriceChanged.add(selectedFood.foodPrice);
    foodDescriptionChanged.add(selectedFood.foodDescription);
    imageUrlChanged.add(foodImage);
    foodIngredientsChanged.add(selectedFood.ingredients);
  }



  
}