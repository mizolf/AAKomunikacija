import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_core/firebase_core.dart';

class ImageInput extends StatefulWidget {
  final void Function(String imageUrl) onImagePicked;
  const ImageInput({required this.onImagePicked, super.key});

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  final imagePicker = ImagePicker();
  File? _selectedImage;

  Future<void> _takePicture() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    await _uploadImage();
  }

  Future<void> _addPicture() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    await _uploadImage();
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) {
      return;
    }

    try {
      final fileName = path.basename(_selectedImage!.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('simboli/$fileName');
      await storageRef.putFile(_selectedImage!);

      final downloadUrl = await storageRef.getDownloadURL();
      widget.onImagePicked(downloadUrl);
      print('File uploaded successfully: $downloadUrl');
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton.icon(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: _takePicture,
            label: const Text('Kamera')),
        TextButton.icon(
            icon: const Icon(Icons.camera),
            onPressed: _addPicture,
            label: const Text('Fotografije')),
      ],
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(
        width: 1,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      )),
      child: content,
    );
  }
}
