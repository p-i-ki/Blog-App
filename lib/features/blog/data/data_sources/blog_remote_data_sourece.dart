import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSourece {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage({
    required BlogModel blog,
    required File imageurl,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSourece {
  final SupabaseClient supabaseClient;
  const BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogDate =
          await supabaseClient.from('blogs').insert(blog.toJson()).select();
      return BlogModel.fromMap(blogDate.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage({
    required BlogModel blog,
    required File imageurl,
  }) async {
    try {
      //here first we will store the image in the Storage bucket of Supabase,, this will give us an image url which we will store in the Database table..
      await supabaseClient.storage.from('blog_images').upload(
            blog.id, // it is the folder/file where we will store the image from our local system
            imageurl,
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // we are joining two tables "blogs" and "profiles" as we have posterId in the "blogs" tablee. And selecting "name"
      final blogs =
          await supabaseClient.from('blogs').select('*,profiles(name)');
      // "blogs" is a list of map , so we will 1st convert each map to BlogModel object them wrap them all inside a list and return
      return blogs
          .map(
            (blog) => BlogModel.fromMap(blog).copyWith(
              posterName: blog['profile']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}

// In supabase we access the auth-features using SupabaseClient.auth() ,, Database tables using SupabaseClient.from() ,, and storage-feature using SupabsseClient.storage()
