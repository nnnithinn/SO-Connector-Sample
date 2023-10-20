import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:so/so.dart';

class PersonList extends StatefulWidget {
  final Client client;

  const PersonList({super.key, required this.client});

  @override
  State<PersonList> createState() => _PersonListState(client: client);
}

class _PersonListState extends State<PersonList> {
  final Client client;

  _PersonListState({required this.client});

  @override
  Widget build(BuildContext context) {
    var attributes = {
      "className": "com.engravsystems.emqim.hr.Staff",
      "attributes": [
        "Person.FirstName as FirstName",
        "Person.LastName as LastName",
        "Person.DateOfBirth as DOB",
        "Person.GenderValue as Gender",
        "PhotoId"
      ],
      "order": "Person.FirstName, Person.LastName",
      "any": true
    };

    return Container(
      child: FutureBuilder<Map<String, dynamic>>(
        future: client.command("list", attributes),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else if (snapshot.hasData) {
            final data = snapshot.data as Map<String, dynamic>;
            final dataList = data['data'] as List<dynamic>;
            List<Widget> cardList = dataList.map((dataItem) {
              String firstName = dataItem['FirstName'] ?? '';
              String lastName = dataItem['LastName'] ?? '';
              String dob = dataItem['DOB'] ?? '';
              String gender = dataItem['Gender'] ?? '';
              String photoId = dataItem['PhotoId'] ?? '';
              Widget dummyImage = const CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/images/sample-person.jpg'));
              Widget leadingWidget = dummyImage;
              if (photoId != null && photoId.isNotEmpty && photoId != '0') {
                leadingWidget = FutureBuilder<(Uint8List?, String?, String?)>(
                    future: client.file(photoId),
                    builder: (BuildContext context,
                        AsyncSnapshot<(Uint8List?, String?, String?)>
                            photo_snap_shot) {
                      if (photo_snap_shot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (photo_snap_shot.hasError) {
                        return leadingWidget;
                      } else if (photo_snap_shot.hasData) {
                        Uint8List? imageBytes = photo_snap_shot.data!.$1;
                        if (imageBytes != null) {
                          String? s2 = photo_snap_shot.data?.$2;
                          // Check if the resource is an image by using the content type
                          if (s2!.startsWith("image/")) {
                            return CircleAvatar(
                                backgroundImage: Image.memory(imageBytes).image);
                          }
                        }
                      }
                      return const Placeholder();
                    });
              }
              return ListTile(
                leading: leadingWidget,
                title: Text('$firstName $lastName'),
                subtitle: Text('Gender : $gender \n DOB: $dob'),
              );
            }).toList();
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Person List'),
                ),
                body: Card(child: ListView(children: cardList)));
          }

          return const Text('No Data');
        },
      ),
    );
  }
}
