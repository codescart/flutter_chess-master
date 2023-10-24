
import 'package:chess_bot/MainGameModel/PlayWithFriend/button_page.dart';
import 'package:chess_bot/gamechanger/CreateTable.dart';
import 'package:chess_bot/main.dart';
import 'package:chess_bot/wholeproject/Dashboard/More.dart';
import 'package:chess_bot/wholeproject/constant.dart';
import 'package:chess_bot/wholeproject/home/P_Friend_tablePage.dart';
import 'package:chess_bot/wholeproject/home/table_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';


class First_home_page extends StatefulWidget {
  const First_home_page({Key key}) : super(key: key);

  @override
  State<First_home_page> createState() => _First_home_pageState();
}

class _First_home_pageState extends State<First_home_page> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(backgroundColor: primaryColor,
        appBar: AppBar(elevation: 0,centerTitle: true,
          leading: CircleAvatar(backgroundColor: secondryColor,
              child: Image.asset("assets/images/ChessLogo.png")),
          title: Text(
            "Realmoneychess",
            style: TextStyle(
                color: primarytextColor, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          // title: Container(
          //   height: 15,
          //   width: 150,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage("assets/images/AppBar_name.png"),
          //     )
          //   ),
          // ),
          backgroundColor: primaryColor,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context,)=>Details()));
                },
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: primarytextColor,
                ))
          ],

        ),
        body: Container(
          height:height*0.8,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.fill,)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(onTap:(){

                    // Navigator.push(context, PageTransition(child: CreateTable(),
                    //     type: PageTransitionType.rightToLeft,duration:Duration(seconds: 1) ));
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateTable()));
                  },
                    child: Container(alignment: Alignment.center,
                      height: height*0.14,
                      width: width*0.4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/Free_Play__1_.png"),fit: BoxFit.fill,)),


                    ),
                  ),SizedBox(width: 20,),
                  InkWell(onTap: (){
                    // Navigator.push(context, PageTransition(child: Table_Page(),
                    //     type: PageTransitionType.rightToLeft,duration:Duration(seconds: 1) ));
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Table_Page()));
                  },
                    child: Container(alignment: Alignment.center,
                      height: height*0.14,
                      width: width*0.4,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/Free_Play__2.png"),fit: BoxFit.fill,)),


                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(onTap:(){
                    // Navigator.push(context, PageTransition(child: Play_Friend_Tablepage(),
                    //     type: PageTransitionType.rightToLeft,duration:Duration(seconds: 1) ));
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Create_Join()));
                  },
                    child: Container(alignment: Alignment.center,
                      height: height*0.14,
                      width: width*0.4,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/Free_Play__3.png"),fit: BoxFit.fill,)),


                    ),
                  ),SizedBox(width: 20,),
                  InkWell(onTap: (){
                    Navigator.push(context, PageTransition(child: Table_Page(),
                        type: PageTransitionType.rightToLeft,duration:Duration(seconds: 1) ));
                  },
                    child: Container(alignment: Alignment.center,
                      height: height*0.14,
                      width: width*0.4,
                      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/Free_Play_5.png"),fit: BoxFit.fill,)),


                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
