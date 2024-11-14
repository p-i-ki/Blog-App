import 'dart:io';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/data/data_sources/blog_remote_data_sourece.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositorieImpl implements BlogRepository {
  final BlogRemoteDataSourece blogRemoteDataSourece;
  BlogRepositorieImpl(this.blogRemoteDataSourece);
  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String content,
    required String title,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(), //generating an time based uuid
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSourece.uploadImage(
        blog: blogModel,
        imageurl: image,
      );
      // it will give us a new instance with all the previous data + new image url (Supabase Storage image url) ..// We can also use Cloudinary here to upload our images then add this urls to the supabase DB..
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      // Now we are uploading both blog and image to Supabase..
      final uploadedBlog = await blogRemoteDataSourece.uploadBlog(blogModel);
      return right(uploadedBlog);
    } on ServerException catch (e) {
      throw left(Failures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSourece.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
