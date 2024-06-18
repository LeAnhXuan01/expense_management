import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProfilePictureDetailsScreen extends StatelessWidget {
  final String imagePath;

  const ProfilePictureDetailsScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = imagePath.startsWith('http') || imagePath.startsWith('https');

    return Scaffold(
      appBar: AppBar(
        title: Text('Ảnh đại diện'),
      ),
      body: Center(
        child: Container(
          child: PhotoView(
            imageProvider: isNetworkImage
                ? NetworkImage(imagePath)
                : FileImage(File(imagePath)) as ImageProvider,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) {
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
