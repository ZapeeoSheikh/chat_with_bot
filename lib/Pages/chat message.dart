// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// class ChatMessage extends StatelessWidget {
//   const ChatMessage({Key? key, required this.sender, required this.message}) : super(key: key);
//    final String sender;
//    final String message;
//
//   @override
//   Widget build(BuildContext context) {
//     String api = "https://api.gptplayground.com/v1/chat";
//     String apikey = "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";
//
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         CircleAvatar(
//          child: Text(sender[0]),
//         ),
//         SizedBox(width: 10,),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               sender,
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//             Text(
//               message,
//               style: TextStyle(color: context.primaryColor),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Ui Kit/Ui.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      });

  final String text;
  final String sender;


  @override
  Widget build(BuildContext context) {
    return sender == "bot" ? Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: MyColor.mainColor2 ,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: text.trim().text.bodyText1(context).make().px8())),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Image(
            // color: MyColor.mainColor1,
            image: NetworkImage(
                "Images/Bot.png" ),
            width: 50,
            height: 50,
            fit: BoxFit.cover,

          ),
        ),
      ],
    ).py8() : Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Image(
            // color: MyColor.mainColor1,
                  image: NetworkImage(
                    "https://media.licdn.com/dms/image/D4D03AQFsFIyTfr6z8g/profile-displayphoto-shrink_800_800/0/1683985480430?e=2147483647&v=beta&t=nbFDXUoAtxABcekgpvAFOH-tzh7cmghMy39RLI-PrBk"),
                  width: 50,
                  height: 50,
                fit: BoxFit.cover,

              ),
            ),
        Padding(
          padding:  EdgeInsets.all(8.0),
          child: Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  color: MyColor.mainColor1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: text.trim().text.bodyText1(context).make().px8())),
          ),
        ),
      ],
    ).py8()



    ;
  }
}
