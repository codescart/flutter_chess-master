import 'dart:convert';


import 'package:chess_bot/wholeproject/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;


class DepositPage extends StatefulWidget {
  const DepositPage({Key key}) : super(key: key);

  @override
  State<DepositPage> createState() => _DepositPageState();
}

class _DepositPageState extends State<DepositPage> {
  String payment;
  TextEditingController rupees=TextEditingController();
  bool loading=false;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(

      appBar: AppBar(leading: InkWell(onTap: (){
        Navigator.pop(context);
      },
          child: Icon(Icons.arrow_back)),
        title: Text("Deposit Money",style: TextStyle(color:Colors.white,),),
        backgroundColor:primaryColor,
      ),
       body: Column(
         children: [
           SizedBox(height:55,
             child: Padding(
               padding: const EdgeInsets.only(left: 10),
               child: Row(
                 children: [
                   buildRadioButton(0,'PayTm'),
                   buildRadioButton(1,"PayUMoney"),
                   buildRadioButton(2,'FlutterWave')
                 ],
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(left: 25),
             child: buildTextField(width,height),
           ),
           Padding(
             padding: const EdgeInsets.fromLTRB(10,15,8,15),
             child: Text("*Note: deposit amount can't be withdrawable and it will be\n            "
                 " use to join paid contest in our app.",
             style: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: 12),),
           ),
           InkWell(onTap: (){},
             child: Container(alignment: Alignment.center,
               height:height*0.07,width: width*0.7,
               //color: Colors.redAccent,
               decoration: BoxDecoration(borderRadius:
               BorderRadius.all(Radius.circular(30)),color: primaryColor),
               child: Text("ADD DEPOSITE",style: TextStyle(fontWeight: FontWeight.w600,
                   fontSize: 20,color: Colors.white),),
             ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 15),
             child: Text("Minimum Add Amount is ₹50",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,
             color:primaryColor ),),
           )


         ],
       ),
    )
    );
  }
  int selectedRadio = 0;
  Widget buildRadioButton(int value, String label) {
    return Row(
      children: [
        Radio(activeColor: primaryColor,
          value: value,
          groupValue: selectedRadio,
          onChanged: (int newValue) {
            setState(() {
              selectedRadio = newValue;
            });
          },
        ),
        Text(label,style: TextStyle(fontSize: 12),),
      ],
    );
  }
  Widget buildTextField(width,height){
    return Row(
      children: [
        Container(width:width*0.09,height:height*0.07,alignment: Alignment.center,
    decoration: BoxDecoration(border:Border.all(color: Colors.grey),
    borderRadius: BorderRadius.only(
    topLeft: Radius.circular(5),
    bottomLeft: Radius.circular(5)
    ),color: Colors.grey.shade400),
          child: Text("₹",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),)
        ),
        Container(
          width: width*0.8,height: height*0.07,
          decoration: BoxDecoration(border:Border.all(color: Colors.grey),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5)
            ),),
          child: TextField( decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            border: InputBorder.none,hintText: "Enter Deposit Amount",
              hintStyle: TextStyle(fontSize: 21,fontWeight: FontWeight.w500))
          ),
        ),
      ],
    );
  }

}
