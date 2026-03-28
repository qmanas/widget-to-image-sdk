import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:path/path.dart' as p;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:math' as math;
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;

class ModularWTIController extends GetxController {
  Map<String, WidgetsToImageController> widgetCaptureMap = {};
  Rx<ScrollController> scrollController = ScrollController().obs;
  
  pw.Document doc = pw.Document(compress: true);
  RxBool isProcessing = false.obs;
  RxString statusText = ''.obs;

  @override
  onInit() {
    super.onInit();
  }

  RxList<Uint8List> capturedImages = <Uint8List>[].obs;

  WidgetsToImageController getCaptureController(String id) {
    print('fetching controller for widget: $id');
    WidgetsToImageController controller = WidgetsToImageController();
    widgetCaptureMap[id] = controller;
    return controller;
  }

  Future<List<Uint8List>> captureAllWidgets({
    bool exportToPdf = false,
  }) async {
    statusText.value = 'Capturing Widgets...';
    List<Uint8List> capturedList = [];

    await Future.forEach<String>(widgetCaptureMap.keys, (String id) async {
      WidgetsToImageController controller = widgetCaptureMap[id]!;
      statusText.value = 'Capturing Widget: $id';
      
      isProcessing.value = true;
      
      Uint8List? bytes = await controller.capture().catchError((e) {
        statusText.value = 'Error: $e';
        isProcessing.value = false;
      });

      if (bytes != null) {
        capturedImages.add(bytes);
        capturedList.add(bytes);
      }
    });

    return capturedList;
  }

  generatePDF(List<Uint8List> images, {bool portrait = true}) async {
    statusText.value = 'Generating PDF Document...';
    doc = pw.Document(compress: true);

    for (var i = 0; i < images.length; i++) {
        doc.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pw.MemoryImage(images[i])),
              );
            },
        ));
    }

    await saveAndOpenPdf(doc);
  }

  Future<void> saveAndOpenPdf(pw.Document doc) async {
    statusText.value = 'Saving Document...';
    Uint8List pdfData = await doc.save();
    
    // Logic for saving to local storage or printing
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
    
    statusText.value = 'Success!';
    isProcessing.value = false;
  }
}
