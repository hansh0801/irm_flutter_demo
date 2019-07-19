import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'japiRequest.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'get_patient_data.dart';

List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;
List<Group> grouplist=[];


final TextEditingController _textEditingController =
new TextEditingController();

void _handleSubmitted(String text) {
  _textEditingController.clear();
}

class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info>  {

  Future<List<Patientlist>> _getPatientList(currentgroupkey) async{

    var jsondata = await getPatientList(_currentGroup);
    List<Patientlist> PatientLists = [];
    for (var u in jsondata){
      Patientlist patientlist = Patientlist(u["vgroup_key"], u['patient_id_value'], u['patient_name'], u['patient_sex'],u['patient_address'] ,u['patient_birth_dttm'] ,u['patient_guardian'] , u['patient_phone']);
      PatientLists.add(patientlist);
    }

    print(PatientLists.length);

    return PatientLists;



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,

        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text("patient info"),
              floating: true,
              pinned: false,
              snap: true,
              expandedHeight: 200.0,
              flexibleSpace: MyappBar(),

            ),
            SliverFillRemaining(
              child: FutureBuilder(
                  future:_getPatientList(grouplist),
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.data ==null){
                      return Container(
                        child: Center(
                          child: Text("loading"),
                        ),
                      );

                    }
                    else{
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){

                          return ListTile(

                            title: Text(snapshot.data[index].patient_id_value),
                          );


                        });


                  }}),

            )
          ],



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
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      group = Group(patient_group['records'][index]['vgroup_key'],patient_group['records'][index]['vgroup_name']);
      print(group.vgroup_name);
      print(group.vgroup_key);

      items.add(new DropdownMenuItem(value: group.vgroup_name, child: new Text(group.vgroup_name)));
      grouplist.add(group);

    }
    return items;
  }

  void changedDropDownItem(String selectedGroup) {
    print("Selected city $selectedGroup, we are going to refresh the UI");
    setState(() {
      _currentGroup = selectedGroup;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
                )
              ],
            ),

          ]),



    );
  }
}






class Patientlist{
  final String vgroup_key;
  final String patient_id_value;
  final String patient_name;
  final String patient_sex;
  final String patient_birth_dttm;
  final String patient_phone;
  final String patient_address;
  final String patient_guardian;


  Patientlist(this.vgroup_key,this.patient_id_value,this.patient_name,this.patient_sex,this.patient_address,
      this.patient_birth_dttm,this.patient_guardian,this.patient_phone);



}

class Group{
  final int vgroup_key;
  final String vgroup_name;

  Group(this.vgroup_key,this.vgroup_name);

}



///    "vgroup_key" : "30614",
///    "patient_id_value" : "P123",
///    "patient_name" : "PATIENT^NAME",
///    "patient_sex" : "M",
///    "patient_birth_dttm" : "2015-07-22T03:35:14",
///    "patient_phone" : "010-1234-5678",
///    "patient_address" : "somewhere",
///    "patient_guardian" : "God" 