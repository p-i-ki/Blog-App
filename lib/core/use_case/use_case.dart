import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

//we are taking succesType and Params from the implementing class..Because it is different for different classes..
abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failures, SuccessType>> call(Params params);
}
