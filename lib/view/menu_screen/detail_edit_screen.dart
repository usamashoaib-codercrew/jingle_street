import 'dart:io';
import 'package:dialogs/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/functions/provider.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/dialogs/delete_dialogue.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/menu_screen/video_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:req_fun/req_fun.dart';
import 'package:video_player/video_player.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ProductEditScreen extends StatefulWidget {
  final catagory;
  final name;
  final price;
  final ingredients;
  final img;
  final itemId;
  final v_type;
  final size;
  final finalData;
  const ProductEditScreen(
      {super.key,
      this.catagory,
      this.name,
      this.price,
      this.ingredients,
      this.img,
      this.itemId,
      this.v_type,
      this.size,
      this.finalData});

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  final _pageIndexNotifier = ValueNotifier<int>(0);
  List<dynamic> _mediaList = [];
  bool loading = false;
  late AppDio dio;
  bool isVideoPlaying = false;

  @override
  void initState() {
    dio = AppDio(context);
    itemNameController.text = widget.name ?? '';
    ingredientsController.text = widget.ingredients ?? '';
    priceController.text = widget.price ?? '';

    super.initState();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    ingredientsController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: AppBar(
        title: AppText(
          "${widget.catagory}",
          bold: FontWeight.bold,
          color: AppTheme.appColor,
          size: 24,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              radius: 17,
              backgroundColor: AppTheme.appColor,
              child: Center(
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Show api images and videos in listview.builder
            Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.img.length + _mediaList.length,
                    itemBuilder: (context, index) {
                      if (index < widget.img.length) {
                        if (widget.img[index]['type'] == 0) {
                          return Image.network(
                            widget.img[index]['url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ErrorWidget(
                                'Failed to load image. Please reload the page.',
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppTheme.appColor,
                                ),
                              );
                            },
                          );
                        } else if (widget.img[index]['type'] == 1) {
                          print(
                              "getting_thumbnails_of_videos ${widget.img[index]['thumbnail']}");
                          // apiChewieController = ChewieController(
                          //   allowFullScreen: false,
                          //   videoPlayerController:
                          //       VideoPlayerController.network(
                          //     widget.img[index]['url'],
                          //   ),
                          //   autoPlay: false,
                          //   looping: false,
                          //   autoInitialize: true,
                          //   placeholder: Center(
                          //     child: CircularProgressIndicator(
                          //       color: AppTheme.appColor,
                          //     ),
                          //   ),
                          //   errorBuilder: (context, errorMessage) {
                          //     return Center(
                          //       child: Text(
                          //         'Failed to load video. Please try again.',
                          //         style: TextStyle(color: Colors.white),
                          //       ),
                          //     );
                          //   },
                          // );
                          // return AspectRatio(
                          //   aspectRatio: 16 / 9,
                          //   child: Chewie(
                          //     controller: apiChewieController,
                          //   ),
                          // );
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.network(
                                widget.img[index]['thumbnail'],
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                                errorBuilder: (context, error, stackTrace) {
                                  return ErrorWidget(
                                    'Failed to load video. Please reload the page.',
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppTheme.appColor,
                                    ),
                                  );
                                },
                              ),
                              Container(
                                width: 80,
                                height: 80,
                                child: IconButton(
                                  onPressed: () {
                                    push(VideoPlayScreen(
                                        videoUrl: widget.img[index]['url']));
                                  },
                                  icon: Icon(
                                    Icons.play_circle_outline_outlined,
                                    size: 40,
                                    color: AppTheme.appColor,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (_mediaList.isNotEmpty) {
                        final num mediaIndex = index - widget.img.length;
                        if (mediaIndex >= 0 && mediaIndex < _mediaList.length) {
                          return _buildMediaPreview(
                              _mediaList[mediaIndex.toInt()]);
                        }
                      }
                      return Container();
                    },
                    onPageChanged: (index) {
                      _pageIndexNotifier.value = index;
                    },
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: CirclePageIndicator(
                        itemCount: widget.img.length + _mediaList.length,
                        currentPageNotifier: _pageIndexNotifier,
                        dotColor: Colors.grey.withOpacity(0.5),
                        selectedDotColor: AppTheme.appColor,
                        size: 8.0,
                        onPageSelected: (int index) {
                          _pageIndexNotifier.value = index;
                        },
                      ),
                    ),
                  ),
                  //delete button
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0, left: 15),
                      child: InkWell(
                          onTap: () {
                            showAlertDeleteDialog(context, () async {
                              Navigator.pop(context);
                              if (widget.img.length <= 1) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'This Media file cannot be deleted! Please add atleast one image/video.'),
                                ));
                              } else {
                                await deleteGalleryItems();
                                Provider.of<BoolProvider>(context,
                                        listen: false)
                                    .myBoolean = true;
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppTheme.appColor,
                                borderRadius: BorderRadius.circular(5)),
                            height: 36,
                            width: 38,
                            child: Center(
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          )),
                    ),
                  ),
                  //camera button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0, right: 15),
                      child: Container(
                        height: 37,
                        width: 38,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppTheme.appColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 150,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          _pickImage();
                                          pop();
                                        },
                                        child: AppText(
                                          "Pick Images",
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          _pickVideo();
                                          pop();
                                        },
                                        child: AppText(
                                          "Pick Video",
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Center(
                            child: Container(
                              height: 29,
                              width: 31,
                              child: Image(
                                image: AssetImage("assets/images/camera.png"),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.whiteColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      //Below is the Text fields portion
                      AppText(
                        "Name",
                        size: 15,
                        bold: FontWeight.w400,
                        color: AppTheme.appColor,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      AppField(
                        textEditingController: itemNameController,
                        borderRadius: BorderRadius.circular(10),
                        borderSideColor: AppTheme.appColor,
                        validator: Validator.required('Required'),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      AppText(
                        "Ingredients",
                        size: 15,
                        bold: FontWeight.w400,
                        color: AppTheme.appColor,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      AppField(
                        textEditingController: ingredientsController,
                        borderSideColor: AppTheme.appColor,
                        maxLines: 3,
                        validator: Validator.required('Required'),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      AppText(
                        "Price",
                        size: 15,
                        bold: FontWeight.w400,
                        color: AppTheme.appColor,
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: 120,
                        child: AppField(
                          textEditingController: priceController,
                          borderSideColor: AppTheme.appColor,
                          borderRadius: BorderRadius.circular(10),
                          validator: Validator.required('Required'),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: AppButton(
                          text: "Save",
                          textColor: AppTheme.whiteColor,
                          textSize: 18,
                          fontweight: FontWeight.w400,
                          width: 150,
                          height: 48,
                          btnColor: AppTheme.appColor,
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_mediaList.isNotEmpty) {
                              await addGalleryItems(_mediaList);
                              await updateGalleryItems();
                              Provider.of<BoolProvider>(context, listen: false)
                                  .myBoolean = true;
                            } else {
                              await updateGalleryItems();
                              Provider.of<BoolProvider>(context, listen: false)
                                  .myBoolean = true;
                            }
                          },
                        ),
                      ),
                      SizeBoxHeight32()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final media = await _picker.pickMultiImage();

    if (media != null) {
      setState(() {
        _mediaList.addAll(media);
      });
    }
  }

  // Future<void> _pickVideo() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final video = await _picker.pickVideo(source: ImageSource.gallery);
  //   if (video != null) {
  //     final videoFile = File(video.path);
  //     final videoPlayerController = VideoPlayerController.file(videoFile);
  //     await videoPlayerController.initialize();
  //     final videoDuration = videoPlayerController.value.duration;
  //     final videoSize = videoFile.lengthSync();
  //     if (videoDuration.inSeconds <= 30 && videoSize <= 10 * 1024 * 1024) {
  //       setState(() {
  //         _mediaList.add(video);
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Media Size less than 10 Mbs/30 sec'),
  //       ));
  //     }
  //     await videoPlayerController.dispose();
  //   }
  // }

  Future<void> _pickVideo() async {
    final ImagePicker _picker = ImagePicker();
    final video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final videoFile = File(video.path);

      // Thumbnail generation code
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: video.path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 100,
        // timeMs: 10000,
      );

      final thumbnailFile = File(thumbnailPath!);
      final videoDuration =
      await VideoPlayerController.file(videoFile).initialize().then((_) {
        return VideoPlayerController.file(videoFile).value.duration;
      });
      final videoSize = videoFile.lengthSync();

      if (videoDuration.inSeconds <= 30 && videoSize <= 10 * 1024 * 1024) {
        setState(() {
          _mediaList.add({
            'thumbnail': thumbnailFile,
            'videoPath': video.path, // Add video path to the media list
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Media Size less than 10 Mbs/30 sec'),
          ),
        );
      }
    }
  }
  // Widget _buildMediaPreview(dynamic media) {
  //   final String path = media.path;
  //   final bool isImage = ['.jpg', '.jpeg', '.png'].any(
  //     (extension) => path.toLowerCase().endsWith(extension),
  //   );
  //
  //   if (isImage) {
  //     return Image.file(
  //       File(media.path),
  //       fit: BoxFit.cover,
  //     );
  //   } else {
  //     assetVideoController = VideoPlayerController.file(File(media.path));
  //     assetChewieController = ChewieController(
  //       allowFullScreen: false,
  //       videoPlayerController: assetVideoController,
  //       autoPlay: false,
  //       looping: false,
  //       autoInitialize: true,
  //       placeholder: Center(
  //         child: CircularProgressIndicator(color: AppTheme.appColor),
  //       ),
  //       errorBuilder: (context, errorMessage) {
  //         return Center(
  //           child: Text(
  //             'Failed to load video. Please try again.',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         );
  //       },
  //     );
  //     return AspectRatio(
  //       aspectRatio: 16 / 9,
  //       child: Chewie(
  //         controller: assetChewieController,
  //       ),
  //     );
  //   }
  // }
  Widget _buildMediaPreview(dynamic media) {
    if (media is XFile) {
      // Display the image
      return Image.file(
        File(media.path),
        fit: BoxFit.cover,
      );
    } else {
      final String thumbnailPath = media['thumbnail'].path;
      final String videoPath = media['videoPath'];

      if (thumbnailPath.isNotEmpty) {
        // Display the video thumbnail with a play button
        return Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(thumbnailPath),
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  child: IconButton(
                    onPressed: () {
                      push(VideoPlayScreen(videoUrl: videoPath));
                    },
                    icon: Icon(
                      Icons.play_circle_outline_outlined,
                      size: 40,
                      color: AppTheme.appColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else {
        // Display a placeholder for the video
        return Container(
          width: 128,
          height: 128,
          color: Colors
              .grey, // Replace with your desired placeholder color or widget
        );
      }
    }
  }

  // Future<void> addGalleryItems(List<dynamic> galleryMediaList) async {
  //   ProgressDialog progressDialog = ProgressDialog(
  //     context: context,
  //     backgroundColor: Colors.white,
  //     textColor: AppTheme.appColor,
  //   );
  //   progressDialog.show();
  //   loading = true;
  //
  //   bool success = true; // Track the success of adding all items
  //
  //   try {
  //     for (dynamic media in galleryMediaList) {
  //       List<File> files = [];
  //
  //       if (media is XFile) {
  //         files.add(File(media.path));
  //       }
  //
  //       final bool hasImages = files.any(
  //         (file) => ['.jpg', '.jpeg', '.png'].any(
  //           (extension) => file.path.toLowerCase().endsWith(extension),
  //         ),
  //       );
  //
  //       final int type =
  //           hasImages ? 0 : 1; // Swapped the type values for images and videos
  //
  //       final formData = FormData.fromMap({
  //         'type': type,
  //         'item_id': widget.itemId,
  //         'file': files
  //             .map((file) => MultipartFile.fromFileSync(file.path))
  //             .toList(),
  //       });
  //
  //       final response = await dio.post(
  //         path: AppUrls.addItemImage,
  //         data: formData,
  //       );
  //
  //       if (response.statusCode != StatusCode.OK) {
  //         success = false; // Mark the success as false if any item fails to add
  //         break; // Exit the loop if an item fails
  //       }
  //     }
  //   } catch (e, stackTrace) {
  //     print('addItemImage API exception: $e\nStack trace: $stackTrace');
  //     success = false; // Mark the success as false if an exception occurs
  //   } finally {
  //     progressDialog.dismiss();
  //
  //     if (success) {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Items added successfully'),
  //       ));
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Something went wrong, please try again!'),
  //       ));
  //     }
  //   }
  // }
  Future<void> addGalleryItems(List<dynamic> galleryMediaList) async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;

    bool success = true; // Track the success of adding all items

    try {
      for (dynamic media in galleryMediaList) {
        List<File> files = [];
        int? type;

        if (media is XFile) {
          files.add(File(media.path));

          final bool hasImages = files.any(
                (file) => ['.jpg', '.jpeg', '.png'].any(
                  (extension) => file.path.toLowerCase().endsWith(extension),
            ),
          );
          type = hasImages ? 0 : 1; // 0 for images, 1 for videos
        } else if (media is Map<String, dynamic>) {
          files.add(File(media['videoPath']));

          type = 1; // 1 for videos
        }

        final formData = FormData.fromMap({
          'type': type!,
          'item_id': widget.itemId,
          'file': files
              // .where((file) => !file.path.endsWith('.jpg')) // Exclude thumbnails
              .map((file) => MultipartFile.fromFileSync(file.path))
              .toList(),
        });

        final response = await dio.post(
          path: AppUrls.addItemImage,
          data: formData,
        );

        if (response.statusCode != StatusCode.OK) {
          success = false; // Mark the success as false if any item fails to add
          break; // Exit the loop if an item fails
        }
      }
    } catch (e, stackTrace) {
      print('addItemImage API exception: $e\nStack trace: $stackTrace');
      success = false; // Mark the success as false if an exception occurs
    } finally {
      progressDialog.dismiss();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Items added successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ));
      }
    }
  }

//add gallery items code ends

  //below is the code of delete items
  Future<void> deleteGalleryItems() async {
    int max = widget.img.length;
    int activeIndex =
        _pageIndexNotifier.value; // Get the active index of PageView.builder

    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;

    try {
      final response = await dio.post(
        path: AppUrls.deleteGalleryItem,
        data: {'id': '${widget.img[activeIndex]["id"]}'},
      );

      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        if (response.extra["status"] == true) {
          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          //   content: Text('Item is Deleted Successfully'),
          // ));
          // setState(() {
          //   widget.img.removeAt(activeIndex);
          // });
        } else {
          if (response.data["message"] == 'done') {
            if (_pageIndexNotifier.value + 1 == max) {
              setState(() {
                widget.img.removeAt(activeIndex);
                activeIndex--;
                _pageIndexNotifier.value = activeIndex;
              });
            } else {
              setState(() {
                widget.img.removeAt(activeIndex);
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Item is Deleted Successfully'),
            ));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${response.data["message"]}")),
            );
          }
        }
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text('Item is Deleted Successfully'),
        // ));
        // if(response.data["message"] == 'done'){
        // }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ));
      }
    } catch (e, stackTrace) {
      print('deleteGalleryItems API exception: $e\nStack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while deleting the item.'),
      ));
    } finally {
      progressDialog.dismiss();
    }
  }
  //ends

//below is the code of update gallery items
  Future<void> updateGalleryItems() async {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;

    try {
      final response = await dio.post(
        path: AppUrls.updateItem,
        data: {
          'item_id': '${widget.itemId}',
          'price': '${priceController.text}',
          'description': '${ingredientsController.text}',
          'name': '${itemNameController.text}',
        },
      );

      if (loading) {
        loading = false;
        progressDialog.dismiss();
      }

      if (response.statusCode == StatusCode.OK) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Item Updated Successfully'),
        ));
        setState(() {
          // Perform any necessary state updates
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ));
      }
    } catch (e, stackTrace) {
      print('updateGalleryItems API exception: $e\nStack trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('An error occurred while updating the item.'),
      ));
    } finally {
      progressDialog.dismiss();
    }
  }

//ends
}
