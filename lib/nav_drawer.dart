import 'package:flutter/material.dart';
import 'package:so/so.dart';
import 'package:sologin/login.dart';
import 'package:sologin/person_list.dart';
import 'package:sologin/person_report.dart';

class NavDrawer extends StatelessWidget {
  final Client client;

  const NavDrawer({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: _buildList(context),
    ));
  }

  List<Widget> _buildList(BuildContext context) {
    List<Widget> widgets = [];
    TextEditingController nameController = TextEditingController();
    const header = DrawerHeader(
      decoration: BoxDecoration(
          color: Colors.green,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/slidebar_image.jpg'),
          )),
      child: Text(
        "Stored Object",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );

    widgets.add(header);

    var personWithPhotoTile = ListTile(
      title: const Text("Person"),
      leading: const Icon(Icons.group),
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => PersonList(client: client))),
    );

    widgets.add(personWithPhotoTile);

    var report = ListTile(
        title: const Text("Report"),
        leading: const Icon(Icons.group),
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => Dialog(
                    child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          label: Text('Name starts with'),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PDFReport(
                                            nameController.value.text,
                                            client: client,
                                            reportClassName:
                                            'com.engravsystems.emqim.test.logic.TestPersonReport'
                                        )));
                          },
                          child: const Text('Proceed'))
                    ],
                  ),
                ))));

    widgets.add(report);

    var logoutTile = ListTile(
      title: const Text("Logout"),
      leading: const Icon(Icons.logout),
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage())),
        client.logout()
      },
    );
    widgets.add(logoutTile);
    return widgets;
  }

  void logout(BuildContext context) async {
    client.logout();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
