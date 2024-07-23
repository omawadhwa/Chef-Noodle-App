import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/constants/image_strings.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/features/chatbot_arya/controller/chat_controller.dart';
import 'package:arya/features/chatbot_arya/screens/widgets/bot_message.dart';
import 'package:arya/features/chatbot_arya/screens/widgets/user_message.dart';
import 'package:arya/utils/features/models/chatmessage.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  final ThemeMode? themeMode;
  final VoidCallback? toggleThemeMode;

  const ChatScreen({
    super.key,
    this.themeMode,
    this.toggleThemeMode,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatController x;
  @override
  void initState() {
    super.initState();
    x = Get.put(ChatController());
    x.addListener(_updateState);

    x.scrollController.addListener(() {
      // Update visibility based on scroll position
      final maxScrollExtent = x.scrollController.position.maxScrollExtent;
      final currentScrollPosition = x.scrollController.offset;
      const threshold =
          200.0; // Adjust this value to determine when to show the button

      // Check if the user has scrolled up from the bottom by more than the threshold
      setState(() {
        x.showScrollToBottom =
            (maxScrollExtent - currentScrollPosition > threshold);
      });
    });
    x.scrollToBottom();

    x.update();
  }

  @override
  void dispose() {
    x.scrollController.dispose(); // Dispose of scroll controller
    x.removeListener(_updateState);
    super.dispose();
  }

  _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFuntions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.dark_bg : TColors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Row(
          children: [
            Image.asset(
              TImages.aryaLogo,
              height: 60,
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Arya',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      color: dark ? Colors.white : Colors.black),
                ),
                Text(
                  'Powered by Piramal Finance',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: TSizes.fontSizeSm,
                      color: dark ? TColors.primary : Colors.white),
                ),
              ],
            )
          ],
        ),
        backgroundColor: dark ? TColors.dark : TColors.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Transform.scale(
                  scale: 0.8, // Scale the switch to make it smaller
                  child: Switch(
                    activeTrackColor: TColors.primary,
                    inactiveThumbColor: TColors.white,
                    inactiveTrackColor: TColors.white,
                    activeColor: TColors.primary,
                    value: dark,
                    onChanged: (value) {
                      widget.toggleThemeMode!();
                    },
                    inactiveThumbImage: const AssetImage(
                        'assets/icons/light_mode.png'), // Light mode icon
                    activeThumbImage: const AssetImage(
                        'assets/icons/dark_mode.png'), // Dark mode icon
                    trackOutlineColor: WidgetStateProperty.all(
                        Colors.transparent), // Remove track outline
                    trackOutlineWidth: WidgetStateProperty.all(
                        0.0), // Set track outline width to 0
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: x.loadingHistory || x.creatingSession
          ? const Center(
              child: SpinKitFadingCircle(
                color: TColors.primary,
                size: 30,
              ),
            )
          : SafeArea(
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(TImages.bg_vector),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            controller: x
                                .scrollController, // Attach scroll controller here
                            itemCount: x.messages.length,
                            itemBuilder: (context, index) {
                              final message = x.messages[index];

                              // Check if it's a bot response or user message
                              if (message.isBotResponse) {
                                return BotMessage(
                                    message.text,
                                    message.timestamp,
                                    x.userInteracted,
                                    message.id);
                              } else {
                                return UserMessage(
                                    message.text, message.timestamp);
                              }
                            },
                          ),
                          Visibility(
                            visible: x.showScrollToBottom,
                            child: Positioned(
                              bottom: -5,
                              left:
                                  (MediaQuery.of(context).size.width - 40) / 2,
                              width: 40,
                              child: GestureDetector(
                                onTap: x.scrollToBottom,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: dark
                                        ? const Color.fromARGB(
                                            68, 255, 255, 255)
                                        : const Color.fromARGB(68, 0, 0, 0),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Center(
                                    child: FaIcon(
                                      FontAwesomeIcons.chevronDown,
                                      color: dark
                                          ? const Color.fromARGB(255, 0, 0, 0)
                                          : const Color.fromARGB(
                                              255, 255, 255, 255),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: dark ? TColors.dark : const Color(0xFFF6F6F6),
                        border: const Border(
                          top: BorderSide(
                            color: Colors.grey, // Choose your border color here
                            width: 0.2, // Choose the width of the border
                          ),
                        ),
                      ),
                      height: kBottomNavigationBarHeight + 20,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onSubmitted: (value) {
                                x.sendQuery();
                              },
                              controller: x.queryController,
                              style: TextStyle(
                                  color: dark ? Colors.white : Colors.black,
                                  fontSize: TSizes.fontSizeMd),
                              decoration: InputDecoration(
                                hintText: x.errorMessage.isNotEmpty
                                    ? x.errorMessage
                                    : 'Ask Me Anything... ',
                                hintStyle: TextStyle(
                                    color: dark ? TColors.grey : Colors.grey,
                                    fontSize: TSizes.fontSizeSm),
                                filled: true,
                                contentPadding: const EdgeInsets.all(10),
                                fillColor: dark
                                    ? const Color(0xFF818181)
                                    : Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 0.2, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: x.isLoading
                                ? const Center(
                                    child: SpinKitFadingCircle(
                                      color: TColors.primary,
                                      size: 22.0,
                                    ),
                                  )
                                : Image.asset(
                                    TImages.sendIcon,
                                    height: 24,
                                    width: 24,
                                  ),
                            onPressed: x.isLoading ? null : x.sendQuery,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
