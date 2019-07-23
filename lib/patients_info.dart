import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'japiRequest.dart';

import 'get_patient_data.dart';
import 'patients_info_detailpage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;
List<Group> grouplist=[];




final TextEditingController _textEditingController =
new TextEditingController();




Stream<List<Patientlist>> _getPatientList(int currentgroupkey) async*{


  var jsondata = await getPatientList(currentgroupkey);

  print("start $jsondata");
  List<Patientlist> PatientLists = [];
  for (var u in jsondata){

    Patientlist patientlist = Patientlist(u["vgroup_key"], u['patient_key'], u['patient_id_value'], u['patient_name'], u['patient_sex'],u['patient_address'] ,u['patient_birth_dttm'] ,u['patient_guardian'] , u['patient_phone']);

    print(patientlist.vgroup_key);

    PatientLists.add(patientlist);

  }


  print(PatientLists.length);

  yield PatientLists;



}

class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info>  {


  @override
  Widget build(BuildContext context) {

    return Scaffold(

        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title: Text("Patient info"),
        ),

        body: Container(

          child:PatientInfoHomePage(),

        )
    );
  }
}



class PatientInfoHomePage extends StatefulWidget {
  @override
  //const PatientInfoHomePage();
  _PatientInfoHomePageState createState() => _PatientInfoHomePageState();
}

class _PatientInfoHomePageState extends State<PatientInfoHomePage> {

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
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
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

  void _handleSubmitted(String text) {
    _textEditingController.clear();
    setState(() {

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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(

                )
              ),
              child: new DropdownButton(
                value: _currentGroup,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,

              ),
            ),
            new Row(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Flexible(

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: _handleSubmitted,
                      decoration: new InputDecoration(
                        labelText: "search",
                        hintText: "검색할 환자를 입력하세요",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        )
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
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
                )
                ,




              ],
            ),
            Expanded(
              child: SizedBox(
                height: 200.0,
                  child: StreamBuilder(


                      stream:_getPatientList(currentgroupkey.vgroup_key),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.data ==null){
                          return Container(
                            child: SpinKitWave(
                              color: Colors.lightBlueAccent,
                              size: 50,

                            )
                          );

                        }
                        else{
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
                                                  right: new BorderSide(width: 1.0, color: Colors.black26)),),
                                          child: Image.network(
                                          "http://extmovie.maxmovie.com/xe/files/attach/images/174/863/001/009/fbe5e526bf8e5f38c75ab4aa68bbecea.jpg"),
                                        ),

                                        title: Text(snapshot.data[index].patient_name.toString()),
                                        subtitle: Text(snapshot.data[index].patient_sex.toString()),
                                          trailing:
                                          Icon(Icons.keyboard_arrow_right, color: Colors.black26, size: 30.0),
                                        onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(patientinfo:snapshot.data[index]))),

                                      ),
                                    ),
                                  );




                                });


                        }}),
              ),

            )

          ]),



    );
  }
}








///   4 "vgroup_key" : "30614",
///   3 "patient_id_value" : "P123",
///    1"patient_name" : "PATIENT^NAME",
///   2 "patient_sex" : "M",
///    5"patient_birth_dttm" : "2015-07-22T03:35:14",
///    "patient_phone" : "010-1234-5678",
///    "patient_address" : "somewhere",
///    "patient_guardian" : "God" 