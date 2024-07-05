import 'package:hive/hive.dart';

part 'LocalDatabaseModel.g.dart'; // This is where the generated code will be

@HiveType(typeId: 0) // Ensure typeId is unique and consistent
class User extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String email;

  @HiveField(2)
  late String password;

  @HiveField(3)
  late String phoneNumber;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });
}
