import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lista_deseos/controller/db_responsible.dart';
import 'package:lista_deseos/pages/page_main.dart';
import 'package:lista_deseos/widget/myInputText.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextStyle _styleTitle =
  const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 30.0);
  final TextStyle _styleText =
  const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 20.0);

  late MyInputText _myHandelUser;
  late TextField _textUser;
  late TextEditingController _controllerUser;

  late MyInputText _myHandelPass;
  late TextField _textPassword;
  late TextEditingController _controllerPass;

  final String _user = "admin";
  final String _pass = "123456";


  @override
  void initState() {
    _myHandelUser = MyInputText("Nombre de Usuario", TextInputType.text);
    _textUser = _myHandelUser.getInputText();
    _controllerUser = _myHandelUser.getTextController();

    _myHandelPass = MyInputText("Clave de Usuario", TextInputType.visiblePassword);
    _textPassword = _myHandelPass.getInputText();
    _controllerPass = _myHandelPass.getTextController();
  }

  @ override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(32, 148, 173, 1.0),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100.0,
                    child: Text(
                      'Bienvenido a la Apk\n Lista de Deseos.',
                      style: _styleTitle,
                      textAlign: TextAlign.center,
                    )),
                SizedBox(
                  height: 30,
                  child: Text(
                      "Acceso",
                      style: _styleText,
                  ),
                ),
                const SizedBox(height: 15,),
                _textUser,
                const SizedBox(height: 15,),
                _textPassword,
                const SizedBox(height: 30,),
                ElevatedButton(
                  child: const Text("Aceptar"),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    elevation: 5,
                    textStyle: const TextStyle(
                      fontSize: 20,
                    ),
                    minimumSize: const Size(200, 40),
                  ),
                  onPressed: (){
                    _sendLogin();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _sendLogin() async {
    if(_controllerUser.text == _user){
      if(_controllerPass.text == _pass){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => Main(user: _user,)
            )
        );
      } else{
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: 'Error (login)',
            desc: "El password es incorrecto",
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
            .show();
      }
    } else{
      String tmpLogin = await DBResponsible().getLogin(_controllerUser.text,
                                                 _controllerPass.text);

      if(tmpLogin == "Ok"){
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => Main(user: _controllerUser.text,)
            )
        );
      } else{
        AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: true,
            title: 'Error (login)',
            desc: tmpLogin,
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
            .show();
      }

    }
  }
}
