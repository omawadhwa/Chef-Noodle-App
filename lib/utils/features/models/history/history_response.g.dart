// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HistoryResponseImpl _$$HistoryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$HistoryResponseImpl(
      feedbackFlag: (json['feedback_flag'] as num?)?.toInt(),
      id: json['id'] as String?,
      message: json['message'] as String?,
      sessionId: json['session_id'] as String?,
      timestamp: (json['timestamp'] as num?)?.toInt(),
      type: $enumDecodeNullable(_$TypeEnumMap, json['type']),
    );

Map<String, dynamic> _$$HistoryResponseImplToJson(
        _$HistoryResponseImpl instance) =>
    <String, dynamic>{
      'feedback_flag': instance.feedbackFlag,
      'id': instance.id,
      'message': instance.message,
      'session_id': instance.sessionId,
      'timestamp': instance.timestamp,
      'type': _$TypeEnumMap[instance.type],
    };

const _$TypeEnumMap = {
  Type.BOT: 'bot',
  Type.USER: 'user',
};
