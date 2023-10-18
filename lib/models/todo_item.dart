
class TodoItem {
  final int userId;
  final int id;
  final String title;

  TodoItem({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory TodoItem.fromJson(Map<String, dynamic> json) {
    return TodoItem(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}