// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HistoryResponse _$HistoryResponseFromJson(Map<String, dynamic> json) {
  return _HistoryResponse.fromJson(json);
}

/// @nodoc
mixin _$HistoryResponse {
  @JsonKey(name: "feedback_flag")
  int? get feedbackFlag => throw _privateConstructorUsedError;
  @JsonKey(name: "id")
  String? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "message")
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: "session_id")
  String? get sessionId => throw _privateConstructorUsedError;
  @JsonKey(name: "timestamp")
  int? get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: "type")
  Type? get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HistoryResponseCopyWith<HistoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryResponseCopyWith<$Res> {
  factory $HistoryResponseCopyWith(
          HistoryResponse value, $Res Function(HistoryResponse) then) =
      _$HistoryResponseCopyWithImpl<$Res, HistoryResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "feedback_flag") int? feedbackFlag,
      @JsonKey(name: "id") String? id,
      @JsonKey(name: "message") String? message,
      @JsonKey(name: "session_id") String? sessionId,
      @JsonKey(name: "timestamp") int? timestamp,
      @JsonKey(name: "type") Type? type});
}

/// @nodoc
class _$HistoryResponseCopyWithImpl<$Res, $Val extends HistoryResponse>
    implements $HistoryResponseCopyWith<$Res> {
  _$HistoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackFlag = freezed,
    Object? id = freezed,
    Object? message = freezed,
    Object? sessionId = freezed,
    Object? timestamp = freezed,
    Object? type = freezed,
  }) {
    return _then(_value.copyWith(
      feedbackFlag: freezed == feedbackFlag
          ? _value.feedbackFlag
          : feedbackFlag // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryResponseImplCopyWith<$Res>
    implements $HistoryResponseCopyWith<$Res> {
  factory _$$HistoryResponseImplCopyWith(_$HistoryResponseImpl value,
          $Res Function(_$HistoryResponseImpl) then) =
      __$$HistoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "feedback_flag") int? feedbackFlag,
      @JsonKey(name: "id") String? id,
      @JsonKey(name: "message") String? message,
      @JsonKey(name: "session_id") String? sessionId,
      @JsonKey(name: "timestamp") int? timestamp,
      @JsonKey(name: "type") Type? type});
}

/// @nodoc
class __$$HistoryResponseImplCopyWithImpl<$Res>
    extends _$HistoryResponseCopyWithImpl<$Res, _$HistoryResponseImpl>
    implements _$$HistoryResponseImplCopyWith<$Res> {
  __$$HistoryResponseImplCopyWithImpl(
      _$HistoryResponseImpl _value, $Res Function(_$HistoryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feedbackFlag = freezed,
    Object? id = freezed,
    Object? message = freezed,
    Object? sessionId = freezed,
    Object? timestamp = freezed,
    Object? type = freezed,
  }) {
    return _then(_$HistoryResponseImpl(
      feedbackFlag: freezed == feedbackFlag
          ? _value.feedbackFlag
          : feedbackFlag // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      sessionId: freezed == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as Type?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryResponseImpl implements _HistoryResponse {
  const _$HistoryResponseImpl(
      {@JsonKey(name: "feedback_flag") this.feedbackFlag,
      @JsonKey(name: "id") this.id,
      @JsonKey(name: "message") this.message,
      @JsonKey(name: "session_id") this.sessionId,
      @JsonKey(name: "timestamp") this.timestamp,
      @JsonKey(name: "type") this.type});

  factory _$HistoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HistoryResponseImplFromJson(json);

  @override
  @JsonKey(name: "feedback_flag")
  final int? feedbackFlag;
  @override
  @JsonKey(name: "id")
  final String? id;
  @override
  @JsonKey(name: "message")
  final String? message;
  @override
  @JsonKey(name: "session_id")
  final String? sessionId;
  @override
  @JsonKey(name: "timestamp")
  final int? timestamp;
  @override
  @JsonKey(name: "type")
  final Type? type;

  @override
  String toString() {
    return 'HistoryResponse(feedbackFlag: $feedbackFlag, id: $id, message: $message, sessionId: $sessionId, timestamp: $timestamp, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryResponseImpl &&
            (identical(other.feedbackFlag, feedbackFlag) ||
                other.feedbackFlag == feedbackFlag) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, feedbackFlag, id, message, sessionId, timestamp, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryResponseImplCopyWith<_$HistoryResponseImpl> get copyWith =>
      __$$HistoryResponseImplCopyWithImpl<_$HistoryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryResponseImplToJson(
      this,
    );
  }
}

abstract class _HistoryResponse implements HistoryResponse {
  const factory _HistoryResponse(
      {@JsonKey(name: "feedback_flag") final int? feedbackFlag,
      @JsonKey(name: "id") final String? id,
      @JsonKey(name: "message") final String? message,
      @JsonKey(name: "session_id") final String? sessionId,
      @JsonKey(name: "timestamp") final int? timestamp,
      @JsonKey(name: "type") final Type? type}) = _$HistoryResponseImpl;

  factory _HistoryResponse.fromJson(Map<String, dynamic> json) =
      _$HistoryResponseImpl.fromJson;

  @override
  @JsonKey(name: "feedback_flag")
  int? get feedbackFlag;
  @override
  @JsonKey(name: "id")
  String? get id;
  @override
  @JsonKey(name: "message")
  String? get message;
  @override
  @JsonKey(name: "session_id")
  String? get sessionId;
  @override
  @JsonKey(name: "timestamp")
  int? get timestamp;
  @override
  @JsonKey(name: "type")
  Type? get type;
  @override
  @JsonKey(ignore: true)
  _$$HistoryResponseImplCopyWith<_$HistoryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
