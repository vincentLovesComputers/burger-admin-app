
import 'package:burger_world_admin/blocs/editFoodEntry_bloc.dart';
import 'package:burger_world_admin/blocs/edit_bloc_provider.dart';
import 'package:burger_world_admin/blocs/home_bloc.dart';
import 'package:burger_world_admin/blocs/home_bloc_provider.dart';
import 'package:burger_world_admin/models/food.dart';
import 'package:burger_world_admin/screens/editFoodEntry.dart';
import 'package:burger_world_admin/services/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  HomeBloc _homeBloc;
  String pagePurpose = "Dashboard";
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
  }

  @override
  void dispose() {
    _homeBloc.dispose();
    super.dispose();
  }

  void _addOrEditFood({bool add, Food food}){
    SchedulerBinding.instance.addPostFrameCallback((_){
      Navigator.push(context, 
    MaterialPageRoute(
      builder: (BuildContext context) => EditBlocProvider(
        foodEditBloc: FoodEditBloc(add, food, FirestoreDatabase()),
        child: EditFoodEntry(),
      ),
      fullscreenDialog: true
      )
    ); 
    });      
    
      
  }

  Future<bool> _confirmDeleteJournal() async{
      return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Delete Journal"),
            content: Text("Are you sure you would like to delete?"),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCEL"),
                onPressed: (){
                  Navigator.pop(context, false);          
                }),
              FlatButton(
                onPressed: (){
                  Navigator.pop(context, true);
                }, 
                child: Text("DELETE", style: TextStyle(color:Colors.red)))                
            ],
          );
        }
      );
    }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar:  AppBar(
        backgroundColor: Colors.blue[200],
        elevation: 0.0,
        leading: IconButton(
          iconSize: 30,
          icon: Icon(Icons.menu), 
          onPressed: (){}),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              " Admin",
              style: TextStyle(color:Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Text(
              " $pagePurpose",
              style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
          
        ),
        centerTitle: true,

        
              
    ),
      body: SafeArea(              
        child: Column(
          children: <Widget>[
            Container(              
              height:50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                color: Colors.blue[200],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Items",
                    style: TextStyle(fontSize:20.0, color: Colors.white),
                    )
                ],
              ),
              
            ),
            
            SizedBox(height: 20),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[

                      StreamBuilder(
                        stream: _homeBloc.food,
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          else if(snapshot.hasData){
                            
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: _buildGridView(snapshot),
                            );
                            
                          }

                          else{
                            return Center(
                              child: Container(
                                child:Text("Add some Products")
                              )
                            );
                          }
                        }),
                      
                    ],
                  ),
                )
              ) 
              
              
              )
          ],
        )
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () =>
            _addOrEditFood(add: true, food: Food())
          ,
    
        )
   
      
    );}

  

  Widget _buildGridView(AsyncSnapshot snapshot){
    print(snapshot.data);
    return GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: snapshot.data.length,
    
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (_, index)=>
        GridTile(
          
          child: new Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.all(10),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 140,
                    child: InkWell(
                      onTap: () =>  _addOrEditFood(add: false, food: snapshot.data[index]),
                        child: Image.network(
                          snapshot.data[index].image != null ? snapshot.data[index].image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSM0L9jJiPIbjdeXh2zrK4ikZqF0QYbHkLQkQ&usqp=CAU",                 
                          fit: BoxFit.fill,
                            
                           ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left:2,
                   child: IconButton(
                        iconSize: 35,
                        color: Colors.black,
                        icon: Icon(Icons.cancel), 
                        onPressed: () async{
                          //_addOrEditFood(add: false, food: snapshot.data[index]);
                          bool confirmDelete = await _confirmDeleteJournal();

                          if(confirmDelete){
                            _homeBloc.deleteFood.add(snapshot.data[index]);
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomeBlocProvider(
                              homeBloc: HomeBloc(FirestoreDatabase()),
                              child: Home()
                            )));

                          }
                          
                          
                        }),
                    

                  ),
                  Positioned(
                    top: 2,
                    right:2,
                   child: IconButton(
                        iconSize: 20,
                        color: Colors.black,
                        icon: Icon(Icons.edit), 
                        onPressed: (){
                          _addOrEditFood(add: false, food: snapshot.data[index]);
                        }),
                    

                  ),
                  Positioned(
                    bottom:1,
                    left: 10,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            snapshot.data[index].foodName,
                            style: TextStyle(color:Colors.black, fontSize: 15.0),
                            ),
                        
                      ),
                    ),
                  ),
                  
                ],
              ),

            ),

                 

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
                    

            )


            
            
          ),

          
          
      );
  }
}
