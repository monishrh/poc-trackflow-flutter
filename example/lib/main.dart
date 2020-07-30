

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_trackflow/flutter_trackflow.dart';

void main() => runApp(HandlePermissionDemo());


HandlePermissionDemoState pageState;

class Item {
  PermissionGroup group;
  PermissionStatus status;

  Item(this.group, this.status);
}



class HandlePermissionDemo extends StatefulWidget {
  @override
  HandlePermissionDemoState createState() {
    pageState = HandlePermissionDemoState();
    return pageState;
  }
}
class HandlePermissionDemoState extends State<HandlePermissionDemo>{
    List<Item> list = List<Item>();
  

 @override
  void initState() {
    super.initState();
    initList();
  }


  void initList() {
    list.clear();
    for (var i = 0; i < PermissionGroup.values.length; i++) {
     Future<PermissionStatus> status = PermissionHandler().checkPermissionStatus(PermissionGroup.values[i]);
      status.then((PermissionStatus status) {
        setState(() {
         if(status==PermissionStatus.granted){
      list.add(Item(PermissionGroup.values[i], PermissionStatus.granted));
         }
         else if(status==PermissionStatus.denied){
           list.add(Item(PermissionGroup.values[i], PermissionStatus.denied)); 
         }
         else{
           
         }
         
        });
      });
       continue;
    }
 
  }

 

  permissionItem(int index) {
    return Container(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(index.toString()),
        ),
        title: Text(pageState.list[index].group.toString()),
        subtitle: (pageState.list[index].status != null)
            ? Text(
          pageState.list[index].status.toString(),
          style: statusColors(index),
        )
            : null,
        onTap: () {
          requestPermission(index);
        },
      ),
    );
  }

  statusColors(int index) {
    switch (pageState.list[index].status.value) {
      case 0:
        return TextStyle(color: Colors.blue);
      case 1:
        return TextStyle(color: Colors.red);
      default:
        return TextStyle(color: Colors.grey);
    }
  }

  Future requestPermission(int index) async {
    print("hello");
   
    pageState.initList();
  }
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
              title: Text("Permission List"),
               actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              initList();
            },
          ),
        
        ],
          ),
           body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return permissionItem(index);
        },
      ),
      ),
    );
  }
}

