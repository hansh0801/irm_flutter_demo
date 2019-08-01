import 'package:flutter/material.dart';
import 'irm_auth.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Make_Form extends StatefulWidget {
  @override
  _Make_FormState createState() => _Make_FormState();
}

class _Make_FormState extends State<Make_Form> {

  File imageFile;

  openGallery(BuildContext context) async{
    var picture= await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.pop(context);

  }


  openCamera(BuildContext context) async{
    var picture= await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {

      imageFile = picture;


    });
    Navigator.pop(context);


  }




  Future<void> showChiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("make a chice"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallary"),
                    onTap: (){
                      openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("camera"),
                    onTap: (){
                      openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
  Widget _decideImageview(){
    if(imageFile == null) {
      return Text("no image");
    }else{
     return Image.file(imageFile,width: 180,height: 180,);

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("make form"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _decideImageview(),

          RaisedButton(
            onPressed: () {showChiceDialog(context);},
            child: Text("select Image"),
          )
        ],
      )),
    );
  }
}
