import 'dart:convert';
import 'dart:ffi';
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
    Future<Map<String, dynamic>> _future = Future.delayed(
        const Duration(seconds: 1), () => client.command("persons", {}));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Person List'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: _future,
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

                Widget trailingWidget;

                if (photoId != null && photoId.isNotEmpty) {
                  trailingWidget = FutureBuilder<Data>(
                    future: client.file(photoId),
                    builder:
                        (BuildContext context, AsyncSnapshot<Data> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else if (snapshot.hasData) {
                        final Uint8List imageBytes = snapshot.data!.data;
                        print(snapshot.data!.data);
                        print(snapshot.data!.contentType);
                        return Image.memory(imageBytes);
                      } else {
                        return const Text("No Image available");
                      }
                    },
                  );
                } else {
                  trailingWidget = const Text("No Image Available");
                }
                return Card(
                  child: Center(
                    child: ListTile(
                      leading: SizedBox(width: 80, child: trailingWidget),
                      title: Text('$firstName $lastName'),
                      subtitle: Text(
                          'DOB: $dob\nGender: $gender\n PhotoId: $photoId'),
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
