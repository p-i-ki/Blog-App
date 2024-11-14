import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogIn implements UseCase<User, UserLoginParams> {
  // authRepository is not an instance ,, it is a variable of type AuthRepository ,,means it can hold any object of those classes which extends or implements AuthRepository class
  // that's why we can pass object of AuthRepositoryImpl to UserLogIn use case instead of AuthRepository instance..
  final AuthRepository authRepository;
  const UserLogIn(this.authRepository);
  @override
  Future<Either<Failures, User>> call(UserLoginParams params) async {
    //we are calling the logInWithEmailPassword() method of AuthRepositoryImpl class not AuthRepository class..
    return await authRepository.logInWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({
    required this.email,
    required this.password,
  });
}
