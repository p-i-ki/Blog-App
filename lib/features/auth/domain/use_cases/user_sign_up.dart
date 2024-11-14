import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failures, User>> call(UserSignUpParams params) async {
    //we can directly return it as it also returns Future<Either<Failures, String>>
    return await authRepository.signUpWithEmailPassword(
        email: params.email, password: params.password, name: params.name);
  }
}

//we are creating this class as we need to pass three parameters but UseCase takes only one ..
class UserSignUpParams {
  final String email;
  final String password;
  final String name;

  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
