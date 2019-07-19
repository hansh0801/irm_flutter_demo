import 'package:flutter/material.dart';
import 'irm_auth.dart';
import 'login_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'patients_info.dart';
import 'get_patient_data.dart';

class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  Material myItems(
      IconData icon, String heading, int color, String navigateto) {
    return Material(
        color: Colors.white,
        elevation: 14.0,
        shadowColor: Color(0x802196F3),
        borderRadius: BorderRadius.circular(24.0),
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                navigateto,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            heading,
                            style: TextStyle(
                              color: new Color(color),
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: new Color(color),
                        borderRadius: BorderRadius.circular(24.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    //home page layout
    {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text("IRM Test APP"),
            actions: <Widget>[
              new FlatButton(
                  child: new Text(
                    "logout",
                    style: new TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    logout();
                    Navigator.pop(context, true);
                  })
            ],
          ),
          drawer: new Drawer(
            child: ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: new Text(userinfo.username),
                  accountEmail: new Text(userinfo.client_id),
                  currentAccountPicture: new CircleAvatar(
                    backgroundImage: new NetworkImage(
                        "http://extmovie.maxmovie.com/xe/files/attach/images/174/863/001/009/fbe5e526bf8e5f38c75ab4aa68bbecea.jpg"),
                  ),
                )
              ],
            ),
          ),
          body: new Container(
              child: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              myItems(Icons.people, "patients", 0xffed622b, 'patients_info'),
              myItems(Icons.person_add, "new patient", 0xfffad610, 'new_patient'),
              myItems(Icons.format_list_bulleted, "make form", 0xff216bd6, 'make_form'),
              myItems(Icons.timeline, "medical record", 0xff702670, 'medical_record'),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(1, 150.0),
              StaggeredTile.extent(2, 250.0),
            ],
          )),
        ),
      );
    }
  }
}
