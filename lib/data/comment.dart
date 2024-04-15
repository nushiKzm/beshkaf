class CommentEntity {
  final String id;
  final String title;
  final String content;
  final String date;
  final String email;

  CommentEntity.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        content = json['content'],
        date = json['createdAt'],
        email = json['author']['username'];
}
