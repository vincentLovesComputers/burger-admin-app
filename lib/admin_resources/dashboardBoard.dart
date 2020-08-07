import 'dart:io';

import 'package:burger_world_admin/blocs/editFoodEntry_bloc.dart';
import 'package:burger_world_admin/blocs/edit_bloc_provider.dart';
import 'package:burger_world_admin/models/food.dart';
import 'package:burger_world_admin/screens/editFoodEntry.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DashboardForm extends StatefulWidget {

  const DashboardForm({Key key}) : super(key: key);

  @override
  _DashboardFormState createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {

  FocusNode nameFocusNode;
  FocusNode descriptionFocusNode;
  FocusNode _priceFocusNode;
  FoodEditBloc _foodEditBloc;

  TextEditingController _nameController;
  TextEditingController _descriptionController;
  TextEditingController _priceController;
  TextEditingController _ingredientsController = TextEditingController();

  List _ingredients = [];
  Food currentFood;

  bool _isNameValid = false;
  bool _isDescriptionValid = false;
  bool _isPriceValid = false;
  bool _isIngredientsValid = false;
  String error = "";
  Color updateColor = Colors.red;
  String updateAddingIngredients = "";
  Color updateAddingIngredientsColor = Colors.green;

  String _imageUrl;
  File _imageFile;

  final picker = ImagePicker();


  @override
  void initState() {    
    super.initState();   
    
    _nameController = TextEditingController();
    _nameController.text = "";
   
    _descriptionController = TextEditingController();
    _descriptionController.text = "";

    _priceController = TextEditingController();
    _priceController.text = "";

    nameFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    _priceFocusNode = FocusNode();
    //_ingredientsController = TextEditingController();
   // _ingredientsController.text = "";
   

   
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foodEditBloc = EditBlocProvider.of(context).foodEditBloc;
    if(_foodEditBloc != null){
      currentFood = _foodEditBloc.selectedFood;
      
    }else{
      currentFood = Food();
      //print(currentFood);
    }

    if(currentFood.ingredients != null){
      _ingredients.addAll(currentFood.ingredients);
    }
    
    _imageUrl = currentFood.image;
    
  }

  @override
  void dispose() {
    _foodEditBloc.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  _addIngredient(String text){
    if(text.isNotEmpty && _ingredients.contains(text) == false){
      setState(() {
        updateAddingIngredients = "Ingredient addded. You can add more.";
        _ingredients.add(text);
      });}
      else if(_ingredients.contains(text)){
        setState(() {
          updateAddingIngredients = "Ingredient already exists";
          updateAddingIngredientsColor = Colors.red;
        });

      }
        

      
      _foodEditBloc.foodIngredientsChanged.add(_ingredients);
           
      _ingredientsController.clear();
    
  }

  void _addOrUpdateFood(){
  
    _foodEditBloc.saveFoodChanged.add("Save");
    Future.delayed(Duration(milliseconds: 700), (){
      Navigator.pop(context);
    });
  }

  void _getLocalImage() async{
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 400    
    );

    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      _foodEditBloc.imageUrlChanged.add(_imageFile);
    }
  }


  


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Center(
                  child: Column(
                    children: <Widget>[
                      _showImage(),                      
                      _imageFile == null && _imageUrl == null ?
                      RaisedButton(
                        child: Text("Add Food Image"),
                        onPressed: (){
                          _getLocalImage();
                        }) : SizedBox(height: 0),

                    ],
                  )
                  
                ),

                Text(
                  error,
                  style: TextStyle(color:updateColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0),
                  child: StreamBuilder(                    
                    stream: _foodEditBloc.foodName,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        Container();
                      }
                      _nameController.value = _nameController.value.copyWith(text: snapshot.data);
                      return TextField(
                      
                        controller: _nameController,
                        focusNode: nameFocusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Food name",
                          errorText: _isNameValid ? "Name field cannot be empty" : null,
                        ),
                        onChanged: (name) => _foodEditBloc.foodNameEditChanged.add(name),
                        

                      );
                    }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0),
                  child: StreamBuilder(
                    stream: _foodEditBloc.foodDescription,
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                        return Container();
                      }
                      _descriptionController.value = _descriptionController.value.copyWith(text: snapshot.data);
                      return TextField(
                        controller: _descriptionController,
                        focusNode: descriptionFocusNode,
                         decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Food description",
                          errorText: _isDescriptionValid? "Description field cannot be empty" : null,
                        ),
                        onChanged: (description) => _foodEditBloc.foodDescriptionChanged.add(description),
                       // autofocus: true,
                       
                      );
                    }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0),
                  child: StreamBuilder(
                    stream: _foodEditBloc.foodPrice,
                    
                    builder: (context, snapshot) {
                      if(!snapshot.hasData){
                      return Container();
                    }
                    _priceController.value = _priceController.value.copyWith(text: snapshot.data);
                      return TextField(
                        controller: _priceController,
                        focusNode: _priceFocusNode,
                         decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          helperText: "Required",
                          labelText: "Food Price",
                          errorText: _isPriceValid? "Price field cannot be empty" : null,
                        ),
                        //autofocus: true,
                        keyboardType: TextInputType.number,
                        onChanged: (price) => _foodEditBloc.foodPriceChanged.add(price),
                      
                      );
                    }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 0),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width *.4,
                        child: TextField(
                          controller: _ingredientsController,
                          decoration: InputDecoration(
                            labelText: "Ingredient",
                            errorText: _ingredients.isEmpty? "Enter ingredients" : null,
                          ),  
                        ),
                      ),

                      SizedBox(
                        width: 100,
                        child: RaisedButton(
                          color: Colors.blue.shade100,
                            onPressed: () {
                              _addIngredient(_ingredientsController.text);

                              },
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                              ),

                          ),
                      )
                  ],)

                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0,0),
                  child: GridView.count(
                    childAspectRatio: 5/2,
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    scrollDirection: Axis.vertical,
                    children: _ingredients
                      .map((ingredient) => Align(
                          child: Container(
                          height: 50,
                          width: 100,
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),                                                    
                            color: Colors.black26,
                            child: Center(
                              child: Text(
                                ingredient,
                                style: TextStyle(color: Colors.white, fontSize: 16)
                              ),
                            ),
                          ),
                        ),
                      )).toList()
                    
                    ),

                    
                    
                    
                    
                ),
                Text(
                  updateAddingIngredients,
                  style: TextStyle(color:updateAddingIngredientsColor, fontSize: 15, fontWeight: FontWeight.bold),
                ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(90.0, 15.0, 90.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          color: Colors.red,
                          onPressed: (){
                            Navigator.pop(context);                            
                          },
                          child: Text("Cancel"), ),
                             RaisedButton(
                               color: Colors.blue,
                              onPressed: (){
                                setState(() {
                                  _nameController.text.isEmpty ? _isNameValid = true : _isNameValid = false;
                                  _descriptionController.text.isEmpty ? _isDescriptionValid = true : _isDescriptionValid = false;
                                  _priceController.text.isEmpty ? _isPriceValid = true : _isPriceValid = false;
                                  _ingredientsController.text.isEmpty ? _isIngredientsValid = true : _isIngredientsValid = false;

                                });
                                if(_isNameValid || _isDescriptionValid || _isPriceValid || _ingredients.isEmpty){
                                  setState(() {
                                    error = "Fill out all fields";
                                  });                                 

                                }
                                
                                else{
                                  _addOrUpdateFood();   
                                  setState(() {
                                    error = "Product added to database";
                                    updateColor = Colors.green;
                                  });
                                }
                                                                                                         
                              },
                              child: Text("Submit"),
                          
                        ),
                      ],
                    ),
                  )

               

              ],



            ),
            

            
            
        
    );
  }

  Widget _showImage(){
    if(_imageUrl == null && _imageFile == null){
      return Icon(Icons.add_a_photo, size: 60,);
    }else if(_imageFile != null){
      print("Showing image from local file");
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),

          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );

    }else if(_imageUrl != null){
      print("showing image from url");

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            fit: BoxFit.cover,
            height: 250,
            width: 250,
          ),

          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }


}