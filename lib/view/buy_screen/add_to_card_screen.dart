import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/button/app_button.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/custom_appbar.dart';
import 'package:jingle_street/view/menu_screen/video_player_screen.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:req_fun/req_fun.dart';

class AddToCardScreen extends StatefulWidget {
  final catagoryName;
  final catagoryDiscrption;
  final catagoryPrice;
  final catagoryImages;
  final length;

  const AddToCardScreen(
      {super.key,
      this.catagoryName,
      this.catagoryPrice,
      this.catagoryDiscrption,
      this.catagoryImages,
      this.length});

  @override
  State<AddToCardScreen> createState() => _AddToCardScreenState();
}

class _AddToCardScreenState extends State<AddToCardScreen> {
  final _pageIndexNotifier = ValueNotifier<int>(0);
  // const BeefScreen({super.key});
  bool _isFilled = false;
  bool _isFilled1 = false;
  bool _isFilled2 = false;
  bool _isFilled3 = false;

  void _toggleFill(int op) {
    final temp = [_isFilled, _isFilled1, _isFilled2, _isFilled3];

    temp.forEach((element) {
      switch (op) {
        case 0:
          {
            _isFilled = true;
            _isFilled1 = false;
            _isFilled2 = false;
            _isFilled3 = false;
            break;
          }
        case 1:
          {
            _isFilled = false;
            _isFilled1 = true;
            _isFilled2 = false;
            _isFilled3 = false;
            break;
          }
        case 2:
          {
            _isFilled = false;
            _isFilled1 = false;
            _isFilled2 = true;
            _isFilled3 = false;
            break;
          }
        case 3:
          {
            _isFilled = false;
            _isFilled1 = false;
            _isFilled2 = false;
            _isFilled3 = true;
            break;
          }
      }
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    // print("lckbckba ${widget.getData}");
    print("${widget.catagoryImages}bbannnsdfkslldfbsdkbfxkkfbkdxbskbjdfb");
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.appColor,
      appBar: SimpleAppBar(
          text: "${widget.catagoryName}".toCapitalize(),
          onTap: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 260,
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.catagoryImages.length,
                    itemBuilder: (context, index) {
                      if (index < widget.catagoryImages.length) {
                        if (widget.catagoryImages[index]['type'] == 0) {
                          return Image.network(
                            widget.catagoryImages[index]['url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return ErrorWidget(
                                'Failed to load image. Please reload the page.',
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
                          );
                        } else if (widget.catagoryImages[index]['type'] ==
                            1) {
                          // apiChewieController =
                          //     ChewieController(
                          //       videoPlayerController:
                          //       VideoPlayerController.network(
                          //         widget.catagoryImages[index]['url'],
                          //       ),
                          //       allowFullScreen: false,
                          //       autoPlay: false,
                          //       looping: false,
                          //       autoInitialize: true,
                          //       placeholder: Center(
                          //         child: CircularProgressIndicator(
                          //           color: AppTheme.appColor,
                          //         ),
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
                                widget.catagoryImages[index]['thumbnail'],
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
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayScreen(
                                                    videoUrl:
                                                        widget.catagoryImages[
                                                            index]['url'])));
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
                        itemCount: widget.catagoryImages.length,
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
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),

            // Container(
            //   height: 200,
            //   width: MediaQuery.of(context).size.width,
            //   child: CarouselSlider(
            //     items: [
            //       for (int i = 0; i < widget.length; i++)
            //         Image.network(
            //           "${widget.catagoryImages[i]['url']}",
            //           fit: BoxFit.fill,
            //         ),
            //     ],
            //     options: CarouselOptions(
            //       height: 200,
            //       viewportFraction: 1,
            //       initialPage: 0,
            //       enableInfiniteScroll: true,
            //       reverse: false,
            //       autoPlay: false,
            //       autoPlayInterval: Duration(seconds: 3),
            //       autoPlayAnimationDuration: Duration(milliseconds: 800),
            //       autoPlayCurve: Curves.fastOutSlowIn,
            //       enlargeCenterPage: true,
            //       scrollDirection: Axis.horizontal,
            //     ),
            //   ),
            // ),
            Container(
              height: size.height * 0.65,
              width: size.width,
              // color: WhiteColor,
              decoration: BoxDecoration(color: AppTheme.whiteColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 25),
                        child: InkWell(
                          onTap: () {},
                          child: Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppTheme.appColor),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.star,
                                        size: 16,
                                        color: AppTheme.yellowColor,
                                      )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AppText(
                                    "4.8",
                                    size: 17,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, right: 25),
                        child: AppText(
                          "\$${widget.catagoryPrice}",
                          color: AppTheme.yellowColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: AppText(
                      "${widget.catagoryName}".toCapitalize(),
                      size: 25,
                      bold: FontWeight.bold,
                      color: AppTheme.appColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // SizedBox(height: 7,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: AppText(
                      "${widget.catagoryDiscrption}",
                      size: 16,
                      color: AppTheme.appColor,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      children: [
                        AppText(
                          "Extras",
                          size: 25,
                          bold: FontWeight.bold,
                          color: AppTheme.appColor,
                        ),
                        Spacer(),
                        AppText(
                          "\$1 Each",
                          size: 20,
                          bold: FontWeight.bold,
                          color: AppTheme.appColor,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  CustomRow(
                      CircleAvatar: CircleAvatar(radius: 2),
                      SizedBox: SizedBox(width: 5),
                      text: "Extra Cheese",
                      color: AppTheme.appColor,
                      fontsize: 16.0,
                      icon: _isFilled ? Icons.circle : null,
                      iconcolor: AppTheme.appColor,
                      size: 16.0,
                      ontap: () {
                        // _toggleFill(0);
                        setState(() {
                          _isFilled = !_isFilled;
                        });
                      }),
                  SizedBox(
                    height: 4,
                  ),
                  CustomRow(
                      CircleAvatar: CircleAvatar(radius: 2),
                      SizedBox: SizedBox(width: 5),
                      text: "Extra Sauce",
                      color: AppTheme.appColor,
                      fontsize: 16.0,
                      icon: _isFilled1 ? Icons.circle : null,
                      iconcolor: AppTheme.appColor,
                      size: 16.0,
                      ontap: () {
                        setState(() {
                          _isFilled1 = !_isFilled1;
                        });
                      }),
                  SizedBox(
                    height: 4,
                  ),
                  CustomRow(
                      CircleAvatar: CircleAvatar(radius: 2),
                      SizedBox: SizedBox(width: 5),
                      text: "Extra Ketchup",
                      color: AppTheme.appColor,
                      fontsize: 16.0,
                      icon: _isFilled2 ? Icons.circle : null,
                      iconcolor: AppTheme.appColor,
                      size: 16.0,
                      ontap: () {
                        setState(() {
                          _isFilled2 = !_isFilled2;
                        });
                      }),
                  SizedBox(
                    height: 4,
                  ),
                  CustomRow(
                      CircleAvatar: CircleAvatar(radius: 2),
                      SizedBox: SizedBox(width: 5),
                      text: "Extra Salad",
                      color: AppTheme.appColor,
                      fontsize: 16.0,
                      icon: _isFilled3 ? Icons.circle : null,
                      iconcolor: AppTheme.appColor,
                      size: 16.0,
                      ontap: () {
                        setState(() {
                          _isFilled3 = !_isFilled3;
                        });
                      }),
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                      child: AppButton(
                    btnColor: AppTheme.appColor,
                    text: "Add to Cart",
                    textSize: 14,
                    width: size.width * 0.3,
                    textColor: AppTheme.whiteColor,
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //       builder: (context) => CartConfirmOrderScreen(),
                      //     ));
                    },
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
