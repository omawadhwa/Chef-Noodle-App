import 'dart:convert';
import 'dart:developer';

import 'package:arya/utils/constants/api_constants.dart';
import 'package:arya/utils/constants/api_paths.dart';
import 'package:arya/utils/features/models/chat_response/chat_response.dart';
import 'package:arya/utils/features/models/chatmessage.dart';
import 'package:arya/utils/features/models/history/history_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  @override
  void onInit() async {
    await createSession();
    await getChatHistory();
    super.onInit();
  }

  List<ChatMessage> messages = [];

  bool isLoading = false;
  String errorMessage = '';
  String email = 'Sachit.Sabherwal@piramal.com';
  String sessionId = "3";
  bool creatingSession = false;
  bool loadingHistory = false;
  ScrollController scrollController =
      ScrollController(); // Declare as late to initialize in initState
  bool showScrollToBottom = false; // Flag to control visibility of the button

  final TextEditingController queryController = TextEditingController();
  ChatResponse lastMessage = const ChatResponse();
  Future<void> sendQuery() async {
    if (queryController.text.isEmpty) {
      return;
    }

    isLoading = true;

    errorMessage = '';
    update();
    messages.add(ChatMessage(
      text: queryController.text,
      isBotResponse: false,
      timestamp: DateTime.now(), // Ensure timestamp is provided
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollToBottom();
    });
    final query = queryController.text;
    queryController.text = "";
    update();
    try {
      final response = await http.post(
        Uri.parse(APIConstants.baseUrl + ApiPaths.conversation),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': sessionId,
          'query': query,
          'user': email,
          'source': 'local',
          'usecase': 'ARYA-APP'
        }),
      );

      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        lastMessage = ChatResponse.fromJson(responseBody);

        messages.add(ChatMessage(
          text: lastMessage.response!,
          id: lastMessage.id,
          isBotResponse: true,
          timestamp: DateTime.now(), // Ensure timestamp is provided
        ));
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollToBottom();
        });

        // Programmatically unfocus the TextField to dismiss the keyboard
        FocusScope.of(Get.context!).unfocus();
        // _scrollToBottom();
      }
    } catch (e) {
      print(e.toString());
      errorMessage = 'An error occurred: Please try again later';
      Fluttertoast.showToast(
          msg: errorMessage,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> createSession() async {
    creatingSession = true;
    update();
    final startTime = DateTime.now();
    final endTime = startTime.add(const Duration(minutes: 30));

    try {
      final response = await http.post(
        Uri.parse(APIConstants.baseUrl + ApiPaths.createSession),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "session_start_time":
              DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(startTime),
          "session_end_time":
              DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(endTime),
          'user': email,
          'source': 'local',
          'usecase': 'ARYA-APP'
        }),
      );
      log(response.statusCode.toString());
      if (response.statusCode >= 200 && response.statusCode <= 210) {
        final responseBody = jsonDecode(response.body);
        sessionId = responseBody["session_id"];
        log(sessionId);
        update();
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
          textColor: Colors.white);
    } finally {
      creatingSession = false;
      update();
    }
  }

  Future<void> getChatHistory() async {
    loadingHistory = true;
    update();
    final String formattedTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now());
    try {
      final body = jsonEncode({
        "user": email,
        "source": "local",
        "usecase": "ARYA-APP",
        "start_time": formattedTime,
      });
      final headers = {'Content-Type': 'application/json'};
      final response = await http.post(
          Uri.parse(APIConstants.baseUrl + ApiPaths.history),
          headers: headers,
          body: body);

      if (response.statusCode >= 200 && response.statusCode <= 210) {
        final histories = historyResponseFromJson(response.body);
        messages = histories
            .map((history) => ChatMessage(
                text: history.message ?? "",
                id: history.id,
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                    history.timestamp!,
                    isUtc: true),
                isBotResponse: history.type == Type.BOT))
            .toList();
        messages.add(ChatMessage(
          text:
              "Hello, I’m Arya! 👋 I’m your personal finance assistant. How can I help you?",
          isBotResponse: true,
          timestamp: DateTime.now(), // Ensure timestamp is provided
        ));

        Future.delayed(const Duration(milliseconds: 100), () {
          scrollToBottom();
        });
        // Handle the response data as needed
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      loadingHistory = false;

      update();
    }
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.ease);
      update();
    }
  }
}
