import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/screens/mymap.dart';
import 'package:talabat/provider/mudelHud.dart';
import 'package:talabat/screens/myorder.dart';
import 'package:talabat/screens/register.dart';
import 'package:talabat/widgets/customTextView.dart';

class DataInfo {
  //Constructor
  String id;
  String username;
  String password;
  String phone;

  DataInfo.fromJson(Map json) {
    this.id       = json['id'];
    this.username = json['username'];
    this.password = json['password'];
    this.phone    = json['phone'];
  }
}

class login extends StatefulWidget {
  static String id = 'LoginScreen';
  @override
  loginState createState() => loginState();
}

class loginState extends State<login> {
  String _username, password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;
  int value;
  bool keepMeLoggedIn = false;

  Future login() async {
    var url = "https://talabatdelivery.000webhostapp.com/login.php";
    try {
      var response = await http.post(url, body: {
        "username": _username.trim(),
        "password": password.trim(),
      });
      var data = json.decode(response.body);
      String success = data['success'];
      if (success == "1") {
        setState(() {
          final items = (data['login'] as List).map((i) => new DataInfo.fromJson(i));
          for (final item in items) {
            savePref(item.username, item.password, item.phone, item.id);
          }
        });
          Navigator.popAndPushNamed(context, MyMap.id);
      } else {
        Fluttertoast.showToast(
            msg: "هنالك خطاء ما",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }catch(e){
      setState(() {
        _state = 0;
      });
      errorDialog();
    }
  }
  errorDialog(){
    showDialog(context: context,
        builder: (context){
          return AlertDialog(
            content: Text('اسم المستخدم او كلمه المرور خطاء'),
            actions: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("حسنا")
              ),
            ],
          );
        }
    );
  }
  savePref(String name,String password,String phone,String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("name", name);
      preferences.setString("password", password);
      preferences.setString("phone", phone);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  bool _secureText = true;
  void showSecure() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  SharedPreferences preferences;
  saveValue(int value) async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
    });
  }

  Future getValue() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {

      }else{
        showTerms();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: WillPopScope(
        onWillPop:(){
          SystemNavigator.pop();
          return Future.value(false);
        },
        child: ModalProgressHUD(
          inAsyncCall: Provider.of<ModelHud>(context).isLoading,
          //inAsyncCall: false,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: height * .2,
                ),
                CustomTextField(
                  onClick: (value) {
                    _username = value;
                  },
                  hint: 'الاسم',
                  icon: Icons.person,
                ),
                SizedBox(
                  height: height * .01,
                ),
                CustomTextField(
                  showHide:showSecure,
                  onClick: (value) {
                    password = value;
                  },
                  hint: 'كلمه المرور',
                  icon: Icons.lock,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          checkColor: kSecondaryColor,
                          activeColor: kMainColor,
                          value: keepMeLoggedIn,
                          onChanged: (value) {
                            setState(() {
                              keepMeLoggedIn = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'تذكرني ',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Builder(
                    builder: (context) => FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () {
                        if (_state == 0) {
                          animateButton();
                        }
                        if (keepMeLoggedIn == true) {
                          keepUserLoggedIn();
                        }
//
                        if (_globalKey.currentState.validate()){
                          _globalKey.currentState.save();
                          try{
                            login();
                          }on PlatformException catch(e){
//
                          }
                        }else{
                          setState(() {
                            _state = 0;
                          });
                        }
                      },
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: setUpButtonChild(),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * .05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>register(),),);
                      },
                      child: Text(
                        'انشاء حساب   ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      'ليس لديك حساب ؟',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLoggedIn, keepMeLoggedIn);
  }
  Widget setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        'تسجيل دخول',
        style: TextStyle(color: Colors.white),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }
  void animateButton() {
    setState(() {
      _state = 1;
    });
  }
  showTerms() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (context, setState)
              {
                return AlertDialog(
                  title: Text('الشروط و القوانين'),
                  content:SingleChildScrollView(
                    child: Container(
                      height: 220,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("1- في حاله تم قبول الطلب من قبل Delivery Man وتم تسليم الطلب للعميل ورفضه العميل يقوم بدفع نصف سعر الطلب الكلي"
                            ,style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          Text("2- يجب عليك دفع سعر الطلب في حاله تأكيدك للطلب بقصد او بغير قصد"
                              ,style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .01,
                          ),
                          Text("3- الشركه تخلي مسئوليتها تماما في حاله تعاملك مع Delivery Man من خارج التطبيق"
                            ,style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(

                      textColor: Colors.black,
                      child: Text('الغاء'),
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                    ),
                    FlatButton(
                      color: kMainColor,
                      textColor: Colors.white,
                      child: Text('موافق'),
                      onPressed: () {
                        setState(() {
                          saveValue(1);
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                  ],
                );
              }
          );
        });
  }
}