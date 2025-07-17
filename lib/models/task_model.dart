class TaskModel {
  final int? id;
  final String title;
  final DateTime date;
  final String category;
  final String priority;
  final bool completed;

  TaskModel({
    this.id,
    required this.title,
    required this.date,
    required this.category,
    required this.priority,
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'category': category,
      'priority': priority,
      'completed': completed ? 1 : 0,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      category: map['category'],
      priority: map['priority'],
      completed: map['completed'] == 1,
    );
  }
}
