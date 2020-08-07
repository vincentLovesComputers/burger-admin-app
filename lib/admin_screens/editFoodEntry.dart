import 'package:burger_world_admin/resources/dashboardBoard.dart';
import 'package:flutter/material.dart';

class EditFoodEntry extends StatefulWidget {

  const EditFoodEntry({Key key}): super(key: key);
  @override
  _EditFoodEntryState createState() => _EditFoodEntryState();
}

class _EditFoodEntryState extends State<EditFoodEntry> {

  String pagePurpose = "Add/Edit Products";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
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
              "$pagePurpose",
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
                    "create a new burger",
                    style: TextStyle(fontSize:20.0, color: Colors.white),
                    )
                ],
              ),
              
            ),
            SizedBox(height:20),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height ,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[                                                                                   

                        SizedBox(
                          height:12
                        ),

                        DashboardForm()                                
                    ],
                  ),
                ),
              ),
            ),
          
            
          ],
        ),
      )
      
    );
  }
}


  
