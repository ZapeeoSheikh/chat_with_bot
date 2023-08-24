import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:chat_with_bot/Ui%20Kit/Ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:velocity_x/velocity_x.dart';

import '../AppUrl.dart';
import 'chat message.dart';
import 'openai_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  final questionController = TextEditingController();
  final List<ChatMessage> _messages = [];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("English"), value: "USA"),
      DropdownMenuItem(child: Text("Urdu"), value: "Canada"),
      DropdownMenuItem(child: Text("Bangali"), value: "Brazil"),
      DropdownMenuItem(child: Text("Hindi"), value: "England"),
    ];
    return menuItems;
  }

  String selectedValue = "USA";
  bool isType = true;
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 3000;
  int delay = 3000;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    print("objectobject");
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print(lastWords);
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  void _sendMessage() {
    setState(() {
      isType = false;
    });
    if (questionController.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: questionController.text,
      sender: "you",
        generatedImageUrl: generatedImageUrl
    );
    // askquestion();

    setState(() {
      _messages.insert(0, message);
      _isTyping = false;
    });

    questionController.clear();
  }

  @override
  void _recieveMessage() {

    ChatMessage message = ChatMessage(
      text: generatedContent!,
      sender: "bot",
        generatedImageUrl: generatedImageUrl
    );
    // askquestion();

    setState(() {
      _messages.insert(0, message);
      _isTyping = false;
    });
  }
  //
  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: Focus(
            onFocusChange: (changed){
              setState(() {
                _isTyping = changed;
              });
            },
            child: TextField(
              controller: questionController,
              onSubmitted: (value) async {
                _sendMessage();
                final speech = await openAIService.isArtPromptAPI(questionController.text);
                if (speech.contains('https')) {
                  generatedImageUrl = speech;
                  generatedContent = null;
                  setState(() {});
                }
                else {
                  generatedImageUrl = null;
                  generatedContent = speech;
                  setState(() {});
                  await systemSpeak(speech);
                  _recieveMessage();
                }
              },
              decoration: InputDecoration.collapsed(
                  hintStyle: TextStyle(color: MyColor.textColor1),
                  hintText: "Ask me questions"),
            ),
          ),
        ),
        _isTyping == false ? GestureDetector(
          onTap: () async {
              if (await speechToText.hasPermission &&
              speechToText.isNotListening) {
                // print("object");
                await startListening();
              }
              else if (speechToText.isListening) {
                final speech = await openAIService.isArtPromptAPI(lastWords);
                if (speech.contains('https')) {
                  generatedImageUrl = speech;
                  generatedContent = null;
                  setState(() {});
                }
                else {
                  generatedImageUrl = null;
                  generatedContent = speech;
                  setState(() {});
                  await systemSpeak(speech);
                }
              }
              else {
                initSpeechToText();
              }
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: MyColor.mainColor1,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              speechToText.isListening ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 25,
            ),
          ),
        ) : GestureDetector(
          onTap: () async {
            _sendMessage();
            final speech = await openAIService.isArtPromptAPI(questionController.text);
            if (speech.contains('https')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            }
            else {
              generatedImageUrl = null;
              generatedContent = speech;
              setState(() {});
              await systemSpeak(speech);
              _recieveMessage();
            }
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: MyColor.mainColor1,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(
              Icons.send,
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
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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

                   IconButton(
                      tooltip: "Select language",
                      icon: Icon(Icons.language),
                      onPressed: () {},
                    )
                  ],
                ),
                // generatedContent!
                FadeInRight(
                  child: Visibility(
                    visible: generatedContent == null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                        top: 30,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20).copyWith(
                          topLeft: Radius.zero,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'Good Morning, what task can I do for you?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (generatedImageUrl != null)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(generatedImageUrl!, width: 200, height: 200,),
                    ),
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
                    _isTyping
                        ? Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                                'https://static.vectorcharacters.net/uploads/2013/11/Cute_Vector_Robot_Character_Preview.gif',
                                width: 120,
                                height: 180)))
                        : Container(),
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
        // floatingActionButton: ZoomIn(
        //   delay: Duration(milliseconds: start + 3 * delay),
        //   child: FloatingActionButton(
        //     // backgroundColor: Pallete.firstSuggestionBoxColor,
        //     onPressed: () async {
        //       if (await speechToText.hasPermission &&
        //           speechToText.isNotListening) {
        //         // print("object");
        //         await startListening();
        //       }
        //       else if (speechToText.isListening) {
        //         final speech = await openAIService.isArtPromptAPI(lastWords);
        //         if (speech.contains('https')) {
        //           generatedImageUrl = speech;
        //           generatedContent = null;
        //           setState(() {});
        //         }
        //         else {
        //           generatedImageUrl = null;
        //           generatedContent = speech;
        //           setState(() {});
        //           await systemSpeak(speech);
        //         }
        //       }
        //       else {
        //         initSpeechToText();
        //       }
        //     },
        //     child: Icon(
        //       speechToText.isListening ? Icons.stop : Icons.mic,
        //     ),
        //   ),
        // ),

      ),
    );
  }


}
