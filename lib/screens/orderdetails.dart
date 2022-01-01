import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/models/order.dart';
import 'package:talabat/models/product.dart';

class OrderDetails extends StatefulWidget {
  static String id='orderdetails';

  final List list;
  final int index;
  OrderDetails({this.list,this.index});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  String location,marklocation,price,id,date,name,quantity;
  List product=[];
  List<Order> orderList=[];
  var data,image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    location     = widget.list[widget.index]['location'];
    marklocation = widget.list[widget.index]['marklocation'];
    price        = widget.list[widget.index]['price'];
    date         = widget.list[widget.index]['date'];
    //product.add(widget.list[widget.index]['product']);
    //widget.list[widget.index]['product']=product.map((e) => jsonEncode(e.toJson())).toList().toString();
    //print(widget.list[widget.index]['product']);
    //print(product.length);
    data = json.decode(widget.list[widget.index]['product']);
    product = data.map((j) => Product.fromJson(j)).toList();
    for (final item in product) {
      orderList.add(Order(item.id, item.name, item.image, item.quantity));
      //id = item.id;
      //name = item.name;
      //image=item.image;
      //quantity=item.quantity.toString();
    }
    /*final items = (data as List).map((i) => new Product.fromJson(i));
              for (final item in items) {
                id = item.id;
                name = item.name;
                image=item.image;
                quantity=item.quantity.toString();
                print(item.id);
              }*/
    //print(product.length);
  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0,
        title: Text(
          'تفاصيل الطلب',
          style: TextStyle(color: Colors.black),
        ),
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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'SDG ${price.toString()}',
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    '  : السعر',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
              Text(
                date,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                'السله',
                style: TextStyle(color: Colors.black),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        height: screenHeight * .15,
                        child: Row(
                          children: <Widget>[
                            Image.network(orderList[index].image),
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
                                          (orderList[index].name),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          ('${orderList[index].quantity.toString()}  :  الكميه'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        color: kSecondaryColor,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}