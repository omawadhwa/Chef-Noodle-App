import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserMessage extends StatelessWidget {
  final String text;
  final DateTime timestamp;

  const UserMessage(this.text, this.timestamp, {super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: MediaQuery.of(context).size.width * 0.20,
            right: 20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color:
                    dark ? TColors.darkUserTextBox : TColors.lightUserTextBox,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
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
                    !isToday(timestamp)
                        ? DateFormat("dd MMM, hh:mm a").format(timestamp)
                        : DateFormat("hh:mm a").format(timestamp),
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

  isToday(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return true;
    } else {
      return false;
    }
  }
}
