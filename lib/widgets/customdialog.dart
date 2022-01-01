
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talabat/constants.dart';
import 'package:talabat/models/product.dart';
import 'package:talabat/screens/home.dart';
import 'package:talabat/screens/mymap.dart';
import 'package:talabat/widgets/consts.dart';

class CustomDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                'تم ارسال الطلب بي نجاح',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'نشكرك عميلنا الكريم علي استخدامك تطبيقنا',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyMap.id);
                      },
                      child: Text("الرئيسيه"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FlatButton(
                      onPressed: () {
                        SystemNavigator.pop();
                        // / To close the dialog
                      },
                      child: Text("الخروج من التطبيق"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          child: CircleAvatar(
            //child: Icon(Icons.sentiment_satisfied,size: 22,),
            backgroundColor: kMainColor,
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }
}