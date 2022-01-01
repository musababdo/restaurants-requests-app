
import 'package:flutter/material.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/screens/cartScreen.dart';
import 'package:talabat/provider/cartItem.dart';
import 'package:provider/provider.dart';

class ProductInfo extends StatefulWidget {
  static String id = 'ProductInfo';
  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  int _quantity = 1;
  bool visibilityCount = false;

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    List<Product> cproducts=Provider.of<CartItem>(context).products;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Positioned.fill(
              child: Image.network(
                  product.image),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios)),
                  Stack(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.shopping_cart,
                          color: Colors.black,
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, CartScreen.id);
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
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Column(
              children: <Widget>[
                Opacity(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * .3,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.name,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            'SDG ${product.price}سعر القطعه ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
//                          SizedBox(
//                            height: 7,
//                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipOval(
                                child: Material(
                                  color: kMainColor,
                                  child: GestureDetector(
                                    onTap: add,
                                    child: SizedBox(
                                      child: Icon(Icons.add),
                                      height: 32,
                                      width: 32,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                _quantity.toString(),
                                style: TextStyle(fontSize: 60),
                              ),
                              ClipOval(
                                child: Material(
                                  color: kMainColor,
                                  child: GestureDetector(
                                    onTap: subtract,
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
                  ),
                  opacity: .5,
                ),
                ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .08,
                  child: Builder(
                    builder: (context) => RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      color: kMainColor,
                      onPressed: () {
                        CartItem cartItem=Provider.of<CartItem>(context,listen: false);
                        product.quantity = _quantity;
                        bool exist = false;
                        var productsInCart = cartItem.products;
                        for (var productInCart in productsInCart) {
                          if (productInCart.name == product.name) {
                            exist = true;
                          }
                        }
                        if (exist) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('هذا العنصر موجود في السله'),
                          ));
                        } else {
//                          setState(() {
//                            visibilityCount = true ;
//                          });
                          cartItem.addProduct(product,product.quantity);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('تمت الاضافه الي السله'),
                          ));
                        }
                      },
                      child: Text(
                        'أضف الي السله'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  subtract() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        print(_quantity);
      });
    }
  }

  add() {
    setState(() {
      _quantity++;
      print(_quantity);
    });
  }
}