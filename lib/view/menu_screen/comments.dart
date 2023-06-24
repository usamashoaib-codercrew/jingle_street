import 'package:flutter/material.dart';

class ReviewListWidget extends StatefulWidget {
  final reviewData;
  final uType;
  const ReviewListWidget({super.key, this.reviewData, this.uType});
  @override
  _ReviewListWidgetState createState() => _ReviewListWidgetState();
}

class _ReviewListWidgetState extends State<ReviewListWidget> {
  List<bool> isReplyVisibleList = [];

  @override
  void initState() {
    super.initState();
    isReplyVisibleList = List.filled(widget.reviewData.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: widget.reviewData.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.reviewData[index]["name"]}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Updated at: ${widget.reviewData[index]["updatedAt"].toString()}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    for (int i = 0; i < widget.reviewData[index]["rating"]; i++)
                      Icon(Icons.star, color: Colors.yellow),
                    for (int i = widget.reviewData[index]["rating"]; i < 5; i++)
                      Icon(Icons.star, color: Colors.grey),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "${widget.reviewData[index]["review"]}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 16),
                Visibility(
                  visible: isReplyVisibleList[index],
                  child: Container(
                    height: 100,
                    color: Colors.grey[300],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Reply",
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isReplyVisibleList[index] = false;
                              });
                            },
                            child: Text("Send"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                widget.uType == 1
                    ? Visibility(
                        visible: !isReplyVisibleList[index],
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isReplyVisibleList[index] = true;
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Reply",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
