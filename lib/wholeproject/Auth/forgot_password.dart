import 'package:chess_bot/wholeproject/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Forgot_Password extends StatefulWidget {
  const Forgot_Password({Key key}) : super(key: key);

  @override
  State<Forgot_Password> createState() => _Forgot_PasswordState();
}

class _Forgot_PasswordState extends State<Forgot_Password> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 17,top: 40),
                    child: Text(
                      "Forgot\nyour \nAccount \nPassword?",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Image(image: AssetImage("assets/images/Register3.png",),
                      height: height*0.23,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Container(
                  height: 140,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Country Code",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.2),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ],
                        ),
                        IntlPhoneField(
                          disableLengthCheck: true,
                          decoration: InputDecoration(focusedBorder: UnderlineInputBorder(
                            //<-- SEE HERE
                            borderSide: BorderSide(
                                width: 1, color: primaryColor),
                          ),
                              hintText: 'Phone Number',
                              enabledBorder: UnderlineInputBorder(
                                //<-- SEE HERE
                                borderSide: BorderSide(
                                    width: 1, color: Colors.black),
                              )),
                          initialCountryCode: 'IN',
                          dropdownIconPosition: IconPosition.trailing,
                          onChanged: (phone) {
                            print(phone.completeNumber);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 42, width: 160,
                            //color: Colors.redAccent,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              color: Colors.black,
                            ),
                            child: Text(
                              "GENERATE OTP",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
