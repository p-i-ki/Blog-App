import 'package:blog_app/core/entities/user.dart';

// here a user model extending a user entity - Liskov substitution principle(SOLID) .. we can replace one with another without any problem(parent-child relationship) ..
// Because in the Domain layer we can't use UserModel (for maintaining abstraction and decoupling) instead we have to use User class(Higher-level module) ..
class UserModel extends User {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}

//The fromJson factory constructor allows you to create an instance of UserModel from a JSON-like map.. It returns a new UserModel instance by extracting values from the map or Json and passing them to the regular constructor.
//Unlike a regular constructor, a factory constructor can return an existing instance, a new instance, or even a subclass instance.
