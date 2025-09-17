import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String password;

  @HiveField(3)
  DateTime dateOfBirth;

  @HiveField(4)
  String disease;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.dateOfBirth,
    required this.disease,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      // Exclude password for security reasons in backup
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'disease': disease,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: '', // Don't restore password from backup
      dateOfBirth: DateTime.parse(json['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      disease: json['disease'] ?? '',
    );
  }
}
