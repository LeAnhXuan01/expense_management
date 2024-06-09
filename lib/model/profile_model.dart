import 'enum.dart';

class Profile {
  String profileId;
  String userId;
  String displayName;
  String birthDate;
  Gender gender;
  String address;
  String profileImageUrl;

  Profile({
    required this.profileId,
    required this.userId,
    required this.displayName,
    required this.birthDate,
    required this.gender,
    required this.address,
    required this.profileImageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'profileId': profileId,
      'userId': userId,
      'displayName': displayName,
      'birthDate': birthDate,
      'gender': gender.index,
      'address': address,
      'profileImageUrl': profileImageUrl,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      profileId: map['profileId'],
      userId: map['userId'],
      displayName: map['displayName'],
      birthDate: map['birthDate'],
      gender: Gender.values[map['gender']],
      address: map['address'],
      profileImageUrl: map['profileImageUrl'],
    );
  }
}