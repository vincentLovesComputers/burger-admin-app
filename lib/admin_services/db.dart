import 'dart:io';

import 'package:burger_world_admin/models/food.dart';
import 'package:burger_world_admin/services/db_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class FirestoreDatabase implements DatabaseAPi{

  Firestore _firestore = Firestore.instance;
  String _collection = "burgerStore";
  CollectionReference burgerStoreReference =  Firestore.instance.collection("burgerStore");


  @override
  Stream<List<Food>> getFoodlist(){
    return _firestore
            .collection(_collection) 
                .snapshots()
                  .map((QuerySnapshot snapshot){
                    List<Food> _foodDocs = snapshot.documents.map((doc) => 
                      Food.fromDoc(doc)
                    ).toList();
                    return _foodDocs;
                  });     
    }


  @override
  Future<void> addFood(Food food, File localFile) async{
   if(localFile != null){
     var fileExtension = path.extension(localFile.path);
     var uuid = Uuid().v4();

     final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("food/images/$uuid$fileExtension");
     await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError){
       print(onError);
       return false;
     });

     String url = await firebaseStorageRef.getDownloadURL();
     print("downloaded url: $url" );

     _uploadFood(food, imageUrl: url);
     
   }else{
     print("skipping adding image");
     _uploadFood(food);
     
   }
  }

   Future<bool>_uploadFood(Food food, {String imageUrl}) async{
    food.createdAt = Timestamp.now();

    if(imageUrl != null){
      food.image = imageUrl;
    }
     
    DocumentReference documentReference = await burgerStoreReference.add(food.toMap());
    food.documentID = documentReference.documentID;

    print("successfully uploaded: ${food.toString()}");

    await documentReference.setData(food.toMap(), merge: true);
    return documentReference.documentID != null;
   }
         
  @override
  void updateFood(Food food, File localFile) async{

    if(localFile != null){
     var fileExtension = path.extension(localFile.path);
     var uuid = Uuid().v4();

     final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("food/images/$uuid$fileExtension");
     await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError){
       print(onError);
       return false;
     });

     String url = await firebaseStorageRef.getDownloadURL();
     print("downloaded url: $url" );

     _updateFood(food, imageUrl: url);
     
   }else{
     print("skipping adding image");
     _updateFood(food);
     
   }
  }
   

  _updateFood(Food food, {String imageUrl}) async{
    food.updatedAt = Timestamp.now();
    if(imageUrl != null){
      food.image = imageUrl;      
    }
    await burgerStoreReference.document(food.documentID).updateData(food.toMap()).catchError((onError){
      print(onError);
    });
  }


  
    @override
    void deleteFood(Food food) async{
      await _firestore  
              .collection(_collection)
                .document(food.documentID)
                  .delete()
                    .catchError((error) =>
                    print("Error deletign: $error")
                    );
      
    }

}


  

 
    
  
  
    
  
   

