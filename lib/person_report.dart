import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:so/so.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFReport extends StatefulWidget {
  final Client client;
  final String filterString;
  final String reportClassName;
  const PDFReport(this.filterString,
      {super.key, required this.client, required this.reportClassName});

  @override
  State<PDFReport> createState() =>
      _PDFReportState(
          filterString,
          client: client,
          reportClassName: reportClassName
      );
}

class _PDFReportState extends State<PDFReport> {
  final Client client;
  final String filterCondition;
  final String reportClassName;
  _PDFReportState(this.filterCondition, {required this.client, required this.reportClassName});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Report Test"),
        ),
        body: FutureBuilder<(Uint8List?, String?, String?)>(
            future:
            client.report('', {
              "filter" : filterCondition
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