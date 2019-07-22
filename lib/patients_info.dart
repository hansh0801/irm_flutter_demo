import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'japiRequest.dart';

import 'get_patient_data.dart';
import 'patients_info_detailpage.dart';

List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;
List<Group> grouplist=[];
Group currentgroupkey = Group(38061, "Test");
List<Patientlist> allPatientList = [];
List<Patientlist> searchPatientList = [];
bool notSearched = true;

final TextEditingController _textEditingController =
new TextEditingController();

Future<List<Patientlist>> _getPatientList(int currentgroupkey) async{
  var jsondata = await getPatientList(currentgroupkey);

  print("start $jsondata");
  List<Patientlist> PatientLists = [];
  for (var u in jsondata) {
    var photoData = await getPatientPhoto(u['patient_key']);
    Patientlist patientlist = Patientlist(
        u["vgroup_key"], u['patient_key'], u['patient_id_value'], u['patient_name'], u['patient_sex'],
        u['patient_address'] ,u['patient_birth_dttm'] ,u['patient_guardian'] , u['patient_phone'], photoData);
    print(patientlist.patient_key);
    PatientLists.add(patientlist);
  }

  notSearched = true;
  print(PatientLists.length);
  return PatientLists;
}

class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info>  {
  ValueNotifier<String> valueNotifier = new ValueNotifier(_currentGroup);

  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int index;
    index = 0;
    Group group;

    for (; index < patient_group['records'].length; index++) {
      group = Group(patient_group['records'][index]['vgroup_key'],patient_group['records'][index]['vgroup_name']);
      print(group.vgroup_name);
      print(group.vgroup_key);

      items.add(new DropdownMenuItem(value: group.vgroup_name, child: new Text(group.vgroup_name)));
      grouplist.add(group);
      //print(group);
      // print(grouplist);
    }

    return items;
  }

  void changedDropDownItem(String selectedGroup) {
    print("Selected city $selectedGroup, we are going to refresh the UI");
    setState(() {
      _currentGroup = selectedGroup;
      currentgroupkey = grouplist.firstWhere(((user) =>user.vgroup_name ==_currentGroup));
      print(currentgroupkey.vgroup_key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: Text("Patient info"),
        ),
        body: Container(
          child:MyappBar(),
        )
    );
  }
}

class MyappBar extends StatefulWidget {
  @override
  const MyappBar();
  _MyappBarState createState() => _MyappBarState();
}

class _MyappBarState extends State<MyappBar> {
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int index;
    index = 0;
    Group group;

    for (; index < patient_group['records'].length; index++) {

      group = Group(patient_group['records'][index]['vgroup_key'],
          patient_group['records'][index]['vgroup_name']);
      print(group.vgroup_name);
      print(group.vgroup_key);

      items.add(new DropdownMenuItem(value: group.vgroup_name, child: new Text(group.vgroup_name)));
      grouplist.add(group);
      //print(group);
     // print(grouplist);
    }

    return items;
  }

  void changedDropDownItem(String selectedGroup) {
    print("Selected city $selectedGroup, we are going to refresh the UI");
    setState(() {
      _currentGroup = selectedGroup;
      currentgroupkey = grouplist.firstWhere(((user) =>user.vgroup_name ==_currentGroup));
      print(currentgroupkey.vgroup_key);
    });
  }

  void _handleSubmitted(String text) {
    setState(() {
      searchPatientList.clear();
      notSearched = false;
      for(var i = 0; i < allPatientList.length; i++){
        if(allPatientList[i].patient_name.contains(text)){
          searchPatientList.add(allPatientList[i]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Container(
              padding: new EdgeInsets.all(10.0),
            ),
            new DropdownButton(
              value: _currentGroup,
              items: _dropDownMenuItems,
              onChanged: changedDropDownItem,
            ),
            new Row(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Flexible(
                  child: TextField(
                    controller: _textEditingController,
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration.collapsed(
                      hintText: "검색할 환자를 입력하세요",
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  padding: new EdgeInsets.all(8.0),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () =>
                          _handleSubmitted(_textEditingController.text)),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: 200.0,
                  child: FutureBuilder(
                      future:_getPatientList(currentgroupkey.vgroup_key),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        allPatientList = snapshot.data;

                        if(snapshot.data ==null){
                          return Container(
                            child: Center(
                              child: Text("loading"),
                            ),
                          );
                        }
                        else{
                          if(notSearched){
                            return
                              ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (BuildContext context, int index){
                                    return
                                      Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                        child: Container(
                                          decoration: BoxDecoration(color:Colors.white),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                            leading: Container(
                                              padding: EdgeInsets.only(right: 15.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(width: 1.0, color: Colors.black26))),
                                              child: Image.memory(snapshot.data[index].patient_photo),
                                            ),
                                            title: Text(snapshot.data[index].patient_name.toString()),
                                            subtitle: Text(snapshot.data[index].patient_sex.toString()),
                                            trailing:
                                            Icon(Icons.keyboard_arrow_right, color: Colors.black26, size: 30.0),
                                            onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage())),
                                          ),
                                        ),
                                      );
                                  });
                          }
                          else{
                            return ListView.builder(
                                itemCount: searchPatientList.length,
                                itemBuilder: (BuildContext context, int index){
                                  return
                                    Card(
                                      elevation: 8.0,
                                      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                      child: Container(
                                        decoration: BoxDecoration(color:Colors.white),
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                          leading: Container(
                                            padding: EdgeInsets.only(right: 15.0),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    right: new BorderSide(width: 1.0, color: Colors.black26))),
                                            //child: Image.memory(snapshot.data[index].patient_photo),
                                          ),
                                          title: Text(searchPatientList[index].patient_name.toString()),
                                          subtitle: Text(searchPatientList[index].patient_sex.toString()),
                                          trailing:
                                          Icon(Icons.keyboard_arrow_right, color: Colors.black26, size: 30.0),
                                          onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage())),
                                        ),
                                      ),
                                    );
                                });
                          }
                        }}),
              ),
            )
          ]),
    );
  }
}

class Patientlist{
  final int vgroup_key;
  final int patient_key;
  final String patient_id_value;
  final String patient_name;
  final String patient_sex;
  final String patient_birth_dttm;
  final String patient_phone;
  final String patient_address;
  final String patient_guardian;
  final patient_photo;

  Patientlist(this.vgroup_key, this.patient_key, this.patient_id_value,this.patient_name,this.patient_sex,this.patient_address,
      this.patient_birth_dttm,this.patient_guardian,this.patient_phone, this.patient_photo);
}

class Group{
  final int vgroup_key;
  final String vgroup_name;

  Group(this.vgroup_key,this.vgroup_name);
  @override
  String toString() => "vgroup_key is $vgroup_key , vgroup name os $vgroup_name ";
}


///    "vgroup_key" : "30614",
///    "patient_id_value" : "P123",
///    "patient_name" : "PATIENT^NAME",
///    "patient_sex" : "M",
///    "patient_birth_dttm" : "2015-07-22T03:35:14",
///    "patient_phone" : "010-1234-5678",
///    "patient_address" : "somewhere",
///    "patient_guardian" : "God" 