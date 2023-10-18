import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:so/so.dart';

class PersonListWithPhotoList extends StatefulWidget {
  final Client client;

  const PersonListWithPhotoList({super.key, required this.client});

  @override
  State<PersonListWithPhotoList> createState() =>
      _PersonListState(client: client);
}

class _PersonListState extends State<PersonListWithPhotoList> {
  Client client;

  @override
  Widget build(BuildContext context) {
    Future<Map<String, dynamic>> future = Future.delayed(
        const Duration(seconds: 1), () => client.command("persons", {}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Person List'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: future,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
                String dob = dataItem['DOB'] ?? '';
                String gender = dataItem['GenderValue'] ?? '';
                String photoId = dataItem['PhotoId'] ?? '';

                Widget leadingWidget;

                if (photoId.isNotEmpty) {
                  leadingWidget = FutureBuilder<Data>(
                    future: client.file(photoId),
                    builder:
                        (BuildContext context, AsyncSnapshot<Data> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        final Uint8List imageBytes = snapshot.data!.data;
                        return CircleAvatar(
                          radius: 25,
                          backgroundImage: Image.memory(imageBytes).image,
                        );
                      } else {
                        return const Text("No Image available");
                      }
                    },
                  );
                } else {
                  leadingWidget = const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/sample-person.jpg"),
                  );
                }
                return SizedBox(
                  height: 100,
                  child: Card(
                    color: Colors.yellow[50],
                    elevation: 10.0,
                    margin: const EdgeInsets.all(2.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: leadingWidget,
                      title: Text(
                        '$firstName $lastName',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),),
                      subtitle: Text('Gender: $gender \n DOB: $dob'),
                    ),
                  ),
                );
              }).toList();

              // Return a ListView to display the Card widgets
              return ListView(
                children: cardList,
              );
            }
          }),
    );
  }

  _PersonListState({required this.client});
}