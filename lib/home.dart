import 'package:flutter/material.dart';
import 'package:so/so.dart';
import 'package:sologin/NavDrawer.dart';

class Home extends StatefulWidget {
  Client client;
  Home({super.key, required this.client});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(client: widget.client),
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: const Center(
        child: Text('SO login'),
      ),
    );
  }
}
