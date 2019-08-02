import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'japiRequest.dart';


class Pick_Image extends StatefulWidget {
  @override
  _Pick_ImageState createState() => _Pick_ImageState();
}

class _Pick_ImageState extends State<Pick_Image> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.info),
            onPressed: (){ uploadPhoto(_image); },
          )
        ],
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

uploadPhoto(File image) async{
  var base64Image = base64Encode(image.readAsBytesSync());

  var queryParameters = {
    'patient_key' : '224011', //이름1
    'patient_photo' : base64Image,
    'photo_tag' : 'main',
  };

  putPatientSetPhoto(queryParameters);
}