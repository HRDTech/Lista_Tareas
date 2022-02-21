import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lista_deseos/controller/db_task.dart';
import 'package:lista_deseos/model/Task.dart';
import 'package:lista_deseos/pages/page_add_responsible.dart';
import 'package:lista_deseos/pages/page_main.dart';
import 'package:lista_deseos/widget/myInputText.dart';
import 'package:lista_deseos/controller/db_responsible.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AddTask extends StatefulWidget {
  AddTask({Key? key, required this.user}) : super(key: key);
  String user;

  @override
  createState() => _AddTask();
}

class _AddTask extends State<AddTask> {
  late MyInputText _myTaskTitle;
  late TextField _textTitle;
  late TextEditingController _controllerTitle;

  late MyInputText _myTaskDescription;
  late TextField _textDescription;
  late TextEditingController _controllerDescription;

  late String _textTaskType;
  final List<String> _listItemsTypes = <String>["Onal",
                                          "Inventario",
                                          "Alquiler",
                                          "Compra productos",
                                          "Transporte"];

  late String _textTaskAuthor;
  List<Map<String, dynamic>> _itemsAuthors = [];
  final List<String> _listItemsAuthors = <String>[];

  late MyInputText _myTaskProject;
  late TextField _textProject;
  late TextEditingController _controllerProject;
  final List<String> _listItemsProjects = <String>[];

  late Widget _displayView;

  final TextStyle _styleTitle =
  const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 20.0);

  late TextEditingController _controllerDate;

  @override
  void initState() {
    _displayView = Container();

    _myTaskTitle = MyInputText("Titulo de la tarea", TextInputType.text);
    _textTitle = _myTaskTitle.getInputTextCustom();
    _controllerTitle = _myTaskTitle.getTextController();

    _myTaskDescription = MyInputText("Descripcion de la tarea", TextInputType.text);
    _textDescription = _myTaskDescription.getInputTextCustom();
    _controllerDescription = _myTaskDescription.getTextController();

    _myTaskProject = MyInputText("Descripcion de la tarea", TextInputType.text);
    _textProject = _myTaskProject.getTextReadOnly();
    _controllerProject= _myTaskProject.getTextController();

    _controllerDate = TextEditingController();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Previous page',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => Main(user: widget.user)
                )
            );
          },
        ),
        backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
        title: Text(
          "Agrege una nueva tarea",
          style: _styleTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _displayView,
          ),
        ),
      ),
    );
  }

  //----------Dropdown Type------------------------
  DropdownButton getMyDropdownType(){
    return DropdownButton<String>(
      value: _textTaskType,
      elevation: 5,
      style: const TextStyle(color: Colors.black),
      items:_listItemsTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _textTaskType = value!;
        });
      },
    );
  }
  //==============================================================
  //----------Dropdown Type------------------------
  DropdownButton getMyDropdownAuthors(){
    return DropdownButton<String>(
      value: _textTaskAuthor,
      elevation: 5,
      style: const TextStyle(color: Colors.black),
      items:_listItemsAuthors.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _textTaskAuthor = value!;
          _controllerProject.text = _listItemsProjects[
                                   _listItemsAuthors.indexOf(_textTaskAuthor)];
        });
      },
    );
  }
  //==============================================================
  //-----------------Widget Display ------------------------------
  Widget getDisplayData(){
    final format = DateFormat("yyyy-MM-dd");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 20.0,),
        _textTitle,
        const SizedBox(height: 10.0,),
        _textDescription,
        const SizedBox(height: 10.0,),
        Container(
          width: double.infinity,
          height: 48.0,
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.blueGrey,
              width: 2.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: getMyDropdownType(),
          ),
        ),
        const SizedBox(height: 10.0,),
        Container(
          width: double.infinity,
          height: 48.0,
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.blueGrey,
              width: 2.0,
            ),
          ),
          child: DateTimeField(
            controller: _controllerDate,
            format: format,
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
          ),
        ),
        const SizedBox(height: 10.0,),
        Container(
          width: double.infinity,
          height: 48.0,
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.blueGrey,
              width: 2.0,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: getMyDropdownAuthors(),
          ),
        ),
        const SizedBox(height: 10.0,),
        _textProject,
        const SizedBox(height: 30.0,),
        ElevatedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.add_task),
              ),
              Text("Agregar Tarea"),
            ],
          ),
          onPressed: (){
            if(_controllerDescription.text.isNotEmpty){
              if(_controllerTitle.text.isNotEmpty){
                if(_controllerDate.text.isNotEmpty){
                  var data = Task(_controllerTitle.text,
                                  _controllerDescription.text,
                                  _textTaskType,
                                  _controllerDate.text,
                                  _textTaskAuthor,
                                  _controllerProject.text,
                                  "Nueva");
                  DBTask().addTask(data);
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      animType: AnimType.BOTTOMSLIDE,
                      headerAnimationLoop: true,
                      title: 'Selecciones',
                      desc: "Desea agregar otra tarea ??",
                      btnOkOnPress: () {
                        setState(() {
                          _controllerTitle.text = "";
                          _controllerDescription.text = "";
                          _textTaskType = "";
                          _controllerDate.text = "";
                        });
                      },
                      btnOkIcon: Icons.check,
                      btnOkText: "Si",
                      btnOkColor: Colors.blueGrey,
                      btnCancelOnPress: (){
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => Main(user: widget.user)
                            )
                        );
                      },
                      btnCancelIcon: Icons.close,
                      btnCancelText: "No",
                      btnCancelColor: Colors.black45)
                      .show();

                } else{
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.RIGHSLIDE,
                      headerAnimationLoop: true,
                      title: 'Error (Date)',
                      desc: "La fecha no puede estar en blanco",
                      btnOkOnPress: () {},
                      btnOkIcon: Icons.cancel,
                      btnOkColor: Colors.red)
                      .show();
                }
              } else{
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: true,
                    title: 'Error (titulo)',
                    desc: "El password no puede estar en blanco",
                    btnOkOnPress: () {},
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red)
                    .show();
              }
            } else{
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: true,
                  title: 'Error (descripcion)',
                  desc: "El author no puede estar en blanco",
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
                  .show();
            }
          },
        ),
      ],
    );
  }
  //==============================================================

  Future<void> loadData() async {
    _itemsAuthors = await DBResponsible().getResponsibleAll();

    if(_itemsAuthors.isNotEmpty){
      for (var item in _itemsAuthors){
        _listItemsAuthors.add(item["author"]);
        _listItemsProjects.add(item["project"]);
      }

      setState(() {
        _controllerProject.text = _listItemsProjects[0];
        _textTaskType = _listItemsTypes[0];
        _textTaskAuthor = _listItemsAuthors[0];
        _displayView = getDisplayData();
      });

    } else{
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: true,
          title: 'Error (author no existe)',
          desc: "Antes de crear una tarea debe existe un responsable",
          btnOkOnPress: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => AddResponsible(user: widget.user,)
                )
            );
          },
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
          .show();
    }
  }
}
