import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  final String text;
  final DateTime timestamp;

  const UserMessage(this.text, this.timestamp);

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
            top: 10, bottom: 10, left: MediaQuery.of(context).size.width * 0.25, right: 20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: dark ? TColors.darkUserTextBox : TColors.lightUserTextBox,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    text,
                    style: dark
                        ? const TextStyle(
                            color: TColors.darkUserText,
                            fontWeight: FontWeight.w600)
                        : const TextStyle(
                            color: TColors.lightUserText,
                            fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                    style: dark
                        ? const TextStyle(
                            color: TColors.darkUserText,
                            fontWeight: FontWeight.w600,
                            fontSize: 11)
                        : const TextStyle(
                            color: TColors.lightUserText,
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
