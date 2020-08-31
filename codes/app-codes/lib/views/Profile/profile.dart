import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:missyou/views/Information.dart';
import 'package:missyou/views/Payment/paymentDetails.dart';
import 'package:missyou/views/Profile/EditProfile.dart';
import 'package:missyou/views/Profile/settings.dart';
import 'package:missyou/models/user_model.dart';
import 'package:missyou/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../Payment/subscriptions.dart';

final List adds = [
  {
    'icon': Icons.whatshot,
    'color': Colors.indigo,
    'title': "Match Faster",
    'subtitle': "Faster Match with Premium",
  },
  {
    'icon': Icons.favorite,
    'color': Colors.lightBlueAccent,
    'title': "More Likes",
    'subtitle': "More Likes With Premium",
  },
  {
    'icon': Icons.star_half,
    'color': Colors.amber,
    'title': "Şansını Yükelselt",
    'subtitle': "Premium İle Daha Hızlı Eşleş",
  },
  {
    'icon': Icons.location_on,
    'color': Colors.purple,
    'title': "Bütün Dünyaya Ulaş",
    'subtitle': "Premium İle Bütün Dünyaya Ulaş",
  },
];

class Profile extends StatefulWidget {
  final User currentUser;
  final bool isPuchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  Profile(this.currentUser, this.isPuchased, this.purchases, this.items);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Hero(
              tag: "herotag",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: secondryColor,
                  child: Material(
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () => showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return Info(widget.currentUser, widget.currentUser, null);
                              }),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                80,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: widget.currentUser.imageUrl[0],
                                useOldImageOnUrlChange: true,
                                placeholder: (context, url) => CupertinoActivityIndicator(
                                  radius: 15,
                                ),
                                errorWidget: (context, url, error) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.error,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    Text(
                                      "Yükleme İzni",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            color: primaryColor,
                            child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(
                                  Icons.camera,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _editProfileState.source(context, widget.currentUser, true);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text(
              widget.currentUser.name != null && widget.currentUser.age != null ? "Jhon Doe , 22" : "",
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 30),
            ),
            Text(
              widget.currentUser.editInfo['job_title'] != null
                  ? "Engineer  ${widget.currentUser.editInfo['company'] != null ? "at ${widget.currentUser.editInfo['company']}" : ""}"
                  : "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 20),
            ),
            Text(
              widget.currentUser.editInfo['university'] != null ? "Engineer" : "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 20),
            ),
            Container(
              //height: MediaQuery.of(context).size.height * .45,
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(70),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      primaryColor.withOpacity(.5),
                                      primaryColor.withOpacity(.8),
                                      primaryColor,
                                      primaryColor
                                    ],
                                  ),
                                ),
                                child: FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    splashColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      _editProfileState.source(context, widget.currentUser, false);
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Settings",
                                  style: TextStyle(color: secondryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(70),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      primaryColor.withOpacity(.5),
                                      primaryColor.withOpacity(.8),
                                      primaryColor,
                                      primaryColor
                                    ],
                                  ),
                                ),
                                height: 70,
                                width: 70,
                                child: FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    splashColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    onPressed: () {
                                      _editProfileState.source(context, widget.currentUser, false);
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Add Image",
                                  style: TextStyle(color: secondryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(70),
                                  gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.bottomLeft,
                                    colors: [
                                      primaryColor.withOpacity(.5),
                                      primaryColor.withOpacity(.8),
                                      primaryColor,
                                      primaryColor
                                    ],
                                  ),
                                ),
                                height: 70,
                                width: 70,
                                child: FloatingActionButton(
                                    heroTag: UniqueKey(),
                                    splashColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => EditProfile(widget.currentUser)));
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(color: secondryColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 120.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        height: 100,
                        width: MediaQuery.of(context).size.width * .85,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Swiper(
                            key: UniqueKey(),
                            autoplay: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (BuildContext context, int index2) {
                              return Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      adds[index2]["icon"],
                                      color: adds[index2]["color"],
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      adds[index2]["title"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text(
                                  adds[index2]["subtitle"],
                                  textAlign: TextAlign.center,
                                ),
                              ]);
                            },
                            itemCount: adds.length,
                            pagination: new SwiperPagination(
                                alignment: Alignment.bottomCenter,
                                builder: DotSwiperPaginationBuilder(
                                    activeSize: 10, color: secondryColor, activeColor: primaryColor)),
                            control: new SwiperControl(
                              size: 20,
                              color: primaryColor,
                              disableColor: secondryColor,
                            ),
                            loop: false,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(25),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          primaryColor.withOpacity(.5),
                          primaryColor.withOpacity(.8),
                          primaryColor,
                          primaryColor
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height * .065,
                    width: MediaQuery.of(context).size.width * .75,
                    child: Center(
                        child: Text(
                      widget.isPuchased && widget.purchases != null
                          ? "Ödeme Ayrıntılarını Kontrol Edin"
                          : "Subscription Plan",
                      style: TextStyle(fontSize: 15, color: textColor, fontWeight: FontWeight.bold),
                    ))),
                onTap: () async {
                  if (widget.isPuchased && widget.purchases != null) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => PaymentDetails(widget.purchases)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Subscription(widget.currentUser, null, widget.items)),
                    );
                  }
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = secondryColor.withOpacity(.4);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    var startPoint = Offset(0, -size.height / 2);
    var controlPoint1 = Offset(size.width / 4, size.height / 3);
    var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
    var endPoint = Offset(size.width, -size.height / 2);

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.cubicTo(
        controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, endPoint.dx, endPoint.dy);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
