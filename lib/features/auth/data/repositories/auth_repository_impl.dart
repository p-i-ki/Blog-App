import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/auth/data/daata_resources/auth_remote_data_source.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  // we will not initialize it instead we will do dependency injection..SO that we only depend on interface not on implementation..
  // for this We are declaring a Variable(not an instance) of type AuthRemoteDataSource interface means it can hold any object which implements AuthRemoteDataSource .. here it is AuthRemoteDataSourceImpl object which we will pass to this AuthRepositoryImpl constructor.. and this object will call its' props and methods ..
  final AuthRemoteDataSource authRemoteDataSource;
  const AuthRepositoryImpl({required this.authRemoteDataSource});
  // Here we are also returning User instead of UserModel as here we are not actually comminicating with the externel data sources..
  @override
  Future<Either<Failures, User>> logInWithEmailPassword(
      {required String email, required String password}) async {
    return _getUser(
      // here we are calling the logInWithEmailPassword() method of AuthRemoteDataSourceImpl
      () async => await authRemoteDataSource.logInWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    return _getUser(
      // here we are calling the signUpWithEmailPassword() method of AuthRemoteDataSourceImpl
      () async => await authRemoteDataSource.signUpWithEmailPassword(
        email: email,
        password: password,
        name: name,
      ),
    );
  }

//since both the signup and signin functions are same so we had defined this reusable function..
  Future<Either<Failures, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();
      return right(user);
    } on sb.AuthException catch (e) {
      return left(Failures(e.message));
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(
          const Failures("User is not Logged in"),
        );
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
