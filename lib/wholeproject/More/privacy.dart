
import 'package:chess_bot/wholeproject/constant.dart';
import 'package:flutter/material.dart';



class Privacy extends StatefulWidget {
  const Privacy({Key key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
           onPressed: () {
             Navigator.pop(context);
             },
          icon: Icon(Icons.arrow_back,)),
        backgroundColor: primaryColor,
        title: Text("Privacy Policy"),
        centerTitle: true,
      ),
      body:Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                physics: const BouncingScrollPhysics(),
                child: Text("Aman",
                  textAlign: TextAlign.justify,
                )
            ),
          ),
        ],
      ),
    ));
  }
}
