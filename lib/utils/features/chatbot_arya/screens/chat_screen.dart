import 'package:arya/utils/constants/colors.dart';
import 'package:arya/utils/constants/image_strings.dart';
import 'package:arya/utils/constants/sizes.dart';
import 'package:arya/utils/features/chatbot_arya/screens/widgets/bot_message.dart';
import 'package:arya/utils/features/chatbot_arya/screens/widgets/user_message.dart';
import 'package:arya/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

// Define a model for chat messages
class ChatMessage {
  final String text;
  final bool isBotResponse;
  final DateTime timestamp; // Add timestamp

  ChatMessage({
    required this.text,
    this.isBotResponse = true,
    DateTime? timestamp, // Initialize timestamp as nullable
  }) : timestamp = timestamp ??
            DateTime.now(); // Assign current time if timestamp is null
}

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
  final TextEditingController _queryController = TextEditingController();
  List<ChatMessage> messages = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late ScrollController
      _scrollController; // Declare as late to initialize in initState
  bool _showScrollToBottom = false; // Flag to control visibility of the button

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        // Update visibility based on scroll position
        final maxScrollExtent = _scrollController.position.maxScrollExtent;
        final currentScrollPosition = _scrollController.offset;
        const threshold =
            200.0; // Adjust this value to determine when to show the button

        // Check if the user has scrolled up from the bottom by more than the threshold
        setState(() {
          _showScrollToBottom =
              (maxScrollExtent - currentScrollPosition > threshold);
        });
      });
    _scrollToBottom();

    // Add initial bot message

    messages.add(ChatMessage(
      text:
          "Hello, I’m Arya! 👋 I’m your personal finance assistant. How can I help you?",
      isBotResponse: true,
      timestamp: DateTime.now(), // Ensure timestamp is provided
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of scroll controller
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendQuery() async {
    if (_queryController.text.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    messages.add(ChatMessage(
      text: _queryController.text,
      isBotResponse: false,
      timestamp: DateTime.now(), // Ensure timestamp is provided
    ));
    setState(() {});
    _scrollToBottom();

    _queryController.text = "";
    try {
      final response = await http.post(
        Uri.parse(
            'https://bazbkygu5a.execute-api.ap-south-1.amazonaws.com/invocations'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': '4',
          'query': _queryController.text,
          'user': 'parag.bajaj@piramal.com',
          'source': 'local',
          'usecase': 'ARYA-APP'
        }),
      );

      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        setState(() {
          messages.add(ChatMessage(
            text: responseBody['Response'],
            isBotResponse: true,
            timestamp: DateTime.now(), // Ensure timestamp is provided
          ));
        });

        // Programmatically unfocus the TextField to dismiss the keyboard
        FocusScope.of(context).unfocus();
        _scrollToBottom();
      } else {
        setState(() {
          _errorMessage =
              'Error: ${response.statusCode} - ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: Please try again later';
        Fluttertoast.showToast(
            msg: _errorMessage,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
                      // final mode = value ? 'Dark mode' : 'Light mode';
                      // Fluttertoast.showToast(
                      //   msg: 'Switched to $mode',
                      //   backgroundColor: Colors.black,
                      //   textColor: Colors.white,
                      // );
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
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(TImages.bg_vector), fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      controller:
                          _scrollController, // Attach scroll controller here
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];

                        // Check if it's a bot response or user message
                        if (message.isBotResponse) {
                          return BotMessage(message.text, message.timestamp,
                              messages.length == 1);
                        } else {
                          return UserMessage(message.text, message.timestamp);
                        }
                      },
                    ),
                    Visibility(
                      visible: _showScrollToBottom,
                      child: Positioned(
                        bottom: -5,
                        left: (MediaQuery.of(context).size.width - 40) / 2,
                        width: 40,
                        child: GestureDetector(
                          onTap: _scrollToBottom,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: dark
                                  ? const Color.fromARGB(68, 255, 255, 255)
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
                                    : const Color.fromARGB(255, 255, 255, 255),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          _sendQuery();
                        },
                        controller: _queryController,
                        style: TextStyle(
                            color: dark ? Colors.white : Colors.black,
                            fontSize: TSizes.fontSizeMd),
                        decoration: InputDecoration(
                          hintText: _errorMessage.isNotEmpty
                              ? _errorMessage
                              : 'Ask Me Anything... ',
                          hintStyle: TextStyle(
                              color: dark ? TColors.grey : Colors.grey,
                              fontSize: TSizes.fontSizeSm),
                          filled: true,
                          contentPadding: const EdgeInsets.all(10),
                          fillColor:
                              dark ? const Color(0xFF818181) : Colors.white,
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
                      icon: _isLoading
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
                      onPressed: _isLoading ? null : _sendQuery,
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
