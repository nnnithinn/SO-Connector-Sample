
import 'package:flutter/material.dart';
import 'package:so/so.dart';

class PersonList extends StatefulWidget {
  final Client client;
  const PersonList({super.key, required this.client});

  @override
  State<PersonList> createState() => _PersonListState(client: client);
}

class _PersonListState extends State<PersonList> {
  Client client;
  _PersonListState({required this.client});

  @override
  Widget build(BuildContext context) {

    Future<Map<String, dynamic>> _future = Future.delayed(
      const Duration(seconds: 2),
        () => client.command("list", {
          "className": "core.SystemUser",
          "attributes": [
            "Person.FirstName",
            "Person.MiddleName",
            "Person.LastName",
            "Person.DateOfBirth",
            "Person.GenderValue",
            "Person.MaritalStatusValue",
          ],
          "where": "FirstName LIKE 'z%'",
          "order": "FirstName"
        }
      )
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Person List'),),
      body: FutureBuilder<Map<String, dynamic>> (
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          var data = snapshot.data;
          if(data == null) {
            return const Placeholder();
          }
          print(data);
          data.forEach((key, value) {
              print("$key");
              print("$value");
            }
          );
          return ListTile(
            title: Text('Name: ${data['FirstName']} ${data['LastName']}'),
            subtitle: Text('Date of Birth: ${data['DateOfBirth']}'),
          );
        }
      ),
    );
  }

}