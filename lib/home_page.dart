import 'package:flutter/material.dart';
import 'irm_auth.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "IRM demo",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Home_Page(),

    );
  }
}
class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("IRM Test APP"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("logout",
                style: new TextStyle(fontSize: 16, color: Colors.white),),
              onPressed: () {Navigator.pop(context);}

            )
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
          child: new Center(
            child: new Text('welcome to irm app', style: new TextStyle(fontSize: 25),),
          ),
        ),
      );
    }
  }
}

