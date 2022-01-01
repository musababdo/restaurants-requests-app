
import 'package:flutter/material.dart';
import 'package:talabat/constants.dart';

class terms extends StatefulWidget {
  static String id ="terms";
  @override
  _termsState createState() => _termsState();
}

class _termsState extends State<terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0,
        title: Text(
          'الشروط و القوانين',
          style: TextStyle(
              color: Colors.black
          ),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: new Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    elevation: 9,
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "1- في حاله تم قبول الطلب من قبل Delivery Man وتم تسليم الطلب للعميل ورفضه العميل يقوم بدفع نصف سعر الطلب الكلي",
                          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight:FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: new Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    elevation: 9,
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "2- يجب عليك دفع سعر الطلب في حاله تأكيدك للطلب بقصد او بغير قصد",
                          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight:FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                  child: new Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    elevation: 9,
                    color: Colors.white,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "3- الشركه تخلي مسئوليتها تماما في حاله تعاملك مع Delivery Man من خارج التطبيق",
                          style: TextStyle(color: Colors.black,fontSize: 18,fontWeight:FontWeight.bold),
                        ),
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
}
