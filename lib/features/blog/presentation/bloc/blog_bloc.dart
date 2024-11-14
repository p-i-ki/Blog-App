import 'dart:io';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUpload>(_onBlogUpload);
    on<BlogGetAllBlogs>(_onGetAllBlogs);
  }

  Future<void> _onBlogUpload(
    BlogUpload event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        image: event.image,
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        topics: event.topics,
      ),
    );
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogUploadSuccess()),
    );
  }

  Future<void> _onGetAllBlogs(
    BlogGetAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (r) => emit(BlogFetchSuccess(r)),
    );
  }
}
