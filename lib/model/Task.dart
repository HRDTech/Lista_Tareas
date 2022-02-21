
class Task {
  late String title;
  late String description;
  late String type;
  late String date;
  late String author;
  late String project;
  late String status;

  Task(this.title,
      this.description,
      this.type,
      this.date,
      this.author,
      this.project,
      this.status);

  Map<String,dynamic> getAll(){
    final map = <String, dynamic>{};
    map["title"] = title;
    map["description"] = description;
    map["type"] = type;
    map["date"] = date;
    map["status"] = status;
    map["author"] = author;
    map["project"] = project;

    return map;
  }

}