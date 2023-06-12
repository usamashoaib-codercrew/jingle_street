
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
    print("status_check $status");
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
      print("externalStorageDirectories ${externalStorageDirectories}");

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
      print("imagesgeting ${images}");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission is denied!'),
        ),
      );
    }
  }


  // List<File> images = [];

  // Future<void> loadGalleryImages() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final galleryDir = Directory('${directory.path}/gallery');
  //
  //   if (!galleryDir.existsSync()) {
  //     galleryDir.createSync(recursive: true);
  //   }
  //
  //   final galleryFiles = galleryDir.listSync();
  //
  //   setState(() {
  //     images = galleryFiles
  //         .where((file) => file is File && file.path.endsWith('.jpg'))
  //         .cast<File>()
  //         .toList();
  //   });
  // }

  //original code

  // Future<void> loadGalleryImages() async {
  //   // Request storage permission
  //   final PermissionStatus status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     // Permission granted, load images
  //     final Directory? directory1 = await getExternalStorageDirectory();
  //     // final List<Directory>? directory = await getExternalStorageDirectories();
  //     // print("directory_list ${directory}");
  //     // final String path = directory1!.path;
  //     final String path = "${directory1!.path.substring(0,20)}DCIM/Screenshots/";
  //
  //     print("storage_path ${path}");
  //
  //     setState(() {
  //       images = Directory(path)
  //           .listSync()
  //           .whereType<File>()
  //           .where((file) => file.path.endsWith('.png') || file.path.endsWith('.jpg'))
  //           .toList();
  //     });
  //     print("image list data ${images}");
  //   } else {
  //     // Permission denied
  //     print('Storage permission denied');
  //   }
  // }
  //original code

  // Future<void> loadGalleryImages() async {
  //   // Directory? directoryTemp = await getExternalStorageDirectory();
  //   // List<Directory>? directoryTemp = await getExternalStorageDirectories(type: StorageDirectory.);
  //   final galleryPath = '${directoryTemp}';
  //   // final directoryTemp2 = directoryTemp.path;
  //   print("geting paths ss ${galleryPath}");
  //   // Request storage permission
  //   final PermissionStatus status = await Permission.storage.request();
  //   // final PermissionStatus status2 = await Permission.mediaLibrary.request();
  //   print("geting_status $status");
  //   // print("geting_status2 $status2");
  //   if (status.isGranted) {
  //     // Permission granted, load images
  //     final List<Directory>? directory = await getExternalStorageDirectories(type: StorageDirectory.dcim);
  //     // File storageDir = Environment.getExternalStoragePublicDirectory( Environment.DIRECTORY_PICTURES );
  //     // final String path = directory!.path + '/Pictures';
  //     // final String path = "${directory!.path.substring(0,13)}";
  //     final String path = "${directory}";
  //     // final String path = '/Internal storage/Download/2.jpg';
  //     print("geting paths ss ${path}");
  //
  //     setState(() {
  //       images.addAll(Directory(path).listSync()
  //           .whereType<File>()
  //           .where((file) => file.path.endsWith('.jpg'))
  //           .toList());
  //           // .listSync()
  //           // .whereType<File>()
  //           // .where((file) => file.path.endsWith('.jpg'))
  //           // .toList();
  //     });
  //     print("iamges gaet ${images.length}");
  //   } else {
  //     // Permission denied
  //     print('Storage permission denied');
  //   }
  // }

  @override
  void initState() {
    // loadGalleryImages();
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
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert),)
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
    //   body: GridView.builder(
    //     scrollDirection: Axis.vertical,
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 3,
    //     ),
    //     itemCount: images.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Container(
    //         margin: EdgeInsets.all(3),
    //         child: Image(
    //           image: MemoryImage(images[index].readAsBytesSync()),
    //           fit: BoxFit.cover,
    //         ),
    //       );
    //     },
    //   ),
    );
  }
}
