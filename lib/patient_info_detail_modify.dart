import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'get_patient_data.dart';
import 'package:flushbar/flushbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'japiRequest.dart';

//ignore_for_file: camel_case_types
//ignore_for_file: non_constant_identifier_names

class InfoModify extends StatefulWidget {
  final Patientlist patientinfo;
  var imageData;

  InfoModify({Key key, this.patientinfo, this.imageData}) : super(key: key);

  @override
  _InfoModifyState createState() => _InfoModifyState();
}

class _InfoModifyState extends State<InfoModify> {
  Patientlist return_patientinfo;
  String name, birth, phone, address, guardian;
  DateTime date = DateTime.now();
  var radioValue = 0;
  String sex = 'M';
  bool select = false;
  File imageFile;
  bool choose = false;

  openGallery(BuildContext context) async {
    print('asdf' + widget.imageData.toString());
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
      if (picture != null) {
        choose = true;
      }
    });
    Navigator.pop(context);
  }

  openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
      if (picture != null) {
        choose = true;
      }
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
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("camera"),
                    onTap: () {
                      openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<Null> selectDate(BuildContext context) async {
    var initDate;
    initDate = widget.patientinfo.patient_birth_dttm == null
        ? DateTime.now()
        : DateTime.parse(widget.patientinfo.patient_birth_dttm);
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initDate,
        firstDate: new DateTime(1960),
        lastDate: new DateTime(2020));
    if (picked != null && picked != date) {
      print("date selected:${picked.toString()}");
      setState(() {
        date = picked;
        select = true;
      });
    }
  }

  void handleRadioValueChange(value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          sex = 'M';
          break;
        case 1:
          sex = 'F';
          break;
        case 2:
          sex = 'O';
          break;
      }
    });
  }

  Widget PatientData(BuildContext context) => Column(
        children: <Widget>[
          InkWell(child: choose
              ? Image.file(
            imageFile,
            height: 150,
          )
              : widget.imageData.toString() !=
              Uint8List.fromList('null'.codeUnits).toString()
              ? Image.memory(
            widget.imageData,
            height: 150,
          )
              : Image.asset(
            "images/gray.png",
            height: 150,
          ),onTap: ()=>showChiceDialog(context),),

          DataTable(
            columns: <DataColumn>[
              DataColumn(
                  label: Text("Property"),
                  numeric: false,
                  onSort: (i, b) {},
                  tooltip: "irm company"),
              DataColumn(
                  label: Text("Patient Data"),
                  numeric: false,
                  onSort: (i, b) {},
                  tooltip: "Patient data")
            ],
            rows: <DataRow>[
              DataRow(cells: <DataCell>[
                DataCell(Text("Name")),
                DataCell(
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(),
                      initialValue: widget.patientinfo.patient_name,
                      onSaved: (input) => name = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Enter some Text";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                // stateless와 다르게 statefuld에서 ,paraameter 받을 때 widget.param 이렇게 써야함.
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text("patient sex")),
                DataCell(
                  Container(
                    child: Row(
                      ///라디오 버튼 사용
                      children: <Widget>[
                        Text('M'),
                        Radio(
                          value: 0,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange,
                        ),
                        Text('F'),
                        Radio(
                          value: 1,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange,
                        ),
                        Text('O'),
                        Radio(
                          value: 2,
                          groupValue: radioValue,
                          onChanged: handleRadioValueChange,
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text("Birth")),
                DataCell(
                  Container(
                    width: 200,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text("picked date:" +
                            (select
                                ? date.toString().substring(0, 10)
                                : widget.patientinfo.patient_birth_dttm
                                        ?.substring(0, 10) ??
                                    DateTime.now()
                                        .toString()
                                        .substring(0, 10))),
                        new IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            selectDate(context);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text("Phone")),
                DataCell(
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(),
                      initialValue: widget.patientinfo.patient_phone,
                      onSaved: (input) => phone = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Enter some Text";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text("Address")),
                DataCell(
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(),
                      initialValue: widget.patientinfo.patient_address,
                      onSaved: (input) => address = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Enter some Text";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ]),
              DataRow(cells: <DataCell>[
                DataCell(Text("Guardian")),
                DataCell(
                  Container(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(),
                      initialValue: widget.patientinfo.patient_guardian,
                      onSaved: (input) => guardian = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Enter some Text";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ],
      );

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //return_patientinfo = widget.patientinfo ;

    return Scaffold(
      appBar: new AppBar(
        title: Text("modify"),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.photo),
            onPressed: () {
              showChiceDialog(context);
            },
          )
        ],
      ),
      body: new Container(
        child: SingleChildScrollView(
          child: Center(
              child: new Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                            /*height: 380, width: 500,*/ child: PatientData(context)),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              if (formKey.currentState.validate()) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: new Text("title"),
                                        content:
                                            new Text("are you sure to modify?"),
                                        actions: <Widget>[
                                          new FlatButton(
                                              onPressed:
                                                  Navigator.of(context).pop,
                                              child: Text("No")),
                                          new FlatButton(
                                              onPressed: () async {
                                                formKey.currentState.save();
                                                return_patientinfo =
                                                    Patientlist(
                                                        widget.patientinfo
                                                            .vgroup_key,
                                                        widget.patientinfo
                                                            .patient_key,
                                                        widget.patientinfo
                                                            .patient_id_value,
                                                        name,
                                                        sex,
                                                        address,
                                                        date.toString(),
                                                        guardian,
                                                        phone);
                                                var result =
                                                    await putPatientData(
                                                        return_patientinfo
                                                            .patient_key,
                                                        return_patientinfo
                                                            .patient_name,
                                                        return_patientinfo
                                                            .patient_sex,
                                                        return_patientinfo
                                                            .patient_birth_dttm,
                                                        return_patientinfo
                                                            .patient_phone,
                                                        return_patientinfo
                                                            .patient_address,
                                                        return_patientinfo
                                                            .patient_guardian);

                                                var queryParameters = {
                                                  'patient_key':
                                                      return_patientinfo
                                                          .patient_key
                                                          .toString(),
                                                  'patient_photo': base64Encode(
                                                      imageFile
                                                          .readAsBytesSync()),
                                                  'photo_tag': 'main'
                                                };

                                                putPatientSetPhoto(
                                                    queryParameters);

                                                print(result);

                                                if (result["status_code"] ==
                                                    200) {
                                                  Flushbar(
                                                    flushbarPosition:
                                                        FlushbarPosition.BOTTOM,
                                                    message:
                                                        "Edit Request Success! Return To Main Page",
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    backgroundColor:
                                                        Colors.blueAccent,
                                                    duration:
                                                        Duration(seconds: 2),
                                                    leftBarIndicatorColor:
                                                        Colors.blueAccent,
                                                  )..show(context).then((r) =>
                                                      Navigator.popUntil(
                                                          context,
                                                          ModalRoute.withName(
                                                              'patients_info')));
                                                } else {
                                                  Flushbar(
                                                    flushbarPosition:
                                                        FlushbarPosition.BOTTOM,
                                                    message:
                                                        "Request failed! check out what you did",
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      size: 28.0,
                                                      color: Colors.redAccent,
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    duration:
                                                        Duration(seconds: 3),
                                                    leftBarIndicatorColor:
                                                        Colors.redAccent,
                                                  )..show(context).then((r) =>
                                                      Navigator.pop(context));
                                                }
                                              },
                                              child: Text("Yes"))
                                        ],
                                      );
                                    });
                              }
                            },
                            padding: EdgeInsets.all(12),
                            color: Colors.lightBlueAccent,
                            child: Text('수정하기',
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    ),
                  ))),
        ),
      ),
    );
  }
}
