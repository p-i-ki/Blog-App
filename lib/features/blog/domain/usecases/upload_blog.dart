import 'dart:io';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/use_case/use_case.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;
  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failures, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
        image: params.image,
        content: params.content,
        title: params.title,
        posterId: params.posterId,
        topics: params.topics);
  }
}

class UploadBlogParams {
  final File image;
  final String posterId;
  final String title;
  final String content;
  final List<String> topics;

  UploadBlogParams({
    required this.image,
    required this.posterId,
    required this.title,
    required this.content,
    required this.topics,
  });
}
