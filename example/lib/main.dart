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

class HandlePermissionDemoState extends State<HandlePermissionDemo> {
  @override
  void initState() {
    super.initState();
    initList();
  }

  void initList() async {
    // var list=await  PermissionHandler().permissionList();
    // list.forEach((item){print(item.group.toString() + item.status.toString());});
    var baseUrl = "https://jsonplaceholder.typicode.com";
    var method = "POST";
    var postdata = {"id": 1, "name": 'Moni'};
    int connectTimeout = 5000;
    int receiveTimeout = 3000;
    var list = await PermissionHandler().apiCall(
        "/posts", method, baseUrl, connectTimeout, receiveTimeout, postdata);
    //For URL print(list.request.path);
    // For Response Data print(list.data);
    // For Request body print(list.request.data);
    // For Method print(list.request.data);
    // For Response Headers print(list.headers);
    // For Status Code print(list.statusCode);
    // For  Request Headers print(list.request.headers;

    print(list.request.data);
  }

  Widget build(BuildContext context) {
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
