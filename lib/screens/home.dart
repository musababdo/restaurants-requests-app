
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/screens/catigory.dart';
import 'package:talabat/screens/mymap.dart';

class Home extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  SharedPreferences preferences;
  double lat,lng;
  var _rating = 0.0;

  Future getLatLng() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      lat=preferences.getDouble("lat");
      lng=preferences.getDouble("lng") ;
    });
  }

  Future getResturant()async{
    var url = 'https://talabatdelivery.000webhostapp.com/display_resturant.php';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLatLng();
    getResturant();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop:(){
        Navigator.popAndPushNamed(context, MyMap.id);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:kMainColor,
          title: Text(
            'أختر مطعم',
            style: TextStyle(
                color: Colors.black
            ),
          ),
          actions: <Widget>[
          ],
          leading: GestureDetector(
            onTap: () {
              Navigator.popAndPushNamed(context, MyMap.id);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body:FutureBuilder(
          future: getResturant(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            try {
              if(snapshot.data.length > 0 ){
                return snapshot.hasData ?
                ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Container(
                          height: screenHeight * .18,
                          child: GestureDetector(
                            onTap:(){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => catigory(list: list,index: index,),),);
                            },
                            child: Card(
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(top:8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 8),
                                            child: Text(
                                              list[index]['name'],
                                              style: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          RatingBarIndicator(
//                                        rating:double.parse(list[index]['rate'])==null ?0.0 : double.parse(list[index]['rate']),
                                            rating:double.parse(list[index]['rate']??00.0),
                                            itemBuilder: (context, index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            itemCount: 5,
                                            itemSize: 35.0,
                                            direction: Axis.horizontal,
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Padding(padding: EdgeInsets.only(left: 1)),
                                     Padding(
                                       padding: const EdgeInsets.only(bottom: 4),
                                       child: Image.network(list[index]['image']),
                                     ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                    })
                    : new Center(
                  child: new CircularProgressIndicator(),
                );
              }else{
                return Container(
                  height: screenHeight -
                      (screenHeight * .08) -
                      appBarHeight -
                      statusBarHeight,
                  child: Center(
                    child: Text('لايوجد',
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),
                );
              }
            }catch(e){
              return new Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
