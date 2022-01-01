import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabat/constants.dart';
import 'package:intl/intl.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/provider/cartItem.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/widgets/customdialog.dart';

class CartScreen extends StatefulWidget {
  static String id='cartScreen';
  List<Product> products;

  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen>{

  String name,phone,restname;
  int price;

  SharedPreferences preferences;

  Future getData() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      name=preferences.getString("name");
      restname=preferences.getString("restname");
      phone=preferences.getString("phone") ;
      price=preferences.getInt("price");
    });
    print(name);
    print(restname);
    print(phone);
    print(getTotallPrice(widget.products));
    print(widget.products.length.toString());
    print(formatdate);
  }

  DateTime currentdate=new DateTime.now();
  String formatdate;

  Future orderNow() async{
    var url = "https://talabatdelivery.000webhostapp.com/save_order.php";
    var response=await http.post(url, body: {
      "name"     : name,
      "phone"    : phone,
      "restname" : restname,
      "product"  :widget.products.map((e) => jsonEncode(e.toJson())).toList().toString(),
      "price"    : getTotallPrice(widget.products).toString(),
      "date"     : formatdate
    });
    json.decode(response.body);
    print(response.body);
    //await preferences.clear();
  }

  saveData(int price ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("price", price);
      preferences.commit();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    widget.products=Provider.of<CartItem>(context).products;
    formatdate=new DateFormat('yyyy.MMMMM.dd hh:mm:ss aaa').format(currentdate);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0,
        title: Text(
          'السله',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete,
              color: Colors.black,
            ),
            onPressed: (){
              deleteDialog();
            },
          )
        ],
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('SDG ${getTotallPrice(widget.products)}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text('المبلغ الكلي',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        Builder(
          builder: (context) => ButtonTheme(
            minWidth: screenWidth,
            height: screenHeight * .08,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),
              onPressed: () {
                orderNow();
                //orderDialog();
                Fluttertoast.showToast(
                    msg: "تم ارسال الطلب",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pushNamed(context, Home.id);
                widget.products.clear();
                preferences.remove("restname");
              },
              child: Text('اطلب',
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              color: kMainColor,
            ),
          ),
        ),
      ],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            LayoutBuilder(builder: (context, constrains) {
              if (widget.products.isNotEmpty) {
                return Container(
                  height: screenHeight -
                      statusBarHeight -
                      appBarHeight -
                      (screenHeight * .08),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      /*for(var i = 0; i < products.length; i++){
                            mylist.add(products[i]);
                          }
                          print(mylist.length);*/
                      saveData(getTotallPrice(widget.products));
                      return Padding(
                        padding: const EdgeInsets.all(15),
                        child: Container(
                          height: screenHeight * .15,
                          child: Row(
                            children: <Widget>[
                              Image.network(widget.products[index].image),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            widget.products[index].name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height:3,
                                          ),
                                          Text(
                                            'SDG ${widget.products[index].price}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              ClipOval(
                                                child: Material(
                                                  color: kMainColor,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        widget.products[index].quantity++;
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      child: Icon(Icons.add),
                                                      height: 32,
                                                      width: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                widget.products[index].quantity.toString(),
                                                style: TextStyle(fontSize: 30),
                                              ),
                                              ClipOval(
                                                child: Material(
                                                  color: kMainColor,
                                                  child: GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        if (widget.products[index].quantity > 1) {
                                                          widget.products[index].quantity--;
                                                        }
                                                      });
                                                    },
                                                    child: SizedBox(
                                                      child: Icon(Icons.remove),
                                                      height: 32,
                                                      width: 32,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(bottom:85),
                                        child: GestureDetector(
                                            onTap: (){
                                              Provider.of<CartItem>(context, listen: false)
                                                  .deleteProduct(widget.products[index]);
                                            },
                                            child: Icon((Icons.cancel)
                                            )
                                        )
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          color: kSecondaryColor,
                        ),
                      );
                    },
                    itemCount: widget.products.length,
                  ),
                );
              } else {
                return Container(
                  height: screenHeight -
                      (screenHeight * .08) -
                      appBarHeight -
                      statusBarHeight,
                  child: Center(
                    child: Text('السله فارغه',
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                  ),
                );
              }
            },
            ),
          ],
        ),
      ),

    );
  }
  deleteDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("تنبيه"),
            content: Text('هل تود حذف السله نهائيا '),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("لا")
              ),
              FlatButton(
                  onPressed: (){
                    Provider.of<CartItem>(context, listen: false).deleteAll();
                    Navigator.of(context).pop();
                  },
                  child: Text("نعم")
              ),
            ],
          );
        }
    );
  }
  orderDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) => CustomDialog()
    );
  }
}
getTotallPrice(List<Product> products) {
  var price = 0;
  for (var product in products) {
    price += product.quantity * int.parse(product.price);
  }
  return price;
}
