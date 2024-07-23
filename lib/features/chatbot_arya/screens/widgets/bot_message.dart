import 'dart:developer';

import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BotMessage extends StatelessWidget {
  final String text;
  final DateTime timestamp;
  final bool isFirstMessage;

  const BotMessage(this.text, this.timestamp, this.isFirstMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: 10,
            bottom: 10,
            right: MediaQuery.of(context).size.width * 0.20,
            left: 20),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: dark ? TColors.darkBotTextBox : TColors.lightBotTextBox,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _renderHtml(text),
                  Text(
                    !isToday(timestamp)
                        ? DateFormat("dd MMM yyyy  hh:mm a").format(timestamp)
                        : DateFormat("hh:mm a").format(timestamp),
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

  _renderHtml(text) {
    return Html(
      data: text,
      onLinkTap: (url, attributes, element) async {
        await launchUrlString(url!);
      },
    );
  }
}

// if(isFirstMessage)Column(crossAxisAlignment: CrossAxisAlignment.start,children: List.generate(3, (index)=>Text("$index")),)



