

class Responsible {
  late String author;
  late String project;
  late String pass;
  late String uid;

  Responsible(
      this.author,
      this.project,
      this.pass,
      this.uid
      );

  Map<String,dynamic> getAll(){
    final map = <String, dynamic>{};
    map['author'] = author;
    map['project'] = project;
    map['pass'] = pass;
    map['uid'] = uid;
    return map;
  }
}