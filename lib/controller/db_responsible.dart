import 'package:hive/hive.dart';
import 'package:lista_deseos/model/Responsible.dart';

class DBResponsible {
  final String _nameTable = "table_responsible";

  Future<void> addResponsible(Responsible responsible) async {
    var box = await Hive.openBox(_nameTable);
    await box.add(responsible.getAll());
  }

  Future<List<Map<String, dynamic>>> getResponsibleAll() async {
    var box = await Hive.openBox(_nameTable);

    final data = box.keys.map((key) {
      final value = box.get(key);
      return {"key": key,
              "author": value["author"],
              "project": value["project"],
              "pass": value["pass"],
              "uid": value["uid"]};
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

  Future<Map<String, dynamic>> getResponsibleItem(int key) async {
    var box = await Hive.openBox(_nameTable);
    final data = box.get(key);
    return data;
  }

  Future<void> setUpdateItem(int key, Responsible value) async {
    var box = await Hive.openBox(_nameTable);
    box.put(key, value.getAll());
  }

  Future<String> getLogin(String user, String pass) async{
    var box = await Hive.openBox(_nameTable);
    String statusLogin = "Error";

    for(int i=0; i < box.length; i++ ){
      final value = box.getAt(i);

      if (value["author"].toString() == user){
        if(value["pass"].toString() == pass){
          return "Ok";
        } else{
          statusLogin = "El password no existe";
        }
      } else {
        statusLogin = "El usuario no existe";
      }
    }

    return statusLogin;
  }
}