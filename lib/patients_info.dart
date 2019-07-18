import 'package:flutter/material.dart';
import 'irm_auth.dart';


List _patient_group = ['11111111111111','21111111','3111111'];
List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;




class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info> {

  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    super.initState();

  }


  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String group in _patient_group) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(
          value: group,
          child: new Text(group)
      ));
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
    return Scaffold(
      appBar: new AppBar(title: Text("patient test"),),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: new Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
           // mainAxisAlignment: MainAxisAlignment.center,
            children:[
              new Container(
                padding: new EdgeInsets.all(10.0),
              ),
              new DropdownButton(
                value: _currentGroup,
                items: _dropDownMenuItems,
                onChanged: changedDropDownItem,

              ),
              Image.asset(
                "images/irm_logo.png",
                width: 300,
                height: 100,
                //fit: BoxFit.cover,
              ),
              Image.asset(
                "images/irm_logo.png",
                width: 300,
                height: 100,
                //fit: BoxFit.cover,
              ),
              Image.asset(
                "images/irm_logo.png",
                width: 300,
                height: 100,
                //fit: BoxFit.cover,
              ),
              Image.asset(
                "images/irm_logo.png",
                width: 300,
                height: 100,
                //fit: BoxFit.cover,
              ),

            ]

          ),

      ),

    );
  }
}
