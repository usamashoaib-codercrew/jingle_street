import 'dart:io';
import 'package:dialogs/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jingle_street/config/app_urls.dart';
import 'package:jingle_street/config/dio/app_dio.dart';
import 'package:jingle_street/config/keys/response_code.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/fields/app_fields.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/menu_screen/video_player_screen.dart';
import 'package:req_fun/req_fun.dart';
import 'package:video_player/video_player.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddItemsScreen extends StatefulWidget {
  final String catagory;

  const AddItemsScreen(
      this.catagory,
      );

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  final _pageIndexNotifier = ValueNotifier<int>(0);
  List<dynamic> _mediaList = [];
  int mediaListCount = 0;
  int remainingSelectedImages = 0;
  int mediaListCountVideo = 0;
  bool loading = false;
  late AppDio dio;
  // List<String> selectedImagesss = [];


  @override
  void initState() {
    dio = AppDio(context);

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
            //Below is page view builder portion
            Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _mediaList.length,
                    itemBuilder: (context, index) {
                      mediaListCount =_mediaList.where((item) => item is String).length;
                      mediaListCountVideo = _mediaList.where((item) => item is Map<String,String>).length;
                      print("videocountwhiletakingimage${mediaListCountVideo}");
                      remainingSelectedImages = mediaListCount;
                      // print("111111 ${_mediaList[index].endsWith("png")}");

                      return _buildMediaPreview(_mediaList[index]);
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
                        itemCount: _mediaList.length,
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
                  // delete button ///
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0, left: 15),
                      child: InkWell(
                          onTap: () {
                            int max = _mediaList.length;
                            if (_mediaList.length == 1) {dynamic media = _mediaList[_pageIndexNotifier.value];
                            if (media is Map<String, String> && media.containsKey('videoPath')) {
                              // Remove video

                              setState(() {
                                _mediaList.removeAt(_pageIndexNotifier.value);
                                if (mediaListCountVideo > 0) {
                                  mediaListCountVideo--;
                                };

                              });
                            } else {
                              // Remove image
                              setState(() {
                                _mediaList.removeAt(_pageIndexNotifier.value);
                                if (mediaListCount > 0) {
                                  mediaListCount--;
                                  remainingSelectedImages--;
                                  print("mediaListCountdidsubtract${mediaListCount}");
                                };
                              });
                            }

                            } else if (_pageIndexNotifier.value + 1 == max) {
                              dynamic media = _mediaList[_pageIndexNotifier.value];
                              if (media is Map<String, String> && media.containsKey('videoPath')) {
                                setState(() {
                                  _mediaList.removeAt(_pageIndexNotifier.value);
                                  if (mediaListCountVideo > 0) {
                                    mediaListCountVideo--;
                                  };
                                });
                              } else {
                                // Remove image

                                setState(() {
                                  _mediaList.removeAt(_pageIndexNotifier.value);
                                  if (mediaListCount > 0) {
                                    mediaListCount--;
                                    remainingSelectedImages--;
                                    print("mediaListCountdidsubtract${mediaListCount}");
                                  };
                                });

                              }
                              setState(() {_pageIndexNotifier.value--;});


                            } else {
                              dynamic media = _mediaList[_pageIndexNotifier.value];
                              if (media is Map<String, String> && media.containsKey('videoPath')) {
                                // Remove video
                                setState(() {
                                  _mediaList.removeAt(_pageIndexNotifier.value);
                                  if (mediaListCountVideo > 0) {
                                    mediaListCountVideo--;

                                  };
                                });

                              } else {
                                // Remove image

                                setState(() {
                                  _mediaList.removeAt(_pageIndexNotifier.value);
                                  if (mediaListCount > 0) {
                                    mediaListCount--;
                                    remainingSelectedImages--;
                                    print("mediaListCountdidsubtract${mediaListCount}");
                                  };
                                });

                              }
                              setState(() {});
                            }
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
                                          if (mediaListCount < 5) {
                                            print("asjdklajsdklje${mediaListCount}");
                                            pickImages(); // push(GalleryScreen());
                                            pop();
                                          } else {
                                            print("asjdklajsdklje${mediaListCount}");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Only 5 images you can upload!'),
                                            ));
                                            pop();
                                          }
                                        },
                                        child: AppText(
                                          "Pick Images",
                                          color: Colors.red,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (mediaListCountVideo < 1) {
                                            _pickVideo(); // push(GalleryScreen());
                                            pop();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Only 1 video can be uploaded!'),
                                            ));
                                            pop();
                                          }
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
                            if (itemNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please add name.'),
                              ));
                            } else if (ingredientsController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please add ingredients.'),
                              ));
                            } else if (priceController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please add price.'),
                              ));
                            } else if (_mediaList.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please add some media.'),
                              ));
                            } else {
                              await addGalleryItems(_mediaList);
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
            'thumbnail': thumbnailFile.path,
            'videoPath': video.path, // Add video path to the media list
          });

          // mediaListCountVideo = _mediaList.length;
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

  ///correct old
  Future<void> addGalleryItems(List<dynamic> galleryMediaList) async {
    int totalImageSize = 0; // Track the total image size
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.white,
      textColor: AppTheme.appColor,
    );
    progressDialog.show();
    loading = true;

    bool success = true; // Track the success of adding all items
    List<MultipartFile> imageFiles = [];
    List<MultipartFile> videoFiles = [];
    List<String> videoPaths = []; // Track the video paths

    try {
      for (dynamic media in galleryMediaList) {
        if (media is Map<String, dynamic>) {
          String videoPath =
          media['videoPath']; // Get the video path from the media object
          File file = File(videoPath);
          videoFiles.add(await MultipartFile.fromFile(file.path));
          videoPaths.add(videoPath); // Store the video path
        } else if (media is String) {
          File file = File(media);
          // if (file.path.endsWith('.jpg') || file.path.endsWith('.png') || file.path.endsWith('.jpeg')) {
          if (isImageFile(file)) {
            int fileSize = await file.length();
            totalImageSize += fileSize; // Add to the total image size

            print("Total selected images size ${totalImageSize}");

            if (totalImageSize > 10 * 1024 * 1024) {
              progressDialog.dismiss();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Total image size cannot exceed 10MB'),
              ));
              return; // Exit the function early if the total image size exceeds 10MB
            }

            imageFiles.add(await MultipartFile.fromFile(file.path));
          }
        }
      }

      if (imageFiles.isEmpty) {
        progressDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select at least one image'),
        ));
        return; // Exit the function early if no images are selected
      }

      if (imageFiles.length > 5) {
        progressDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Only 5 images can be selected.'),
        ));
        return; // Exit the function early if no images are selected
      }

      print("Total videos selected ${videoFiles.length}");

      if (videoFiles.length > 1) {
        progressDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Only one video can be added'),
        ));
        return; // Exit the function early if more than one video is selected
      }

      List<MultipartFile> filesNew = [];
      filesNew.addAll(imageFiles);
      filesNew.addAll(videoFiles);

      final formData = FormData.fromMap({
        'category': widget.catagory,
        'name': itemNameController.getText(),
        'description': ingredientsController.getText(),
        'price': priceController.getText(),
        // 'images': imageFiles,
        // 'videos': videoFiles,
        'files': filesNew,
      });

      print("files nes ${filesNew}");

      final response = await dio.post(
        path: AppUrls.addProductImages,
        data: formData,
      );

      if (response.statusCode != StatusCode.OK) {
        success = false; // Mark the success as false if the API call fails
      }
    } catch (e, stackTrace) {
      print('addItemImage API exception: $e\nStack trace: $stackTrace');
      success = false; // Mark the success as false if an exception occurs
    } finally {
      progressDialog.dismiss();

      if (success &&
          imageFiles.isNotEmpty &&
          totalImageSize <= 10 * 1024 * 1024 &&
          videoFiles.length <= 1 &&
          imageFiles.length <= 5) {
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

  Widget _buildMediaPreview(dynamic media) {
    if (media is String) {

      // Display the image
      return Image.file(
        File(media),
        fit: BoxFit.cover,
      );
    } else if (media is Map<String, String>) {
      final String thumbnailPath = media['thumbnail']!;
      final String videoPath = media['videoPath']!;
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
          color: Colors.grey,
          // Replace with your desired placeholder color or widget
        );
      }
    } else {
      // Handle other cases or display an error message
      return Text('Invalid media type');
    }
  }
  
   bool isImageFile(File file) {
    List<String> imageExtensions = ['.jpg', '.jpeg', '.png', '.heic', '.heif'];
    return imageExtensions
        .any((extension) => file.path.toLowerCase().endsWith(extension));
  }

  bool isVideoFile(File file) {
    List<String> videoExtensions = ['.mp4', '.mov', '.avi'];
    return videoExtensions
        .any((extension) => file.path.toLowerCase().endsWith(extension));
  }

  /////////////////////////////////////// Selected Images Picker /////////////////////////////////////////

  Future<void> pickImages() async {
    try {
      List<AssetEntity>? resultList = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          maxAssets: remainingSelectedImages == 0? 5: 5- remainingSelectedImages,
          requestType: RequestType.image,
        ),
      );

      print("asdasdasd${resultList}");
      for (var result in resultList!) {
        print("result: $result");
        File? asset = await result.file;
        if (asset != null) {
          final filePath = asset.path;

          _mediaList.add((filePath));
          // selectedImagesss.add(filePath);
          // print("asdasddddddd${selectedImagesss.length}");
        }
      }
      setState(() {});
    } catch (e) {
      // Handle error
    }
  }

///////////////////////////////////////////////// end //////////////////////////////////////////////

}
