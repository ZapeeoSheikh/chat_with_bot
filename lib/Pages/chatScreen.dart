import 'dart:convert';

import 'package:chat_with_bot/Ui%20Kit/Ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:velocity_x/velocity_x.dart';

import '../AppUrl.dart';
import 'chat message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  final questionController = TextEditingController();
  final List<ChatMessage> _messages = [];
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("English"),value: "USA"),
      DropdownMenuItem(child: Text("Urdu"),value: "Canada"),
      DropdownMenuItem(child: Text("Bangali"),value: "Brazil"),
      DropdownMenuItem(child: Text("Hindi"),value: "England"),
    ];
    return menuItems;
  }
  String selectedValue = "USA";
  bool isType = true;

  @override
  void _sendMessage() {
    setState(() {
      isType = false;
    });
    if (questionController.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: questionController.text,
      sender: "you",
    );
    askquestion();

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    questionController.clear();
  }

  //
  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: questionController,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(
                hintStyle: TextStyle(color: MyColor.textColor1),
                hintText: "Ask me questions"),
          ),
        ),
        GestureDetector(
          onTap: () {
            _sendMessage();
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: MyColor.mainColor1,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.mic,
              color: Colors.white,
              size: 25,
            ),
          ),
        )
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.background1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left_sharp,
                      weight: 100,
                    ),
                    color: MyColor.textColor1,
                  ),
                  Text(
                    "Chat with Bot",
                    style: GoogleFonts.lato(
                        color: MyColor.textColor1,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Spacer(),
                  // DropdownButton(value: selectedValue,
                  //     items: dropdownItems, onChanged: (String? value) {  },),
                  IconButton(
                    tooltip: "Select language",
                    icon: Icon(Icons.language), onPressed: () {

                  },)
                ],
              ),
              Flexible(
                  child: Stack(
                children: [
                  ListView.builder(
                    reverse: true,
                    padding: Vx.m8,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: _messages[index],
                      );
                    },
                  ),
                  // _isTyping
                  //     ? Center(
                  //     child: ClipRRect(
                  //         borderRadius: BorderRadius.circular(15.0),
                  //         child: Image.network(
                  //             'https://static.vectorcharacters.net/uploads/2013/11/Cute_Vector_Robot_Character_Preview.gif',
                  //             width: 120,
                  //             height: 180)))
                  //     : Container(),
                ],
              )),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: MyColor.inActive,
                ),
                child: _buildTextComposer(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> askquestion() async {
    Map<String, String> headers = {
      "X-RapidAPI-Key": "4125166edamsh1f1046759a58aa9p19ba8ejsndf5c5eba5b36",
      "X-RapidAPI-Host": "robomatic-ai.p.rapidapi.com"
    };
    try {
      Response response =
          await post(Uri.parse(AppUrl.baseUrl),
              body: {
                "in": "questionController.text",
                "op": "in",
                "cbot": "1",
                "SessionID": "RapidAPI1",
                "cbid": "1",
                "key": "RHMN5hnQ4wTYZBGCF3dfxzypt68rVP",
                "ChatSource": "RapidAPI",
                "duration": "1"
              },
              headers: headers);

      if (response.statusCode == 200) {
        print(response.headers);
        final data = jsonDecode(response.body.toString());
        print(data);

      } else
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Oops something went wrong ${response.statusCode}")));
    } catch (e) {
      print(e.toString());
    }
  }
}
