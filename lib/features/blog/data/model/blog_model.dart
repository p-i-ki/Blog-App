import 'dart:convert';
import 'package:blog_app/features/blog/domain/entity/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    super.posterName,
  });

//Dart object to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poster_id': posterId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

//Map to dart object
  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['poster_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['image_url'] as String,
      topics: List<String>.from(map['topics'] ?? []),
      updatedAt: map['updated_at'] == null
          ? DateTime.now()
          : DateTime.parse(
              map['updated_at']), //from database it is comming as String
    );
  }

//Map to Json object..
  String toJson() => json.encode(toMap());

//Json object to map
  factory BlogModel.fromJson(String source) =>
      BlogModel.fromMap(json.decode(source) as Map<String, dynamic>);

  BlogModel copyWith({
    String? id,
    String? posterId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? posterName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      posterId: posterId ?? this.posterId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      posterName: posterName ?? this.posterName,
    );
  }
}


// toMap() -> Dart object to Map ,, toJson() -> Map to Json object.. => for sending to data to Remote server or Databse..
// fromMap() -> Map to Dart object ,, fromJson() -> Json object to Map.. => for storing the data came from the Remote server or Database..