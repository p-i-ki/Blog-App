import 'dart:io';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String content,
    required String title,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failures, List<Blog>>> getAllBlogs();
}
