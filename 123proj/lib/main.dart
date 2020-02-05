import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Task{
  String Project_name;
  String Peoject_description ;
  String Reward;
  String deadline ;
  String image;


  Task({
    this.Project_name,
    this.Peoject_description,
    this.Reward,
    this.deadline,
    this.image
  });

  factory Task.fromJson(Map<String, dynamic> parsedJson){
    return Task(
        Project_name: parsedJson['Project_name'],
        Peoject_description : parsedJson['Peoject_description'],
        Reward : parsedJson ['Reward'],
        deadline : parsedJson ['deadline'],
        image : parsedJson ['image']
    );
  }
}

class TestHttp extends StatefulWidget {
  final String empId;

  TestHttp({String url}) : empId = url;

  @override
  State<StatefulWidget> createState() => TestHttpState();
} // TestHttp

class TestHttpState extends State<TestHttp> {
  final _formKey = GlobalKey<FormState>();

  Task _entry;

  @override
  void initState() {
    super.initState();
  } //initState

  _sendRequestGet() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save(); //update form data
      print('Try send request');
      http.get('https://github.com/users/proxyou/projects/5').then((response) {
        print(response.body);
        var entriesMap = jsonDecode(response.body);

        _entry = Task.fromJson(entriesMap);


        setState(() {}); //reBuildWidget
      }).catchError((error) {
        print(error);
        setState(() {}); //reBuildWidget
      });
    }
  } //_sendRequestGet

  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                RaisedButton(
                    child: Text('Get first entry'),
                    onPressed: _sendRequestGet,
                    padding: EdgeInsets.all(10.0)),
                SizedBox(height: 20.0),
                Text('Название проекта',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                Text(_entry != null ? _entry.Project_name : ''),
                SizedBox(height: 20.0),
                Text('Описание проекта',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                Text(_entry != null ? _entry.Peoject_description : ''),
                SizedBox(height: 20.0),
                Text('Оплата',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                Text(_entry != null ? _entry.Reward : ''),
                SizedBox(height: 20.0),
                Text('Сроки',
                    style: TextStyle(fontSize: 20.0, color: Colors.blue)),
                Text(_entry != null ? _entry.deadline.toString() : ''),
                SizedBox(height: 20.0),

               Image.network(_entry != null ? _entry.image : '') // out of order


              ],
            )));
  } //build
} //TestHttpState

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Test HTTP API'),
        ),
        body: TestHttp(url: ''));
  }
}

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

