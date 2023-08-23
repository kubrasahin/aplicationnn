import 'package:aplicationnn/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class NotificationDetail extends StatefulWidget {
  final String? notificationID;
  const NotificationDetail({Key? key, this.notificationID});

  @override
  State<NotificationDetail> createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail> {
  var notificationDetail;
  String? variantUnit, variantId, currency, description;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? groupValue = 0;
  bool? isNotificationDetail = false;
  int? quantity = 1, variantPrice, variantStock;
  var rating;

  @override
  void initState() {
    getNotificationDetail();
    super.initState();
  }

  getNotificationDetail() async {
    await ChatServices.getNotificationDetay(widget.notificationID)
        .then((value) {
      if (mounted) {
        setState(() {
          notificationDetail = value;
          print("DETAYYYYYYYYY");
          print(notificationDetail);
          isNotificationDetail = true;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isNotificationDetail = false;
          print("object");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: notificationDetail == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      notificationDetail['title'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 8),
                                      child: RatingBar.builder(
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 15.0,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        unratedColor: const Color.fromARGB(
                                            255, 243, 220, 12),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.grey,
                                          size: 12.0,
                                        ),
                                        onRatingUpdate: (value) {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 15, left: 8, right: 8),
                              child: Text(notificationDetail['description']),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
