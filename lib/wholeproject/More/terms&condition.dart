
import 'package:chess_bot/wholeproject/constant.dart';
import 'package:flutter/material.dart';


class Terms_Condition extends StatefulWidget {
  const Terms_Condition({Key key}) : super(key: key);

  @override
  State<Terms_Condition> createState() => _Terms_ConditionState();
}

class _Terms_ConditionState extends State<Terms_Condition> {
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
            title: Text("Terms & Conditions"),
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
