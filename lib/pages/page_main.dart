import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:lista_deseos/controller/db_task.dart';
import 'package:lista_deseos/pages/page_add_responsible.dart';
import 'package:lista_deseos/pages/page_add_task.dart';
import 'package:lista_deseos/pages/page_login.dart';

import '../model/Task.dart';


class Main extends StatefulWidget {
  Main({Key? key, required this.user}) : super(key: key);
  String user;

  @override
  createState() => _Main();
}

class _Main extends State<Main> {
  List<Map<String, dynamic>> _itemsTask = [];
  Widget _displayWidget = Container();
  final GlobalKey<FabCircularMenuState> _fabKey = GlobalKey();
  final TextStyle _styleTitle =
  const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  void initState(){
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
        title: Text(
          "Inicio",
          style: _styleTitle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const Login()
                    )
                );
              }
           )
        ],
      ),
    floatingActionButton: widget.user == "admin"?
    FabCircularMenu(
      key: _fabKey,
      ringColor: const Color.fromRGBO(32, 148, 173, 1.0),
      ringWidth: 100,
      children: <Widget>[
        const SizedBox(height: 20,),
        IconButton(icon: const Icon(Icons.people), onPressed: () {
          _fabKey.currentState?.close();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AddResponsible(user: widget.user,)
            )
          );
         }
        ),
        IconButton(icon: const Icon(Icons.task), onPressed: () {
          _fabKey.currentState?.close();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => AddTask(user: widget.user,)
            )
          );
        }
      ),
      const SizedBox(height: 20,),
      ]
    ):Container() ,
    body: SingleChildScrollView(
    child: Center(
          child: Padding(
            padding:  const EdgeInsets.all(20),
            child: _displayWidget
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    if (widget.user == "admin"){
      _itemsTask = await DBTask().getTaskAll();
    } else{
      _itemsTask = await DBTask().getTaskItemsSelect(widget.user) as List<Map<String, dynamic>>;
    }

    if(_itemsTask.isNotEmpty){
      setState(() {
        _displayWidget = getDisplayItems();
      });
    }


  }

  Widget getDisplayItems(){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
      // the list of items
        itemCount: _itemsTask.length,
        itemBuilder: (_, index) {
          final currentItem = _itemsTask[index];
          return Card(
            color: Colors.white60,
            margin: const EdgeInsets.all(10),
            elevation: 3,
            child: ListTile(
                title: Text(currentItem['title'] ?? "nueva"),
                subtitle: Text(currentItem["author"] ?? "nueva"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0,
                          top: 0.0,
                          right: 20.0,
                          bottom: 0.0),
                      child: ElevatedButton(
                        child: Text(currentItem["status"] ?? "nueva"),
                        onPressed: (){
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.BOTTOMSLIDE,
                              headerAnimationLoop: true,
                              title: 'Selecciones',
                              desc: "Va a cambiar el estado de la tarea " + currentItem["title"],
                              btnOkOnPress: () {
                                if(widget.user == "admin"){
                                  var data = Task(
                                      currentItem["title"],
                                      currentItem["description"],
                                      currentItem["type"],
                                      currentItem["date"],
                                      currentItem["author"],
                                      currentItem["project"],
                                      "Abierta");

                                  DBTask().setUpdateTask(currentItem["key"], data);
                                } else{
                                  if(currentItem["status"] == "Iniciar"){
                                    var data = Task(
                                        currentItem["title"],
                                        currentItem["description"],
                                        currentItem["type"],
                                        currentItem["date"],
                                        currentItem["author"],
                                        currentItem["project"],
                                        "Terminar");
                                    DBTask().setUpdateTask(currentItem["key"], data);
                                  } else{
                                    var data = Task(
                                        currentItem["title"],
                                        currentItem["description"],
                                        currentItem["type"],
                                        currentItem["date"],
                                        currentItem["author"],
                                        currentItem["project"],
                                        "Iniciar");
                                    DBTask().setUpdateTask(currentItem["key"], data);
                                  }

                                }

                                loadData();
                              },
                              btnOkIcon: Icons.check,
                              btnOkText: "Si",
                              btnOkColor: Colors.blueGrey,
                              btnCancelOnPress: (){
                              },
                              btnCancelIcon: Icons.close,
                              btnCancelText: "No",
                              btnCancelColor: Colors.black45)
                              .show();
                        },
                      ),
                    ),
                    // Delete button
                    IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          DBTask().setDeleteItem(currentItem['key']);
                          loadData();
                        }
                    ),
                  ],
                )),
          );
        });
  }

}
