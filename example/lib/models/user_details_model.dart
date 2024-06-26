import 'dart:convert';

class UserDetailsModel {
  const UserDetailsModel({
    this.userId = '',
    this.userToken = '',
    this.email = '',
    this.userName = '',
    this.deviceId = '',
  });

  factory UserDetailsModel.fromMap(Map<String, dynamic> map) =>
      UserDetailsModel(
        userId: map['userId'] != null ? map['userId'] as String : '',
        userToken: map['userToken'] != null ? map['userToken'] as String : '',
        email: map['email'] != null ? map['email'] as String : '',
        userName: map['userName'] != null ? map['userName'] as String : '',
        deviceId: map['deviceId'] != null ? map['deviceId'] as String : '',
      );

  factory UserDetailsModel.fromJson(String source) =>
      UserDetailsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  final String userId;
  final String userToken;
  final String email;
  final String userName;
  final String deviceId;

  String get firstName => userName.split(' ').first;

  String get lastName => userName.split(' ').sublist(1).join(' ');

  UserDetailsModel copyWith({
    String? userId,
    String? userToken,
    String? email,
    String? userName,
    String? deviceId,
  }) =>
      UserDetailsModel(
        userId: userId ?? this.userId,
        userToken: userToken ?? this.userToken,
        email: email ?? this.email,
        userName: userName ?? this.userName,
        deviceId: deviceId ?? this.deviceId,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'userId': userId,
        'userToken': userToken,
        'email': email,
        'userName': userName,
        'deviceId': deviceId,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'UserDetailsModel(userId: $userId, userToken: $userToken, email: $email, userName: $userName,deviceId:$deviceId)';

  @override
  bool operator ==(covariant UserDetailsModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userToken == userToken &&
        other.email == email &&
        other.userName == userName &&
        other.deviceId == deviceId;
  }

  @override
  int get hashCode =>
      userId.hashCode ^
      userToken.hashCode ^
      email.hashCode ^
      userName.hashCode ^
      deviceId.hashCode;
}
