import 'package:flutter/material.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/view/menu_screen/menu_screen.dart';

class SearchHashTag extends StatefulWidget {
  final bool hashtagVisible;
  final Stream? stream;
  final type;
  final customerLat;
  final customerLong;
  final user_id;

  const SearchHashTag(
      {Key? key, required this.hashtagVisible, required this.stream, this.type,this.customerLat, this.customerLong,this.user_id})
      : super(key: key);

  @override
  State<SearchHashTag> createState() => _SearchHashTagState();
}

class _SearchHashTagState extends State<SearchHashTag> {
  double _searchField() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final minDimension =
    screenWidth < screenHeight ? screenWidth : screenHeight;
    if (minDimension > 100 && minDimension < 199) {
      return minDimension * 0.4;
    } else if (minDimension > 200 && minDimension < 299) {
      return minDimension * 0.5;
    } else if (minDimension > 300 && minDimension < 399) {
      return minDimension * 0.7;
    } else if (minDimension > 400 && minDimension < 439) {
      return minDimension * 0.7;
    } else if (minDimension > 440 && minDimension < 460) {
      return minDimension * 0.7;
    } else {
      return minDimension * 0.6;
    }
    // Adjust this value to adjust the size of the marker
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Align(
        alignment: Alignment.topLeft,
        child: Visibility(
          visible: widget.hashtagVisible,
          child: Container(
            decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                borderRadius: BorderRadiusDirectional.circular(25)),
            height: screenHeight * 0.5,
            width: _searchField(),
            child: StreamBuilder(
              stream: widget.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(1),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final vendor = snapshot.data![index];
                      return Column(
                        children: [
                          vendor["status"] == 1?  ListTile(
                            title: Text(vendor['businessname']),
                            subtitle: Text(vendor['hashtags']),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  VandorScreen(
                                businessHours: vendor["businesshours"] ?? "",
                                businessName: vendor["businessname"] ?? "",
                                address: vendor["address"] ?? "",
                                location: vendor["location"] ?? "",
                                photo: vendor["profilepic"] ?? "",
                                vType: vendor['type'],
                                id: vendor["id"],
                                lat: vendor["latitude"] +0.0,
                                long: vendor["longitude"] +0.0,
                                uType: vendor["user_id"]== widget.user_id?1:0,
                                busy: vendor["busy"],
                                requested: vendor["requested"],
                                reqType: widget.type,
                                bio: vendor["bio"] ?? "bio is Not mentioned",
                                customerLat: widget.customerLat,
                                customerlong: widget.customerLong,
                              ),));
                            },
                          ):Container(),

                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
