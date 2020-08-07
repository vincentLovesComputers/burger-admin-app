
import 'package:cloud_firestore/cloud_firestore.dart';

class Food{
  String documentID;
  String foodName;
  String foodDescription;
  String foodPrice;
  String image;
  List ingredients;
  Timestamp createdAt;
  Timestamp updatedAt;
  Food({this.documentID,this.image,this.createdAt, this.updatedAt, this.foodName, this.foodDescription, this.foodPrice, this.ingredients});

  factory Food.fromDoc(dynamic doc) => Food(
    documentID: doc.documentID,
    foodName: doc["foodName"],
    foodDescription: doc["foodDescription"],
    foodPrice: doc["foodPrice"],
    ingredients: doc["ingredients"],
    image: doc["image"],
    updatedAt: doc["updatedAt"],
    createdAt: doc["createdAt"],

  );

  Map<String, dynamic> toMap(){
    return {
      "documentID": documentID,
      "foodName": foodName,
      "foodDescription": foodDescription,
      "foodPrice": foodPrice,
      "ingredients": ingredients,
      "image": image,
      "updatedAt": updatedAt,
      "createdAt": createdAt,
      
    };
  }
}