import 'package:flutter/material.dart';


class MyInputText {
  final String _textHint;
  final TextInputType _textType;
  final TextStyle _styleHint = const TextStyle(
      color: Colors.black54, fontFamily: 'Montserrat', fontSize: 16.0);
  final TextStyle _style =
  const TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController _textController = TextEditingController();

  getTextController() => _textController;

  MyInputText(this._textHint, this._textType);

  TextField getInputText(){
    if ( _textType == TextInputType.visiblePassword){
      return TextField(
          controller: _textController,
          obscureText: true,
          keyboardType:_textType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            hintText: _textHint,
            hintStyle: _styleHint,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)),
            prefixIcon: const Icon(Icons.password_rounded),
          ),
          style: _style,
      );
    } else{
      return TextField(
          controller: _textController,
          keyboardType: _textType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            hintText: _textHint,
            hintStyle: _styleHint,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0)),
            prefixIcon: const Icon(Icons.supervised_user_circle),
          ),
          style: _style,
      );
    }
  }

  TextField getInputTextCustom(){
    return TextField(
        controller: _textController,
        keyboardType: _textType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          hintText: _textHint,
          hintStyle: _styleHint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),
        style: _style,
    );
  }

  TextField getInputPassCustom(){
    return TextField(
        controller: _textController,
        obscureText: true,
        keyboardType: _textType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          hintText: _textHint,
          hintStyle: _styleHint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),
        style: _style,
    );
  }

  TextField getTextReadOnly(){
    return TextField(
        readOnly: true,
        controller: _textController,
        keyboardType: _textType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          hintText: _textHint,
          hintStyle: _styleHint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0)),
        ),
        style: _style,
    );
  }
}
