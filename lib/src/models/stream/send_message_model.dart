import 'dart:convert';

import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';

class IsmLiveSendMessageModel {
  IsmLiveSendMessageModel({
    this.parentMessageId,
    required this.streamId,
    required this.body,
    required this.searchableTags,
    required this.metaData,
    this.customType,
    required this.deviceId,
    required this.messageType,
  });

  factory IsmLiveSendMessageModel.fromMap(Map<String, dynamic> map) =>
      IsmLiveSendMessageModel(
        streamId: map['streamId'] as String,
        body: map['body'] as String,
        searchableTags: map['searchableTags'] as dynamic,
        metaData:
            IsmLiveMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        customType: map['customType'] != null
            ? IsmLiveGifts.fromName(map['customType'].toString())
            : null,
        deviceId: map['deviceId'] as String,
        parentMessageId: map['parentMessageId'] as String?,
        messageType: IsmLiveMessageType.fromValue(map['messageType'] as int),
      );

  factory IsmLiveSendMessageModel.fromJson(String source) =>
      IsmLiveSendMessageModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  final String streamId;
  final String body;
  final dynamic searchableTags;
  final IsmLiveMetaData metaData;
  final IsmLiveGifts? customType;
  final String deviceId;
  final String? parentMessageId;
  final IsmLiveMessageType messageType;

  IsmLiveSendMessageModel copyWith({
    String? streamId,
    String? body,
    dynamic searchableTags,
    IsmLiveMetaData? metaData,
    IsmLiveGifts? customType,
    String? deviceId,
    String? parentMessageId,
    IsmLiveMessageType? messageType,
  }) =>
      IsmLiveSendMessageModel(
        streamId: streamId ?? this.streamId,
        body: body ?? this.body,
        searchableTags: searchableTags ?? this.searchableTags,
        metaData: metaData ?? this.metaData,
        customType: customType ?? this.customType,
        deviceId: deviceId ?? this.deviceId,
        parentMessageId: parentMessageId ?? this.parentMessageId,
        messageType: messageType ?? this.messageType,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'streamId': streamId,
        'body': body,
        'searchableTags': searchableTags,
        'metaData': metaData.toMap(),
        'customType': customType?.name,
        'deviceId': deviceId,
        'parentMessageId': parentMessageId,
        'messageType': messageType.value,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmLiveSendMessageModel(streamId: $streamId, body: $body, searchableTags: $searchableTags, metaData: $metaData, customType: $customType,deviceId: $deviceId,parentMessageId: $parentMessageId,messageType: $messageType)';

  @override
  bool operator ==(covariant IsmLiveSendMessageModel other) {
    if (identical(this, other)) return true;

    return other.streamId == streamId &&
        other.body == body &&
        other.searchableTags == searchableTags &&
        other.metaData == metaData &&
        other.customType == customType &&
        other.deviceId == deviceId &&
        other.parentMessageId == parentMessageId &&
        other.messageType == messageType;
  }

  @override
  int get hashCode =>
      streamId.hashCode ^
      body.hashCode ^
      searchableTags.hashCode ^
      metaData.hashCode ^
      customType.hashCode ^
      deviceId.hashCode ^
      parentMessageId.hashCode ^
      messageType.hashCode;
}
