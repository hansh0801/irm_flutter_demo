import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'japiRequest.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;
List<String> _Loaded_group = List<String>();

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

  Future<List<Patientlist>> _getPatientList() async{



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
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[

            ]),

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
    int index = 0;
    String group;
    for (; index < patient_group['records'].length; index++) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      group = patient_group['records'][index]['vgroup_name'];
      items.add(new DropdownMenuItem(value: group, child: new Text(group)));
      _Loaded_group.add(group);
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




///    "vgroup_key" : "30614",
///    "patient_id_value" : "P123",
///    "patient_name" : "PATIENT^NAME",
///    "patient_sex" : "M",
///    "patient_birth_dttm" : "2015-07-22T03:35:14",
///    "patient_phone" : "010-1234-5678",
///    "patient_address" : "somewhere",
///    "patient_guardian" : "God" 