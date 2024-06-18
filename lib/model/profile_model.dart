import 'enum.dart';

class Profile {
  String profileId;
  String userId;
  String displayName;
  String birthDate;
  Gender gender;
  String address;
  String profileImageUrl;
  String job;
  Profile({
    required this.profileId,
    required this.userId,
    required this.displayName,
    required this.birthDate,
    required this.gender,
    required this.address,
    required this.profileImageUrl,
    required this.job,
  });

  Map<String, dynamic> toMap() {
    return {
      'profileId': profileId,
      'userId': userId,
      'displayName': displayName,
      'birthDate': birthDate,
      'gender': gender.index,
      'address': address,
      'job': job,
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
      job: map['job'],
      profileImageUrl: map['profileImageUrl'],
    );
  }
  // factory Profile.fromMap(Map<String, dynamic> map) {
  //   return Profile(
  //     profileId: map['profileId'] ?? '',
  //     userId: map['userId'] ?? '',
  //     displayName: map['displayName'] ?? '',
  //     birthDate: map['birthDate'] ?? '',
  //     gender: Gender.values[map['gender'] ?? 0], // Assuming 0 is the default for Gender
  //     address: map['address'] ?? '',
  //     job: map['job'] ?? '',
  //     profileImageUrl: map['profileImageUrl'] ?? '',
  //   );
  // }
}