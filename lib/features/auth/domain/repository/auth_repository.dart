import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  //here we can't return UserModel as it is part of Data layer(DIP) , so we are returning User
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failures, User>> logInWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failures, User>> currentUser();
}
