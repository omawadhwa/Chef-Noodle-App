// To parse this JSON data, do
//
//     final historyResponse = historyResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'history_response.freezed.dart';
part 'history_response.g.dart';

List<HistoryResponse> historyResponseFromJson(String str) =>
    List<HistoryResponse>.from(
        json.decode(str).map((x) => HistoryResponse.fromJson(x)));

String historyResponseToJson(List<HistoryResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
class HistoryResponse with _$HistoryResponse {
  const factory HistoryResponse({
    @JsonKey(name: "feedback_flag") int? feedbackFlag,
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "message") String? message,
    @JsonKey(name: "session_id") String? sessionId,
    @JsonKey(name: "timestamp") int? timestamp,
    @JsonKey(name: "type") Type? type,
  }) = _HistoryResponse;

  factory HistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryResponseFromJson(json);
}

enum Type {
  @JsonValue("bot")
  BOT,
  @JsonValue("user")
  USER
}

final typeValues = EnumValues({"bot": Type.BOT, "user": Type.USER});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
