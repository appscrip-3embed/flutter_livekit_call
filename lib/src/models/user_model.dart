import 'dart:convert';

import 'package:appscrip_live_stream_component/appscrip_live_stream_component.dart';
import 'package:appscrip_live_stream_component/src/models/meta_data.dart';

class UserDetails {
  factory UserDetails.fromJson(String source) =>
      UserDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserDetails.fromMap(Map<String, dynamic> map) => UserDetails(
        userProfileImageUrl: map['userProfileImageUrl'] as String? ??
            map['userProfilePic'] as String? ??
            '',
        userName: map['userName'] as String? ?? '',
        userIdentifier: map['userIdentifier'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        metaData: map['metaData'] == null
            ? const IsmLiveMetaData()
            : IsmLiveMetaData.fromMap(map['metaData'] as Map<String, dynamic>),
        createdAt: map['createdAt'] as int? ?? 0,
        timestamp: map['timestamp'] as num?,
        pending: map['pending'] as bool?,
        accepted: map['accepted'] as bool?,
        notification: map['notification'] as bool? ?? false,
        isAdmin: map['isAdmin'] as bool? ?? false,
      );

  UserDetails({
    required this.userProfileImageUrl,
    required this.userName,
    required this.userIdentifier,
    required this.userId,
    this.metaData,
    this.notification,
    this.isAdmin,
    this.createdAt,
    this.timestamp,
    this.pending,
    this.accepted,
  });

  final String userProfileImageUrl;
  final String userName;
  final String userIdentifier;
  final String userId;
  final IsmLiveMetaData? metaData;
  final bool? notification;
  final bool? isAdmin;
  final int? createdAt;
  final num? timestamp;
  final bool? pending;
  final bool? accepted;

  String get profileUrl => metaData?.profilePic ?? userProfileImageUrl;
  String get name {
    if (metaData?.firstName?.isNotEmpty ?? false) {
      return '${metaData?.firstName} ${metaData?.lastName ?? ''}';
    }
    return userName;
  }

  UserDetails copyWith({
    String? userProfileImageUrl,
    String? userName,
    String? userIdentifier,
    String? userId,
    IsmLiveMetaData? metaData,
    bool? notification,
    bool? isAdmin,
    bool? accepted,
    bool? pending,
    num? timestamp,
  }) =>
      UserDetails(
        userProfileImageUrl: userProfileImageUrl ?? this.userProfileImageUrl,
        userName: userName ?? this.userName,
        userIdentifier: userIdentifier ?? this.userIdentifier,
        userId: userId ?? this.userId,
        metaData: metaData ?? this.metaData,
        notification: notification ?? this.notification,
        accepted: accepted ?? this.accepted,
        pending: pending ?? this.pending,
        timestamp: timestamp ?? this.timestamp,
        isAdmin: isAdmin ?? this.isAdmin,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userProfileImageUrl': userProfileImageUrl,
        'userName': userName,
        'userIdentifier': userIdentifier,
        'userId': userId,
        'metaData': metaData?.toMap(),
        'notification': notification,
        'timestamp': timestamp,
        'pending': pending,
        'accepted': accepted,
        'isAdmin': isAdmin,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UserDetails(userProfileImageUrl: $userProfileImageUrl, userName: $userName, userIdentifier: $userIdentifier, userId: $userId,notification: $notification,isAdmin: $isAdmin,accepted: $accepted,timestamp: $timestamp,pending$pending,metaData : $metaData)';

  @override
  bool operator ==(covariant UserDetails other) {
    if (identical(this, other)) return true;

    return other.userProfileImageUrl == userProfileImageUrl &&
        other.userName == userName &&
        other.userIdentifier == userIdentifier &&
        other.userId == userId &&
        other.metaData == metaData &&
        other.isAdmin == isAdmin &&
        other.pending == pending &&
        other.accepted == accepted &&
        other.timestamp == timestamp &&
        other.notification == notification;
  }

  @override
  int get hashCode =>
      userProfileImageUrl.hashCode ^
      userName.hashCode ^
      userIdentifier.hashCode ^
      userId.hashCode ^
      metaData.hashCode ^
      isAdmin.hashCode ^
      timestamp.hashCode ^
      pending.hashCode ^
      accepted.hashCode ^
      notification.hashCode;
}
