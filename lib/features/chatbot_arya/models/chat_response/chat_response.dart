// To parse this JSON data, do
//
//     final chatResponse = chatResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'chat_response.freezed.dart';
part 'chat_response.g.dart';

ChatResponse chatResponseFromJson(String str) =>
    ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

@freezed
class ChatResponse with _$ChatResponse {
  const factory ChatResponse({
    @JsonKey(name: "Response") String? response,
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "query") String? query,
  }) = _ChatResponse;

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);
}
