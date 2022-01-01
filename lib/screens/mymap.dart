import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:android_intent/android_intent.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/screens/tirms.dart';
import 'package:talabat/screens/myorder.dart';
import 'package:talabat/screens/profile.dart';
import 'package:talabat/screens/login.dart';

class MyMap extends StatefulWidget {
  static String id ="map";
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MyMap> {

  MapboxMapController mapController;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LatLng currentPostion;
  Location _location = Location();
  bool visibilityCount = false;
  String name,phone;
  SharedPreferences preferences;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _location.onLocationChanged.listen((l) {
      saveLatLng(l.latitude, l.longitude);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 16),
        ),
      );
      setState(() {
        visibilityCount = true ;
      });
      /*this.mapController.addSymbol(
        SymbolOptions(
            geometry: LatLng(l.latitude, l.longitude),
            iconImage: "assets/marker.png",iconSize: 2),
      );*/
    });
  }

  saveLatLng(double lat,double lng) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setDouble("lat", lat);
      preferences.setDouble("lng", lng);
      preferences.commit();
    });
  }

  Future getUser() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      name=preferences.getString("name");
      phone=preferences.getString("phone") ;
    });
  }

  Future<void> signOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("name");
      preferences.remove("phone");
      preferences.remove("password");
      preferences.remove("id");
      pref.clear();
      Navigator.popAndPushNamed(context, login.id);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationServiceInDevice();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        floatingActionButton: new FloatingActionButton(
//            child:Icon(Icons.location_on),
//            onPressed:(){
//              _location.onLocationChanged.listen((l) {
//                mapController.animateCamera(
//                  CameraUpdate.newCameraPosition(
//                    CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 16),
//                  ),
//                );
//              });
//            }
//        ),
      drawer: new Drawer(
        child: ListView(
            children: <Widget>[
//              DrawerHeader(
//                child: Column(
//                  children: <Widget>[
////                    Text(name !=null?name:"Your name here",style: TextStyle(fontSize: 20),),
////                    Text(phone !=null?phone:"Your phone here",style: TextStyle(fontSize: 20),),
//                  ],
//                ),
//              ),
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: kMainColor,
                ),
                accountName: Text(name !=null?name:"Your name here",style: TextStyle(fontSize: 20),),
                accountEmail: Text(phone !=null?phone:"Your phone here",style: TextStyle(fontSize: 20),),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(children: <Widget>[
                  ListTile(
                    dense: true,
                    title: Text("الملف الشخصي", style: TextStyle(color: Colors.black),),
                    leading: Icon(Icons.person),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context,Profile.id);
                    },
                  ),
                  ListTile(
                    title: Text("طلباتي", style: TextStyle(color: Colors.black),),
                    leading: Icon(Icons.shopping_basket),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context,MyOrder.id);
                    },
                  ),
                  ListTile(
                    title: Text("الشروط و القوانين", style: TextStyle(color: Colors.black),),
                    leading: Icon(Icons.announcement),
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.pushNamed(context,terms.id);
                    },
                  ),
                  ListTile(
                    dense: true,
                    title: Text("تسجيل خروج", style: TextStyle(color: Colors.black),),
                    leading: Icon(Icons.logout),
                    onTap: (){
                      Navigator.pop(context);
                      signOut();
                      Navigator.pushNamed(context,login.id);
                    },
                  ),

                ],),
              ),
            ]
        ),
      ),
        appBar: AppBar(
          backgroundColor:Colors.transparent,
          elevation: 0,
          iconTheme: new IconThemeData(color: Colors.black),
        ),
        body:Stack(
          children: [
            MapboxMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
              const CameraPosition(target: LatLng(0.0, 0.0),
                //zoom: 18
              ),
            ),
            Positioned(
              bottom: 30,
              child: Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: visibilityCount,
                child: Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.only(right: 110,left: 110),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        Navigator.popAndPushNamed(context, Home.id);
                      },
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                        child: Text(
                          'أطلب',
                          style: TextStyle(color: Colors.white,fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }

  locationDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("الموقع"),
            content: Text('يجب تشغيل الموقع لتحديد موقعك'),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("الغاء")
              ),
              FlatButton(
                  onPressed: (){
                    openLocationSetting();
                    Navigator.of(context).pop();
                  },
                  child: Text("موافق")
              ),
            ],
          );
        }
    );
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  Future<void> checkLocationServiceInDevice() async{
    Location location = Location();
    _serviceEnabled=await location.serviceEnabled();
    if(_serviceEnabled){
      _permissionGranted = await location.hasPermission();
      if(_permissionGranted == PermissionStatus.granted){
        //_location= await location.getLocation();
        //print(_location.latitude.toString()+" "+_location.longitude.toString());
        /*location.onLocationChanged.listen((LocationData currentLocation) {
          setState(() {
            currentPostion = LatLng(currentLocation.latitude, currentLocation.longitude);
          });
          //print("my location "+currentLocation.latitude.toString()+" "+currentLocation.longitude.toString());
        });*/
      }
      else{
        _permissionGranted = await location.requestPermission();
        if(_permissionGranted == PermissionStatus.granted){
          print("start allowed");
        }else{
          SystemNavigator.pop();
        }
      }
    }
    else{
      _serviceEnabled=await location.requestService();
      if(_serviceEnabled){
        print("start traking");
      }else{
        SystemNavigator.pop();
      }
    }
  }
}