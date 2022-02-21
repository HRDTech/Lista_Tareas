

import 'package:hive/hive.dart';
import 'package:lista_deseos/model/Task.dart';

class DBTask {
  final String _nameTable = "table_task";

  Future<void> addTask(Task task) async {
    var box = await Hive.openBox(_nameTable);
    await box.add(task.getAll());
  }

  Future<List<Map<String, dynamic>>> getTaskAll() async {
    var box = await Hive.openBox(_nameTable);

    final data = box.keys.map((key) {
      final value = box.get(key);
      return {"key": key,
        "title": value["title"],
        "description": value["description"],
        "type": value["type"],
        "date": value["date"],
        "status": value["status"],
        "author": value["author"],
        "project": value["project"]};
    }).toList();

    return data.reversed.toList();
  }

  Future<void> setDeleteTable() async {
    var box = await Hive.openBox(_nameTable);
    box.deleteFromDisk();
  }

  Future<void> setDeleteItem(int key) async {
    var box = await Hive.openBox(_nameTable);
    box.delete(key);
  }

  Future<Map<String, dynamic>> getTaskItem(int key) async {
    var box = await Hive.openBox(_nameTable);
    final data = box.get(key);
    return data;
  }

  Future<void> setUpdateTask(int key, Task value) async {
    var box = await Hive.openBox(_nameTable);
    box.put(key, value.getAll());
  }

  Future<List<dynamic>> getTaskItemsSelect(String valueTmp) async {
    var box = await Hive.openBox(_nameTable);
    List<Map<String, dynamic>> _items = [];
    var itemsKey = box.keys.map((key)
    {
      return key;
    }).toList();

    for(int i=0; i < box.length; i++ ){
      final value = box.getAt(i);
      final data = <String, dynamic>{};

      if (value["author"].toString() == valueTmp && value["status"].toString().toLowerCase() != "nueva"){
        data["key"] = itemsKey[i];
        data["title"] = value["title"];
        data["description"] = value["description"];
        data["type"] = value["type"];
        data["date"] = value["date"];
        data["status"] = value["status"];
        data["author"] = value["author"];
        data["project"] = value["project"];

        _items.add(data);
      }
    }

    return _items.reversed.toList();
  }
}