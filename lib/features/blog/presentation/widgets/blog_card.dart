import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entity/blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    required this.blog,
    super.key,
    required this.color,
  });
  final Blog blog;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.rout(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: blog.topics
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: Chip(label: Text(e)),
                            ))
                        .toList(),
                  ),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            Text('${calculateReadingTime(blog.content)} min')
          ],
        ),
      ),
    );
  }
}
