import 'package:flutter/material.dart';
import 'package:talabat/provider/cartItem.dart';
import 'package:talabat/provider/mudelHud.dart';
import 'package:talabat/screens/cartScreen.dart';
import 'package:talabat/screens/catigory.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/screens/login.dart';
import 'package:talabat/screens/mymap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/screens/myorder.dart';
import 'package:talabat/screens/orderdetails.dart';
import 'package:talabat/screens/productInfo.dart';
import 'package:talabat/screens/profile.dart';
import 'package:talabat/screens/tirms.dart';
import 'package:talabat/screens/register.dart';
import 'package:talabat/screens/spalshscreen.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Loading....'),
              ),
            ),
          );
        }else {
          isUserLoggedIn = snapshot.data.getBool(kKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModelHud>(
                create: (context) => ModelHud(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: isUserLoggedIn ? SplashScreen.id : login.id,
              //initialRoute: MyMap.id,
              routes: {
                MyOrder.id: (context) => MyOrder(),
                SplashScreen.id: (context) => SplashScreen(),
                MyMap.id: (context) => MyMap(),
                login.id: (context) => login(),
                register.id: (context) => register(),
                Home.id: (context) => Home(),
                ProductInfo.id: (context) => ProductInfo(),
                catigory.id: (context) => catigory(),
                CartScreen.id: (context) => CartScreen(),
                Profile.id: (context) => Profile(),
                OrderDetails.id: (context) => OrderDetails(),
                terms.id: (context) => terms(),
              },
            ),
          );
        }
      },
    );
  }
}