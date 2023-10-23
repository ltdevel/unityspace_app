class UserResponse {
  final int id;
  final int globalId;
  final String name;
  final String email;
  final String? avatar;
  final String? phoneNumber;
  final String? telegramLink;
  final String? githubLink;
  final String? birthDate;

  const UserResponse({
    required this.id,
    required this.globalId,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phoneNumber,
    required this.telegramLink,
    required this.githubLink,
    required this.birthDate,
  });

  factory UserResponse.fromJson(Map<String, dynamic> map) {
    return UserResponse(
      id: map['id'] as int,
      globalId: map['globalId'] as int,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String?,
      phoneNumber: map['phoneNumber'] as String?,
      telegramLink: map['telegramLink'] as String?,
      githubLink: map['githubLink'] as String?,
      birthDate: map['birthDate'] as String?,
    );
  }
}

class User {
  final int id;
  final int globalId;
  final String name;
  final String email;
  final String avatar;
  final String phoneNumber;
  final String telegramLink;
  final String githubLink;
  final String birthDate;

  const User({
    required this.id,
    required this.globalId,
    required this.name,
    required this.email,
    required this.avatar,
    required this.phoneNumber,
    required this.telegramLink,
    required this.githubLink,
    required this.birthDate,
  });
}
