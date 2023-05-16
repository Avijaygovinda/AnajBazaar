import 'package:anaj_bazar/Constants/colors.dart';
import 'package:anaj_bazar/Constants/customAppbar.dart';
import 'package:anaj_bazar/Constants/customToast.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key, required this.pdfUrls});
  final String pdfUrls;

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  late PdfViewerController _pdfViewerController;
  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: tPrimaryColor,
          appBar: appBar(text: '', context: context),
          body: SfPdfViewerTheme(
            data: SfPdfViewerThemeData(
                backgroundColor: tPrimaryColor,
                scrollHeadStyle:
                    PdfScrollHeadStyle(backgroundColor: tPrimaryColor)),
            child: SfPdfViewer.network(
              widget.pdfUrls,
              key: _pdfViewerKey,
              controller: _pdfViewerController,
              onDocumentLoadFailed: (details) {
                toast(text: 'Failed To Load Invoice');
              },
            ),
          ),
        ),
      ),
    );
  }
}
