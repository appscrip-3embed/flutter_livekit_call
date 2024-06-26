import 'dart:convert';

class IsmLiveMetaData {
  const IsmLiveMetaData({
    this.country = 'India',
    this.openMeeting = false,
    this.openStream = false,
    this.secretMessage = false,
    this.profilePic,
    this.firstName,
    this.lastName,
    this.parentMessageBody,
  });

  factory IsmLiveMetaData.fromMap(Map<String, dynamic> map) => IsmLiveMetaData(
        country: map['country'] as String? ?? '',
        openMeeting: map['open meeting'] as bool? ?? false,
        profilePic: map['profilePic'] as String?,
        firstName: map['firstName'] as String?,
        lastName: map['lastName'] as String?,
        openStream: map['open stream'] as bool? ?? false,
        secretMessage: map['secretMessage'] as bool? ?? false,
        parentMessageBody: map['parentMessageBody'] as String?,
      );

  factory IsmLiveMetaData.fromJson(String source) =>
      IsmLiveMetaData.fromMap(json.decode(source) as Map<String, dynamic>);

  final String country;
  final bool openMeeting;
  final String? profilePic;
  final String? firstName;
  final String? lastName;
  final bool openStream;
  final bool secretMessage;
  final String? parentMessageBody;

  IsmLiveMetaData copyWith({
    String? country,
    bool? openMeeting,
    String? profilePic,
    String? firstName,
    String? lastName,
    bool? openStream,
    bool? secretMessage,
    String? parentMessageBody,
  }) =>
      IsmLiveMetaData(
        country: country ?? this.country,
        openMeeting: openMeeting ?? this.openMeeting,
        profilePic: profilePic ?? this.profilePic,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        openStream: openStream ?? this.openStream,
        secretMessage: secretMessage ?? this.secretMessage,
        parentMessageBody: parentMessageBody ?? this.parentMessageBody,
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'country': country,
        'openMeeting': openMeeting,
        'profilePic': profilePic,
        'firstName': firstName,
        'lastName': lastName,
        'openStream': openStream,
        'secretMessage': secretMessage,
        'parentMessageBody': parentMessageBody,
      };

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'IsmLiveMetaData(country: $country, openMeeting: $openMeeting, profilePic: $profilePic, firstName: $firstName, lastName: $lastName, openStream: $openStream, secretMessage: $secretMessage, parentMessageBody: $parentMessageBody)';

  @override
  bool operator ==(covariant IsmLiveMetaData other) {
    if (identical(this, other)) return true;

    return other.country == country &&
        other.openMeeting == openMeeting &&
        other.profilePic == profilePic &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.openStream == openStream &&
        other.secretMessage == secretMessage &&
        parentMessageBody == other.parentMessageBody;
  }

  @override
  int get hashCode =>
      country.hashCode ^
      openMeeting.hashCode ^
      profilePic.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      openStream.hashCode ^
      secretMessage.hashCode ^
      parentMessageBody.hashCode;
}
