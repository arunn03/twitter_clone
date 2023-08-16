import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  final imagePicker = ImagePicker();
  List<File> images = [];
  final imageFiles = await imagePicker.pickMultiImage();
  for (final image in imageFiles) {
    images.add(File(image.path));
  }
  return images;
}
