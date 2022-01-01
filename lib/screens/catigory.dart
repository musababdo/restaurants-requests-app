

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talabat/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/provider/cartItem.dart';
import 'package:talabat/screens/cartScreen.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/screens/productInfo.dart';

class catigory extends StatefulWidget {
  static String id = 'catigory';
  final List list;
  final int index;
  catigory({this.list,this.index});

  @override
  _catigoryState createState() => _catigoryState();
}

class _catigoryState extends State<catigory> {

  String id,name;
  int _tabBarIndex = 0;
  int _quantity = 1;
  List<Product> sandwitchproducts = [];
  List<Product> juiceproducts = [];
  List<Product> pizzaproducts = [];
  bool visibilityCount = false;

  Future getSandwitch() async {
    var url = 'https://talabatdelivery.000webhostapp.com/display_sandwitch.php';
    var response = await http.post(url, body: {
      "restid": id,
    });
    var data = json.decode(response.body);
    return data;
  }

  Future getJuice() async {
    var url = 'https://talabatdelivery.000webhostapp.com/display_juice.php';
    var response = await http.post(url, body: {
      "restid": id,
    });
    var data = json.decode(response.body);
    return data;
  }

  Future getPizza() async {
    var url = 'https://talabatdelivery.000webhostapp.com/display_pizza.php';
    var response = await http.post(url, body: {
      "restid": id,
    });
    var data = json.decode(response.body);
    return data;
  }

  saveRestName(String restname ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("restname", restname);
      preferences.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id   =  widget.list[widget.index]['id'];
    name =  widget.list[widget.index]['name'];
    //print(name);
    getSandwitch();
    getJuice();
    getPizza();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> cproducts=Provider.of<CartItem>(context).products;
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: new IconThemeData(color: Colors.black),
              elevation: 0,
              title: Text('التصنيفات',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, Home.id);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              actions: <Widget>[
                Stack(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      onPressed: (){
                        Navigator.pushNamed(context, CartScreen.id);
                        //print(widget.list[widget.index]['name']);
                        //print(name);
                      },
                    ),
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: cproducts.length != null,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0,top: 5),
                        child: CircleAvatar(
                          radius: 10.0,
                          child: GestureDetector(
                            onTap:(){
                              Navigator.pushNamed(context, CartScreen.id);
                            },
                            child: Text(
                              cproducts.length.toString()
                              ,
                              style: TextStyle(fontSize: 15,color: Color(0xFFFFFFFF)),
                            ),
                          ),
                          backgroundColor: Color(0xFFA11B00),
                        ),
                      ),
                    )
                  ],
                )
              ],
              bottom: TabBar(
                indicatorColor: kMainColor,
                onTap: (value) {
                  setState(() {
                    _tabBarIndex = value;
                  });
                },
                tabs: <Widget>[
                  Text(
                    'سندوتشات',
                    style: TextStyle(
                        color:
                        _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 0 ? 16 : null),
                  ),
                  Text(
                    'عصائر',
                    style: TextStyle(
                        color:
                        _tabBarIndex == 1 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 1 ? 16 : null),
                  ),
                  Text(
                    'بيتزا',
                    style: TextStyle(
                        color:
                        _tabBarIndex == 0 ? Colors.black : kUnActiveColor,
                        fontSize: _tabBarIndex == 0 ? 16 : null),
                  ),
                ],
              ),
            ),
            body: WillPopScope(
              onWillPop:(){
                //exitDialog();
                Navigator.popAndPushNamed(context, Home.id);
                return Future.value(false);
              },
              child: TabBarView(
                children: <Widget>[
                  FutureBuilder(
                    future: getSandwitch(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .8,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            sandwitchproducts.add(Product(
                                list[index]['id'],
                                list[index]['sandwitch'],
                                list[index]['sandwitch_image'],
                                list[index]['sandwitch_price'],
                                _quantity
                            ));
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ProductInfo.id,
                                    arguments: sandwitchproducts[index]);
                                saveRestName(name);
                              },
                              child: Card(
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Image.network(
                                              sandwitchproducts[index].image),
                                        ),
                                        Positioned(
                                          bottom: 50,
                                          child: Opacity(
                                            opacity: .6,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 100,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    sandwitchproducts[index].name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'SDG ${sandwitchproducts[index].price}سعر القطعه ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                            );
                          })
                          : new Center(child: new CircularProgressIndicator(),
                      );
                    },
                  ),
                  FutureBuilder(
                    future: getJuice(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .8,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            juiceproducts.add(Product(
                                list[index]['id'],
                                list[index]['juice'],
                                list[index]['juice_image'],
                                list[index]['juice_price'],
                                _quantity
                            ));
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ProductInfo.id,
                                    arguments: juiceproducts[index]);
                                saveRestName(name);
                              },
                              child: Card(
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Image.network(
                                              juiceproducts[index].image),
                                        ),
                                        Positioned(
                                          bottom: 50,
                                          child: Opacity(
                                            opacity: .6,
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 100,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    juiceproducts[index].name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'SDG ${juiceproducts[index].price}سعر القطعه ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
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
                    },
                  ),
                  FutureBuilder(
                    future: getPizza(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData
                          ? GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: .8,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            pizzaproducts.add(Product(
                                list[index]['id'],
                                list[index]['pizza'],
                                list[index]['pizza_image'],
                                list[index]['pizza_price'],
                                _quantity
                            ));
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, ProductInfo.id,
                                    arguments: pizzaproducts[index]);
                                saveRestName(name);
                              },
                              child: Card(
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned.fill(
                                          child: Image.network(
                                              pizzaproducts[index].image),
                                        ),
                                        Positioned(
                                          bottom: 50,
                                          child: Opacity(
                                            opacity: .6,
                                            child: Container(
                                              width: MediaQuery.of(context).size.width,
                                              height: 100,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    pizzaproducts[index].name,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    'SDG ${pizzaproducts[index].price}سعر القطعه ',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ),
                              ),
                            );
                          })
                          : new Center(child: new CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
