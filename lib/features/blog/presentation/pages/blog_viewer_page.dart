import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  static rout(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewerPage(
          blog: blog,
        ),
      );
  const BlogViewerPage({
    required this.blog,
    super.key,
  });
  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  'By ${blog.posterName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${formatDate(blog.updatedAt)} ${calculateReadingTime(blog.content)} min',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: AppPallete.greyColor),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(height: 20),
                Text(
                  blog.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
