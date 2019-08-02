import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'get_patient_data.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/services.dart';


String _currentGroup;
List<DropdownMenuItem<String>> _dropDownMenuItems;
List<Group> grouplist = [];

Future<String> evalJavascript(String code) async {
  final res = await _channel.invokeMethod('eval', {'code': code});
  return res;
}

final _channel = const MethodChannel('flutter_webview_plugin');

final TextEditingController _textEditingController =
    new TextEditingController();

Future getDcmList(int currentgroupkey) async {
  List vgroupKeyList = [currentgroupkey];
  var jsondata = await dcmStudySearch(vgroup_key_list: vgroupKeyList);
  print('jsondata $jsondata');
  var listData = jsondata['records'];

  print('listData $listData');
  return listData;
}

class Work_List extends StatefulWidget {
  @override
  _Work_ListState createState() => _Work_ListState();
}

class _Work_ListState extends State<Work_List> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('work list'),
      ),
      body: Work_Info(),
    );
  }
}

class Work_Info extends StatefulWidget {
  @override
  _Work_InfoState createState() => _Work_InfoState();
}

class _Work_InfoState extends State<Work_Info> {
  String searchText;

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

      items.add(new DropdownMenuItem(
          value: group.vgroup_name, child: new Text(group.vgroup_name)));
      grouplist.add(group);
    }

    return items;
  }

  void changedDropDownItem(String selectedGroup) {
    setState(() {
      _currentGroup = selectedGroup;
      currentgroupkey =
          grouplist.firstWhere(((user) => user.vgroup_name == _currentGroup));
      print(currentgroupkey.vgroup_key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0), border: Border.all()),
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
              /*        child:  DataTable(
                  rows: [],
                  columns: [
                    DataColumn(
                      label: Text('Column1'),
                    ),
                    DataColumn(
                      label: Text('Column2'),
                    ),
                    DataColumn(
                      label: Text('Column3'),
                    ),
                  ],
                ),*/
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ),
            Container(
              padding: new EdgeInsets.all(8.0),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
        Expanded(
          child: SizedBox(
            height: 200.0,
            child: FutureBuilder(
                future: getDcmList(currentgroupkey.vgroup_key),
                builder: (BuildContext context, AsyncSnapshot snapshot) {


                  print('snapshotdata ${snapshot.data}');
                  if (snapshot.data == null) {
                    return Container(
                        child: SpinKitPouringHourglass(
                      color: Colors.lightBlueAccent,
                      size: 50,
                    ));
                  } else {
                    ///여기부터 리스트
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {



                          Future javaFunc() async{
                            print('javaFunc');

                            await evalJavascript('document.cookie="Authority=manager"');
                            await evalJavascript('document.cookie="bestimage_dev_access_token=${token.access_token}"');

                            await evalJavascript('document.getElementById("cIdInput").value = ${snapshot.data[index]
                            ['patient_id']['id_value']};');
                            await evalJavascript('document.getElementById("cNameInput").value = ${snapshot.data[index]['patient_name']};');
                            await evalJavascript('document.getElementById("cDateInput").value = ${snapshot.data[index]['study_dttm']};');
                            await evalJavascript('document.getElementById("cModalInput").value = ${snapshot.data[index]['modality_list'][0]};');

                            await evalJavascript('location.reload();');

                            print('새로고침');
                          }




                          return Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 15.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.black26))),
                                  child: new CircleAvatar(
                                      backgroundColor: Colors.yellowAccent,
                                      child: new Text(snapshot.data[index]
                                              ['patient_sex'] ??
                                          "M")),
                                ),
                                title: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                        child: Text(
                                      snapshot.data[index]['patient_name'] ??
                                          null.toString(),
                                      style: TextStyle(fontSize: 10),
                                    )),
                                    Text(
                                      snapshot.data[index]['patient_id']
                                              ['id_value'] ??
                                          null,
                                      style: TextStyle(fontSize: 10),
                                    )
                                  ],
                                ),
                                subtitle: Text(''),
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: Colors.black26, size: 30.0),
                                onTap: () {
                                  var parameters = {
                                    'user_key': '',
                                    'dcm_study_key': snapshot.data[index]
                                        ['dcm_study_key'],
                                    'vgroup_key': currentgroupkey.vgroup_key,
                                    'patient_id': snapshot.data[index]
                                        ['patient_id']['id_value'],
                                  };

                                  /*var uri = Uri.https(
                                      "bestimage-dev.irm.kr",
                                      "/m/m_subhtml/m_dicomview.html",
                                      parameters);
                                  print('uri $uri');
                                  print('uri tostring ${uri.toString()}');*/

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WebviewScaffold(
                                                appBar: new AppBar(
                                                  title: Text("viewer"),
                                                  actions: <Widget>[
                                                    IconButton(
                                                      icon:
                                                          new Icon(Icons.info),
                                                      onPressed: () {javaFunc();},
                                                    )
                                                  ],
                                                ),
                                                url:
                                                    'https://bestimage-dev.irm.kr/m/m_subhtml/m_dicomview.html?user_key=&dcm_study_key=${snapshot.data[index]['dcm_study_key']}&vgroup_key=${currentgroupkey.vgroup_key}&patient_id=${snapshot.data[index]['patient_id']['id_value']}',
                                                withJavascript: true,
                                                //clearCache: true,
                                                //clearCookies: true,
                                                withZoom: true,
                                                withLocalStorage: true,
                                                enableAppScheme: true,
                                                primary: true,
                                                allowFileURLs: true,
                                              )));
                                },
                              ),
                            ),
                          );


                          /*         return DataTable(
                             rows: [
                               DataRow(
                                 cells: [
                                   DataCell(Text(snapshot.data[index]['patient_id']['id_value'])),
                                   DataCell(Text(snapshot.data[index]['patient_name'] ?? 'null')),
                                   DataCell(Text(snapshot.data[index]['patient_sex'] ?? 'null')),
                                 ],
                               ),
                             ],
                             columns: [
                               DataColumn(
                                 label: Text(snapshot.data.length.toString()),
                               ),
                               DataColumn(
                                 label: Text(''),
                               ),
                               DataColumn(
                                 label: Text(''),
                               )
                             ],
                           );
                           */
                        });
                  }
                }),
          ),
        )
      ]),
    );
  }
}

