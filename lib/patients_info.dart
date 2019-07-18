import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'japiRequest.dart';


var patient_group;
List<DropdownMenuItem<String>> _dropDownMenuItems;
String _currentGroup;
List<String> Loaded_group;
final TextEditingController _textEditingController= new TextEditingController();

void _handleSubmitted(String text) { _textEditingController.clear(); }


void getGroupinfo() async{
  patient_group = await getGroupSearchBelonged();

}


class Patients_Info extends StatefulWidget {
  @override
  _Patients_InfoState createState() => _Patients_InfoState();
}

class _Patients_InfoState extends State<Patients_Info> {

  void  initState()  {

    getGroupinfo();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentGroup = _dropDownMenuItems[0].value;
    super.initState();

  }
 // [index]['vgroup_name']

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int index = 0;
    String group;
    for (;index<patient_group['records'].length;index++) {
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      group = patient_group['records'][index]['vgroup_name'];
      items.add(new DropdownMenuItem(
          value: group,
          child: new Text(group)
      ));
      Loaded_group.add(group);

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
      resizeToAvoidBottomPadding: false,
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
              new Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted:_handleSubmitted ,
                      decoration: new InputDecoration.collapsed(hintText: "검색할 환자를 입력하세요",),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.all(8.0),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(icon: Icon(Icons.send), onPressed: ()=>_handleSubmitted(_textEditingController.text)),

                  )

                ],


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
