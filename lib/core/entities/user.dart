// ignore_for_file: public_member_api_docs, sort_constructors_first
// It acts as interface or parent class or base model for UserModel class.. And we will require it througout our app to access user data..
class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });
}

class NoParams {}
