import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class BotMessage extends StatelessWidget {
  final String text;
  final DateTime timestamp;
  final bool isFirstMessage;

  const BotMessage(this.text, this.timestamp, this.isFirstMessage);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 10, right: MediaQuery.of(context).size.width * 0.25, left: 20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: dark ? TColors.darkBotTextBox : TColors.lightBotTextBox,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: dark
                        ? const TextStyle(
                            color: TColors.darkBotText,
                            fontWeight: FontWeight.w600)
                        : const TextStyle(
                            color: TColors.lightBotText,
                            fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: dark
                        ? const TextStyle(
                            color: TColors.darkBotText,
                            fontWeight: FontWeight.w600,
                            fontSize: 11)
                        : const TextStyle(
                            color: TColors.lightBotText,
                            fontWeight: FontWeight.w600,
                            fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// if(isFirstMessage)Column(crossAxisAlignment: CrossAxisAlignment.start,children: List.generate(3, (index)=>Text("$index")),)



