import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:so/so.dart';
import 'package:sologin/NavDrawer.dart';

class Home extends StatefulWidget {
  Client client;
  Home({super.key, required this.client});

  @override
  State<Home> createState() => _HomeState(client: client);
}

class _HomeState extends State<Home> {
  Client client;
  _HomeState({required this.client});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(client: client),
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: const Center(
        child: Text('SO login'),
      ),
    );
  }
}
