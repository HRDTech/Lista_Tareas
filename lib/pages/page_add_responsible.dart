import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lista_deseos/controller/db_responsible.dart';
import 'package:lista_deseos/model/Responsible.dart';
import 'package:lista_deseos/pages/page_main.dart';
import 'package:lista_deseos/widget/myInputText.dart';
import 'package:nuid/nuid.dart';

class AddResponsible extends StatefulWidget {
  AddResponsible({Key? key, required this.user}) : super(key: key);
  String user;

  @override
  createState() => _AddResponsible();
}

class _AddResponsible extends State<AddResponsible> {
  final TextStyle _styleTitle =
  const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 20.0);

  late MyInputText _myAuthor;
  late TextField _textAuthor;
  late TextEditingController _controllerAuthor;

  late MyInputText _myPassword;
  late TextField _textPass;
  late TextEditingController _controllerPass;

  @override
  void initState() {
    _myAuthor = MyInputText("Nombre", TextInputType.text);
    _textAuthor = _myAuthor.getInputTextCustom();
    _controllerAuthor = _myAuthor.getTextController();

    _myPassword = MyInputText("Password", TextInputType.visiblePassword);
    _textPass = _myPassword.getInputPassCustom();
    _controllerPass = _myPassword.getTextController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
        leading: IconButton(
          tooltip: 'Previous choice',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => Main(user: widget.user,)
                )
            );
          },
        ),
        title: Text(
          "Agregar responsable...",
          style: _styleTitle,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                    const SizedBox(height: 30,),
                    _textAuthor,
                    const SizedBox(height: 15,),
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
                        child: getMyDropdown(),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    _textPass,
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.person_add),
                          ),
                          Text("Agregar Responsable"),
                        ],
                      ),
                      onPressed: (){
                        if(_controllerAuthor.text.isNotEmpty){
                          if(_controllerPass.text.isNotEmpty){
                            insertResponsible();
                          } else{
                            AwesomeDialog(
                                context: context,
                                dialogType: DialogType.ERROR,
                                animType: AnimType.RIGHSLIDE,
                                headerAnimationLoop: true,
                                title: 'Error (password)',
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
                              title: 'Error (author)',
                              desc: "El author no puede estar en blanco",
                              btnOkOnPress: () {},
                              btnOkIcon: Icons.cancel,
                              btnOkColor: Colors.red)
                              .show();
                        }
                      }, )
                  ],
              ),
          ),
        ),
      ),
    );
  }

  //----------Dropdown------------------------
  String _chosenValue = "Proyecto1";

  DropdownButton getMyDropdown(){
    return DropdownButton<String>(
      value: _chosenValue,
      style: const TextStyle(color: Colors.white),
      items: <String>[
        'Proyecto1',
        'Proyecto2',
        'Proyecto3',
        'Proyecto4',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child:Text(
            value,
            style: const TextStyle(color: Colors.black),
          )
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value!;
        });
      },
    );
  }

  void insertResponsible(){
    final uid = Nuid.instance;

    var data = Responsible(
        _controllerAuthor.text,
        _chosenValue,
        _controllerPass.text,
      uid.next()
    );

    DBResponsible().addResponsible(data);

    AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        headerAnimationLoop: true,
        title: 'Selecciones',
        desc: "Desea agregar otro responsable ??",
        btnOkOnPress: () {
          setState(() {
            _controllerAuthor.text = "";
            _controllerPass.text = "";
            _chosenValue = "Proyecto1";
          });
        },
        btnOkIcon: Icons.check,
        btnOkText: "Si",
        btnOkColor: Colors.blueGrey,
        btnCancelOnPress: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => Main(user: widget.user,)
              )
          );
        },
        btnCancelIcon: Icons.close,
        btnCancelText: "No",
        btnCancelColor: Colors.black45)
        .show();
  }
}
