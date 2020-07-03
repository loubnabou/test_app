import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';

class PDFPreview extends StatelessWidget {
  final String path;
  PDFPreview({this.path});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: PDFViewerScaffold(
            path: path,
          ),
        ),
      ),
    );
  }
}
