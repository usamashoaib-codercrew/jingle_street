import 'package:flutter/material.dart';
import 'package:jingle_street/config/functions/navigator_functions.dart';
import 'package:jingle_street/providers/cart_counter.dart';
import 'package:jingle_street/resources/res/app_theme.dart';
import 'package:jingle_street/resources/widgets/others/app_text.dart';
import 'package:jingle_street/resources/widgets/others/sized_boxes.dart';
import 'package:jingle_street/view/buy_screen/add_to_card_screen.dart';
import 'package:jingle_street/view/menu_screen/detail_edit_screen.dart';
import 'package:jingle_street/view/vendor_screen/add_items_screen.dart';
import 'package:provider/provider.dart';
import 'package:req_fun/req_fun.dart';

class BurgerBuilder extends StatefulWidget {
  final itemData;
  final uType;
  final vType;

  const BurgerBuilder({super.key, this.itemData, this.uType, this.vType});

  @override
  State<BurgerBuilder> createState() => _BurgerBuilderState();
}

class _BurgerBuilderState extends State<BurgerBuilder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 140,
      // color: Colors.blueAccent,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: widget.itemData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.12, crossAxisCount: 1),
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: InkWell(
              onTap: widget.uType == 1
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductEditScreen(
                                catagory: "${widget.itemData[i]["name"]}"
                                    .toCapitalize(),
                                name: "${widget.itemData[i]["name"]}"
                                    .toCapitalize(),
                                price: "${widget.itemData[i]["price"]}",
                                ingredients:
                                    "${widget.itemData[i]["description"]}",
                                img: widget.itemData[i]["images"],
                                size: size,
                                itemId: widget.itemData[i]["id"],
                                v_type: widget.vType,
                            ),
                          ));
                    }
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddToCardScreen(
                              catagoryName: widget.itemData[i]['name'],
                              catagoryDiscrption: widget.itemData[i]
                                  ['description'],
                              catagoryPrice: widget.itemData[i]['price'],
                              catagoryImages: widget.itemData[i]['images'],
                              length: widget.itemData[i]['images'].length,
                              itemId: widget.itemData[i]["id"],
                            ),
                          ));
                    },
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, bottom: 7, top: 7),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                widget.itemData[i]["images"].isEmpty
                                    ? Container(
                                        height: 55,
                                        width: 50,
                                        child: Image(
                                            image: AssetImage(
                                                "assets/images/beef burger.png"),
                                            fit: BoxFit.cover),
                                      )
                                    : Container(
                                        height: 55,
                                        width: 50,
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/images/loader.gif",
                                          image: "${widget.itemData[i]["images"][0]["url"]}",
                                          fit: BoxFit.cover,
                                          placeholderErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: Image.asset(
                                                "assets/images/loader.gif",
                                                width: 100,
                                                height: 100,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                              ]),
                          SizeBoxHeight8(),
                          AppText(
                            "${widget.itemData[i]["name"]}".toCapitalize(),
                            size: 12,
                            color: AppTheme.error,
                            bold: FontWeight.bold,
                            ellipsis: true,
                          ),
                          SizeBoxHeight3(),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.star,
                                      color: AppTheme.ratingGreyColor,
                                      size: 14)),
                              InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.star,
                                      color: AppTheme.ratingGreyColor,
                                      size: 14)),
                              InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.star,
                                      color: AppTheme.ratingGreyColor,
                                      size: 14)),
                              InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.star,
                                      color: AppTheme.ratingGreyColor,
                                      size: 14)),
                              InkWell(
                                  onTap: () {},
                                  child: Icon(Icons.star,
                                      color: AppTheme.ratingGreyColor,
                                      size: 14)),
                            ],
                          ),
                          SizeBoxHeight5(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppText(
                                "\$${widget.itemData[i]["price"]}",
                                size: 11,
                                color: AppTheme.ratingYellowColor,
                                bold: FontWeight.bold,
                              ),
                            ],
                          )
                        ]),
                  )),
            ),
          );
        },
      ),
    );
  }
}
