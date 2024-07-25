class Task {
  int? id;
  String? title;
  String? description;
  bool isCompleted;
  bool isArchived;

  Task(
      {this.id,
      this.title,
      this.description,
      this.isCompleted = false,
      this.isArchived = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'isArchived': isArchived ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      isArchived: map['isArchived'] == 1,
    );
  }
}
