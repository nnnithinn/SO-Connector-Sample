
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
  @override
  Widget build(BuildContext context) {

    Future<Map<String, dynamic>> _future = Future.delayed(
      const Duration(seconds: 2),
        () => client.command("list", {
          "className": "core.Person",
          "attributes": [
            "FirstName",
            "MiddleName",
            "LastName",
            "DateOfBirth",
            "GenderValue",
            "MaritalStatusValue",
          ],
          "where": "FirstName LIKE 'N%'",
          "order": "FirstName"
        }
      )
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Person List'),),
      body: FutureBuilder<Map<String, dynamic>> (
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            final data = snapshot.data as Map<String, dynamic>;
            // Extract the list from the map using the appropriate key
            final dataList = data['data'] as List<dynamic>;
            
            // Process the data here and create a list of Card widgets
            List<Widget> cardList = dataList.map((dataItem) {
              String firstName = dataItem['FirstName'] ?? '';
              String lastName = dataItem['LastName'] ?? '';
              String dob = dataItem['DateOfBirth'] ?? '';
              String gender = dataItem['GenderValue'] ?? '';

              return Card(
                child: ListTile(
                  title: Text('$firstName $lastName'),
                  subtitle: Text('DOB: $dob\nGender: $gender'),
                ),
              );
            }).toList();

            // Return a ListView to display the Card widgets
            return ListView(
              children: cardList,
            );
          }
        }
      ),
    );
  }

  _PersonListState({required this.client});

}