import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:fluro/fluro.dart';
import "package:irm_prototype1/login_page.dart";
import 'home_page.dart';
import 'patients_info.dart';
import 'new_patient.dart';
import 'make_form.dart';
import 'image_viewer.dart';
import 'patient_photo.dart';
/////

void main() {
  Router router = new Router();
  router.define('login_page', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  }));

  router.define('home_page', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Home_Page();
  }));

  router.define('patients_info', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Patients_Info();
  }));


  router.define('new_patient', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new New_Patient();
  }));


  router.define('image_viewer', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Image_Viewer();
  }));


  router.define('make_form', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new Make_Form();
  }));


  router.define('patient_photo', handler: new Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new TakePictureScreen();
  }));




  runApp(new MaterialApp(
      title: 'App',
      home: new LoginPage(),
      onGenerateRoute: router.generator // Use our Fluro routers for this app.
  ));


}



