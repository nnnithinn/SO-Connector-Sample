
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:so/so.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFExample extends StatefulWidget {
  final Client client;
  const PDFExample({super.key, required this.client});

  @override
  State<PDFExample> createState() => _PDFExampleState(client);
}

class _PDFExampleState extends State<PDFExample> {
  final Client client;
  _PDFExampleState(this.client);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Report Test"),
        ),
        body: FutureBuilder<(Uint8List?, String?, String?)>(
            future:
            client.report('com.engravsystems.emqim.test.logic.TestPersonReport', {
              "filter" : "lower(FirstName) LIKE 'a%'"
            }),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.hasError) {
                print(snapshot.error);
                return const Text("An error occured");
              } else if(snapshot.hasData) {
                if(snapshot.data!.$2!.contains("pdf")) {
                  Uint8List? pdfBytes = snapshot.data!.$1;
                  if(pdfBytes == null) {
                    return const Text('No data to display');
                  } else {
                    return SfPdfViewer.memory(pdfBytes);
                  }
                }
              }
              return const Placeholder();
        },
        )
    );
  }
} // For accessing the file system