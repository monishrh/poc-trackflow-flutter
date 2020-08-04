

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_trackflow/flutter_trackflow.dart';

void main() => runApp(HandlePermissionDemo());


HandlePermissionDemoState pageState;




class HandlePermissionDemo extends StatefulWidget {
  @override
  HandlePermissionDemoState createState() {
    pageState = HandlePermissionDemoState();
    return pageState;
  }
}
class HandlePermissionDemoState extends State<HandlePermissionDemo>{
 
  

 @override
  void initState() {
    super.initState();
    initList();
  }


  void initList() async {
    var list=await  PermissionHandler().permissionList();
    list.forEach((item){print(item.group.toString() + item.status.toString());});
 
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
      ),
    );
  }
}

