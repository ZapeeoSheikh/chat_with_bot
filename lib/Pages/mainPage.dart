import 'package:chat_with_bot/Pages/chatScreen.dart';
import 'package:chat_with_bot/Ui%20Kit/Ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(image: AssetImage(
                    "Images/Bot.png"
                  ),width: 40,height: 40,),
                  SizedBox(width: 10,),
                  Text(
                    "Chat with Bot",
                    style: TextStyle(
                      color: MyColor.textColor1,
                      fontWeight: FontWeight.bold,
                      fontSize: 15

                    ),
                  )
                ],
              ),
              SizedBox(height: 30,),
              Image(image: AssetImage("Images/Bot.png"), width: MediaQuery.of(context).size.width,),
              SizedBox(height: 10,),
              Text(
                "Welcome, NCBA&E!👋",
                style: GoogleFonts.lato(
                    color: MyColor.textColor1,
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "Let's Have Fun with Bot!",
                style: GoogleFonts.lato(
                    color: MyColor.textColor1,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(height: 20,),
              Text(
                "Start a conversation with bot right now!",
                style: GoogleFonts.lato(
                    color: MyColor.textColor1,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: MyColor.mainColor1,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: MyColor.mainColor1
                                    .withOpacity(
                                    0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: Offset(0,
                                    3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Start a conversation with Bot",
                              style: GoogleFonts.lato(
                                  color: MyColor.background1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],

          ),
        ),
      ),
    );
  }
}
