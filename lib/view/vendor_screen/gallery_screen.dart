import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetImage> images = [];
  Future<bool> requestGalleryPermission() async {
    var status = await Permission.mediaLibrary.status;
    if (!status.isGranted) {
      status = await Permission.mediaLibrary.request();
    }
    return status.isGranted;
  }

  void loadImages() async {
    if (await requestGalleryPermission()) {
      final List<AssetImage> loadedImages = [];
      final List<Directory>? externalStorageDirectories =
          await getExternalStorageDirectories();

      for (var directory in externalStorageDirectories!) {
        final List<FileSystemEntity> files =
            directory.listSync(recursive: true);
        for (var file in files) {
          if (file is File && file.path.toLowerCase().endsWith('.jpg')) {
            loadedImages.add(AssetImage(file.path));
          }
        }
      }

      setState(() {
        images = loadedImages;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission is denied!'),
        ),
      );
    }
  }

  @override
  void initState() {
    loadImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.clear),
        backgroundColor: AppTheme.appColor,
        elevation: 0,
        title: Text('${images.length} selected'),
        actions: [
          Row(
            children: [
              Text('Select', style: TextStyle(fontSize: 20)),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              )
            ],
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image(
            image: images[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
