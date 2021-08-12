import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:kirubel_app/models/list_categories.dart';


const apiAccessKey ='2M0j7iX34tO5unglIZS9lmHBrcDaM2f0ycU9Nr_X2fg';
const myPixabllyApiKey='15435621-d9789d2a3badd6e133f3a7dad';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListOfCategories _listOfCategories=ListOfCategories();
  List<String> images=[];
  String category='all';
  int counter=0;
  ScrollController _scrollController=ScrollController();
  void categorySetter(){
    if(counter<_listOfCategories.categories.length){
      category=_listOfCategories.categories[counter];
      counter++;
    }
  }

  @override
  void initState() {
    super.initState();
    fetch();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
        categorySetter();
        fetch();
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: images.length,
          itemBuilder: (context,index){
          return Container(
            margin: EdgeInsets.all(10.0),
           constraints: MediaQuery.of(context).orientation==Orientation.portrait?
           BoxConstraints.tightFor(height: 250.0)
               :BoxConstraints.tightFor(width: 150.0),
            width: double.infinity,
            child: FittedBox(
              child: Image.network(images[index],fit: BoxFit.fitWidth,),
            ),
          );
      },
      ),
    );
  }
  fetch()async{
    final response=await http.get('https://pixabay.com/api/?key=$myPixabllyApiKey&image_type=photo&category=$category&orientation=horizontal');
    if(response.statusCode==200){
      setState(() {
        var responseBody= json.decode(response.body);
        for(int i=1; i<20; i++){
          images.add(responseBody['hits'][i]['previewURL']);
        }
      });
    }else{
      throw Exception('Failed to load the image');
    }
  }
}










