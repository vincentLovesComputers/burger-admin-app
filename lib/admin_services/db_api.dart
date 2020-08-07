import 'dart:io';

import 'package:burger_world_admin/models/food.dart';

abstract class DatabaseAPi{
  Stream<List<Food>> getFoodlist();
  Future<void> addFood(Food food, File localFile);
  void updateFood(Food foo, File localFile);
  void deleteFood(Food food);
}