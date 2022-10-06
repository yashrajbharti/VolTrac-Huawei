import 'dart:io';
import 'dart:ui';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:voltrac/codingapp/kml/LookAt.dart';
import 'package:voltrac/codingapp/theme-storage.dart';
import 'package:voltrac/codingapp/kml/orbit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ssh2/ssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerticalCardPagerDemo extends StatefulWidget {
  @override
  _VerticalCardPagerDemoState createState() => _VerticalCardPagerDemoState();
}

int x = 0;
void jumpToPage(int page) {
  x = page;
}

var _duration = 3000;
bool loading = false;
String retrykml = "";
String retryname = "";
Future retryButton(String KML, String name, dynamic duration) async {
  retrykml = await KML;
  retryname = await name;
  _duration = await duration;
}

class _VerticalCardPagerDemoState extends State<VerticalCardPagerDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationiconcontroller;

  bool isOrbiting = false;
  double latvalue = 28.55665656297236;
  double longvalue = -17.885454520583153;

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    _rotationiconcontroller = AnimationController(
      duration: const Duration(seconds: 50),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _rotationiconcontroller.dispose();
    super.dispose();
  }

  playOrbit() async {
    await LGConnection()
        .buildOrbit(Orbit.buildOrbit(Orbit.generateOrbitTag(
            LookAt(longvalue, latvalue, "6341.7995674", "0", "0"))))
        .then((value) async {
      await LGConnection().startOrbit();
    });
    setState(() {
      isOrbiting = true;
    });
  }

  stopOrbit() async {
    await LGConnection().stopOrbit();
    setState(() {
      isOrbiting = false;
    });
  }

  void _showToast(String x, bool blackandwhite) {
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useTabletLayout = shortestSide > 600.0;
    // check for tablet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$x",
          style: TextStyle(
              fontSize: useTabletLayout ? 24.0 : 14,
              fontWeight: FontWeight.normal,
              fontFamily: "GoogleSans",
              color: Colors.white),
        ),
        duration: Duration(seconds: 3),
        backgroundColor: blackandwhite
            ? Color.fromARGB(255, 22, 22, 22)
            : Color.fromARGB(250, 43, 43, 43),
        width: useTabletLayout ? 500.0 : 280,
        padding: const EdgeInsets.fromLTRB(
          35,
          20,
          15,
          20,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        action: SnackBarAction(
          textColor: Color.fromARGB(255, 125, 164, 243),
          label: translate('Track.close'),
          onPressed: () {},
        ),
      ),
    );
  }

  showAlertDialog(String title, String msg, bool blackandwhite) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final double shortestSide = MediaQuery.of(context)
            .size
            .shortestSide; // get the shortest side of device
        final bool useTabletLayout = shortestSide > 600.0; // check for tablet
        return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3),
            child: AlertDialog(
              backgroundColor: blackandwhite
                  ? Color.fromARGB(255, 16, 16, 16)
                  : Color.fromARGB(255, 33, 33, 33),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Image.asset(
                        "assets/sad.png",
                        width: useTabletLayout ? 250 : 125,
                        height: useTabletLayout ? 250 : 125,
                      )),
                  Text(
                    '$title',
                    style: TextStyle(
                      fontSize: useTabletLayout ? 25 : 18,
                      color: Color.fromARGB(255, 204, 204, 204),
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: useTabletLayout ? 320 : 80,
                height: useTabletLayout ? 180 : 120,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('$msg',
                          style: TextStyle(
                            fontSize: useTabletLayout ? 18 : 12,
                            color: Color.fromARGB(
                              255,
                              204,
                              204,
                              204,
                            ),
                          ),
                          textAlign: TextAlign.center),
                      SizedBox(
                          width: useTabletLayout ? 300 : 150,
                          child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  shadowColor: Colors.black,
                                  primary: Color.fromARGB(255, 220, 220, 220),
                                  padding:
                                      EdgeInsets.all(useTabletLayout ? 15 : 5),
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Wrap(
                                  children: <Widget>[
                                    Text(translate('dismiss'),
                                        style: TextStyle(
                                            fontSize: useTabletLayout ? 20 : 12,
                                            color: Colors.black)),
                                  ],
                                ),
                              ))),
                    ]),
              ),
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useTabletLayout = shortestSide > 600.0;
    // check for tablet
    Widget landscapewidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.land'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate('info.land.description'),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate('info.land.date'),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate('info.land.legend'),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon13.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(translate('info.land.landscape'),
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/info.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(translate('info.land.infoicon'),
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://earthobservatory.nasa.gov/images/149231/a-changed-landscape-on-la-palma?src=eoa-iotd');
                    },
                    child: Text(
                      'NASA Earth Observatory',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://apps.sentinel-hub.com/sentinel-playground/?source=S2&lat=28.641033254756742&lng=-17.935867309570312&zoom=12&preset=1-NATURAL-COLOR&layers=B01,B02,B03&maxcc=36&gain=1.0&gamma=1.0&time=2021-06-01%7C2021-12-29&atmFilter=&showDates=false');
                    },
                    child: Text(
                      'Sentinel Playground',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://emergency.copernicus.eu/mapping/list-of-components/EMSR546/ALL/EMSR546_AOI01');
                    },
                    child: Text(
                      'COPERNICUS',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget histwidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.hist'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.hist.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.hist.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.hist.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon8.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text("1480    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon7.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "1585   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon2.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "1646   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon1.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.hist.and"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon6.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text("1712    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon4.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "1949   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon3.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "1949   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon5.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "2021   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/molten.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.hist.lava"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://emergency.copernicus.eu/mapping/list-of-components/EMSR546/ALL/EMSR546_AOI01');
                    },
                    child: Text(
                      'COPERNICUS',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://www.researchgate.net/publication/284812060_The_magma_plumbing_system_for_the_1971_Teneguia_eruption_on_La_Palma_Canary_Islands/figures?lo=1');
                    },
                    child: Text(
                      'ResearchGate',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://volcano.si.edu/volcano.cfm?vn=383010');
                    },
                    child: Text(
                      'Global Volcanism Program',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget lavawidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.lava'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.lava.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.lava.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.lava.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon6.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text("24 Sep    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon2.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "8 Oct   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon1.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "21 Oct   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon9.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "4 Nov   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon10.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text("14 Nov    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon7.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "21 Nov   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon11.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "1 Dec   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon12.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "18 Dec   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/vent.png'),
                            iconSize: 36,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.lava.vents"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://emergency.copernicus.eu/mapping/list-of-components/EMSR546/ALL/EMSR546_AOI01');
                    },
                    child: Text(
                      'COPERNICUS',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://en.wikipedia.org/wiki/2021_Cumbre_Vieja_volcanic_eruption');
                    },
                    child: Text(
                      'Wikipedia | Cumbre Vieja',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  )
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget prewidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.prehistoric'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.prehistoric.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.prehistoric.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.prehistoric.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon9.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text("6 ± 2 Ka    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon7.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "3.2 ± 0.1 Ka   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon11.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "3.2 ± 0.1 Ka   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon4.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text("1.04 ± 0.009    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon6.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      "1480 AD   ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/molten.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.prehistoric.lava"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://www.researchgate.net/publication/284812060_The_magma_plumbing_system_for_the_1971_Teneguia_eruption_on_La_Palma_Canary_Islands/figures?lo=1');
                    },
                    child: Text(
                      'ResearchGate',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://volcano.si.edu/volcano.cfm?vn=383010');
                    },
                    child: Text(
                      'Global Volcanism Program',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget affwidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.aff'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.aff.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.aff.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.aff.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/red.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.aff.destroyed"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/yellow_sq.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.aff.possible"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 2 : 0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon6.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(translate("info.aff.lava"),
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/vent.png'),
                            iconSize: 38,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.aff.vents"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    const Icon(
                      Icons.rectangle_outlined,
                      color: Color.fromARGB(255, 72, 188, 26),
                      size: 46,
                    ),
                    Text(
                      translate("info.aff.area"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      "▬▬  ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Color.fromARGB(255, 3, 95, 171),
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      translate("info.aff.hydro"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 4 : 0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "▬▬  ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.red,
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      translate("info.aff.roads"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      "▬▬  ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Color.fromARGB(255, 249, 233, 82),
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      translate("info.aff.possible"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      "▬▬  ",
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      translate("info.aff.novisible"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 4 : 0,
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://emergency.copernicus.eu/mapping/list-of-components/EMSR546/ALL/EMSR546_AOI01');
                    },
                    child: Text(
                      'COPERNICUS',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget SO2widget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.So2'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.So2.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.So2.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.So2.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: 10,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.rectangle_rounded,
                      color: Color.fromARGB(255, 148, 32, 28),
                      size: 40,
                    ),
                    Text(" 1E - 2    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.rectangle_rounded,
                      color: Color.fromARGB(255, 235, 56, 50),
                      size: 40,
                    ),
                    Text(" 8.75E - 3    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.rectangle_rounded,
                      color: Color.fromARGB(255, 251, 248, 81),
                      size: 40,
                    ),
                    Text(" 6.25E - 3    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.rectangle_rounded,
                      color: Color.fromARGB(255, 107, 248, 251),
                      size: 40,
                    ),
                    Text(" 3.75E - 3    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.rectangle_rounded,
                      color: Color.fromARGB(255, 29, 71, 246),
                      size: 40,
                    ),
                    Text(" 1.25E - 3    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.rectangle_rounded,
                      color: Color.fromARGB(255, 9, 35, 135),
                      size: 40,
                    ),
                    Text(" 0.0    ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/VO.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.So2.volcano"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://apps.sentinel-hub.com/eo-browser/?zoom=8&lat=26.79465&lng=-18.25928&themeId=DEFAULT-THEME&visualizationUrl=https%3A%2F%2Fservices.sentinel-hub.com%2Fogc%2Fwms%2F2c5dc5f7-4c83-40dd-a520-da2c7221568d&datasetId=S5_SO2&fromTime=2021-09-21T00%3A00%3A00.000Z&toTime=2021-09-21T23%3A59%3A59.999Z&layerId=SO2_VISUALIZED');
                    },
                    child: Text(
                      'Sentinel EO Browser',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://www.gdacs.org/report.aspx?eventtype=VO&eventid=1000031');
                    },
                    child: Text(
                      'GDACS',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://twitter.com/wmo/status/1442442516536696832');
                    },
                    child: Text(
                      'Twitter | Platform ADAM',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget situationwidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.situation'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.situation.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.situation.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.situation.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 5 : 3,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset(
                                'assets/icons/main_eruptive_event.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.situation.main"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/VO.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.situation.orange"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon6.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(translate("info.situation.maritime"),
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 5 : 3,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/close.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(translate("info.situation.closed"),
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    Transform.scale(
                        scale: useTabletLayout ? 1.0 : 0.7,
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Image.asset('assets/icons/Polygon14.png'),
                            iconSize: 20,
                            onPressed: () => {},
                          ),
                        )),
                    Text(
                      translate("info.situation.lava"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      translate("info.situation.Text"),
                      style: TextStyle(
                          fontSize: 23.0,
                          color: Color.fromARGB(255, 132, 95, 55),
                          fontFamily: "GoogleSans"),
                    ),
                    Text(
                      translate("info.situation.municipality"),
                      style: TextStyle(
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontFamily: "GoogleSans"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 255, 248, 82),
                      size: 20,
                    ),
                    Text(" 11-12  ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 247, 184, 68),
                      size: 20,
                    ),
                    Text(" 13-14  ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 239, 99, 55),
                      size: 20,
                    ),
                    Text(" 15-16  ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 167, 36, 33),
                      size: 20,
                    ),
                    Text(" 17-18  ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 98, 17, 15),
                      size: 20,
                    ),
                    Text(" 19  ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 124, 93, 30),
                      size: 20,
                    ),
                    Text(" 20  ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 20,
                    ),
                    Text(translate("info.situation.data"),
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 8,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://www.ign.es/web/ign/portal/sis-catalogo-terremotos');
                    },
                    child: Text(
                      'Instituto Geográfico Nacional',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://www.gdacs.org/report.aspx?eventid=1000031&episodeid=2&eventtype=VO');
                    },
                    child: Text(
                      'GDACS',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    ' , ',
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://erccportal.jrc.ec.europa.eu/ECHO-Products/Maps#/maps/3850');
                    },
                    child: Text(
                      'ERCC Portal',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    Widget locatedeventswidget = Column(children: [
      Align(
        alignment: Alignment.center,
        child: Text(
          translate('Track.located'),
          style: TextStyle(
              color: Colors.white,
              fontSize: useTabletLayout ? 34.5 : 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: useTabletLayout ? 15 : 5,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.info_outline_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.located.description"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.calendar_month_rounded,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.date"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.located.date"),
                    style: new TextStyle(
                      fontSize: useTabletLayout ? 18.5 : 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 8 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Color.fromARGB(255, 125, 164, 243),
                child: Icon(Icons.map_sharp,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.legend"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
            flex: 9,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(translate("info.located.legend"),
                    style: TextStyle(
                        fontSize: useTabletLayout ? 18.5 : 14,
                        color: Colors.white70,
                        fontFamily: "GoogleSans")),
                SizedBox(
                  height: useTabletLayout ? 8 : 2,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 255, 248, 82),
                      size: 20,
                    ),
                    Text(" 0 - 2 mbLg   ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 5 : 3,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 247, 184, 68),
                      size: 20,
                    ),
                    Text(" 2 - 3 mbLg   ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 5 : 3,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.circle_rounded,
                      color: Color.fromARGB(255, 239, 99, 55),
                      size: 20,
                    ),
                    Text(" 3 - 4 mbLg   ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
                SizedBox(
                  height: useTabletLayout ? 5 : 3,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.scale(
                        scale: 1.2,
                        child: Transform.rotate(
                          angle: 23.55,
                          child: const Icon(
                            Icons.play_arrow,
                            color: Color.fromARGB(255, 141, 199, 255),
                            size: 30,
                          ),
                        )),
                    Text("5 - 6 mbLg   ",
                        style: TextStyle(
                            fontSize: useTabletLayout ? 18.5 : 14,
                            color: Colors.white70,
                            fontFamily: "GoogleSans")),
                  ],
                ),
              ],
            ),
          ),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
      SizedBox(
        height: useTabletLayout ? 10 : 2,
      ),
      new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.only(
              left: useTabletLayout ? 70.0 : 25,
              right: 10.0,
            ),
            child: ClipRRect(
              child: Container(
                color: Colors.transparent,
                child: Icon(Icons.link,
                    color: Colors.white, size: useTabletLayout ? 36.0 : 18.0),
              ),
            ),
          ),
          new Expanded(
              flex: 2,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    translate("info.sources"),
                    style: new TextStyle(
                        fontSize: useTabletLayout ? 20.0 : 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )),
          new Expanded(
              flex: 9,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _launchURL(
                          'https://www.ign.es/web/resources/sismologia/tproximos/prox.html#');
                    },
                    child: Text(
                      'Instituto Geográfico Nacional',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: useTabletLayout ? 18.5 : 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
          new Padding(
              padding: new EdgeInsets.only(
            right: useTabletLayout ? 70.0 : 25,
          )),
        ],
      ),
    ]);
    final List<Widget> track_cards = [
      // Historical Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? histwidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10),
                        child: histwidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),

      // Lava Flow Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? lavawidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10),
                        child: lavawidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
      // Pre-historic Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? prewidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10), child: prewidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
      // Affected Areas Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? affwidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10), child: affwidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
      // Landscape Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? landscapewidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10),
                        child: landscapewidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
      // SO2 Emissions Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? SO2widget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10), child: SO2widget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
      // Situation Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? situationwidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10),
                        child: situationwidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
      // Located Events Track
      Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => Container(
                margin: EdgeInsets.fromLTRB(90, 0, 90, 0),
                padding: EdgeInsets.only(top: useTabletLayout ? 20 : 10),
                child: useTabletLayout
                    ? locatedeventswidget
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 10),
                        child: locatedeventswidget),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 125, 164, 243),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: themeNotifier.isDark
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              )),
    ];

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 700,
          initialPage: x,
          scrollDirection: Axis.vertical,
          autoPlayInterval: const Duration(milliseconds: 5000),
          autoPlay: false,
        ),
        items: track_cards,
      )),
      Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) => Positioned(
          top: useTabletLayout ? 200 : 50,
          right: useTabletLayout ? 0 : 10,
          child: Card(
            elevation: 0,
            child: Container(
              color: themeNotifier.isDark
                  ? Color.fromARGB(255, 30, 30, 30)
                  : Color.fromARGB(255, 68, 68, 68),
              width: useTabletLayout ? 69.5 : 60,
              height: useTabletLayout ? 175 : 162,
              child: Column(
                children: <Widget>[
                  SizedBox(height: useTabletLayout ? 6 : 0),
                  RotationTransition(
                    turns: Tween(begin: 0.0, end: 25.0)
                        .animate(_rotationiconcontroller),
                    child: Builder(
                      builder: (context) => IconButton(
                        icon: Image.asset('assets/icons/orbit.png'),
                        iconSize: 57,
                        onPressed: () => {
                          isOrbiting = !isOrbiting,
                          if (isOrbiting == true)
                            {
                              _rotationiconcontroller.forward(),
                              LGConnection().cleanOrbit().then((value) {
                                playOrbit().then((value) {
                                  _showToast(translate('map.buildorbit'),
                                      themeNotifier.isDark);
                                });
                              }).catchError((onError) {
                                _rotationiconcontroller.stop();
                                print('oh no $onError');
                                if (onError == 'nogeodata') {
                                  showAlertDialog(
                                      translate('Track.alert'),
                                      translate('Track.alert2'),
                                      themeNotifier.isDark);
                                }
                                showAlertDialog(
                                    translate('Track.alert3'),
                                    translate('Track.alert4'),
                                    themeNotifier.isDark);
                              }),
                            }
                          else
                            {
                              _rotationiconcontroller.reset(),
                              stopOrbit().then((value) {
                                _showToast(translate('map.stoporbit'),
                                    themeNotifier.isDark);
                                LGConnection().cleanOrbit();
                              }).catchError((onError) {
                                print('oh no $onError');
                                if (onError == 'nogeodata') {
                                  showAlertDialog(
                                      translate('Track.alert'),
                                      translate('Track.alert2'),
                                      themeNotifier.isDark);
                                }
                                showAlertDialog(
                                    translate('Track.alert3'),
                                    translate('Track.alert4'),
                                    themeNotifier.isDark);
                              }),
                            }
                        },
                      ),
                    ),
                  ),
                  Divider(),
                  loading
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              SizedBox(
                                height: 10,
                              ),
                              RotatedBox(
                                  quarterTurns: -1,
                                  child: LinearPercentIndicator(
                                    animation: true,
                                    width: 51,
                                    lineHeight: 51,
                                    alignment: MainAxisAlignment.center,
                                    backgroundColor: themeNotifier.isDark
                                        ? Color.fromARGB(205, 42, 47, 48)
                                        : Color.fromARGB(205, 180, 199, 206),
                                    percent: 1.0,
                                    padding: EdgeInsets.all(0),
                                    animationDuration: _duration,
                                    center: Wrap(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 10,
                                        ),
                                        RotatedBox(
                                            quarterTurns: 1,
                                            child: Icon(
                                              Icons.location_on_sharp,
                                              color: Color.fromARGB(
                                                  255, 228, 6, 9),
                                              size: 45.0,
                                            )),
                                      ],
                                    ),
                                    barRadius: Radius.circular(50),
                                    progressColor: Colors.greenAccent,
                                  ))
                            ])
                      : Builder(
                          builder: (context) => IconButton(
                              icon: Image.asset('assets/icons/lg.png'),
                              iconSize: 57,
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                LGConnection()
                                    .sendToLG(retrykml, retryname)
                                    .then((value) {
                                  _showToast(translate('Track.Visualize'),
                                      themeNotifier.isDark);
                                  setState(() {
                                    loading = false;
                                  });
                                }).catchError((onError) {
                                  print('oh no $onError');
                                  setState(() {
                                    loading = false;
                                  });
                                  if (onError == 'nogeodata') {
                                    showAlertDialog(
                                        translate('Track.alert'),
                                        translate('Track.alert2'),
                                        themeNotifier.isDark);
                                  }
                                  showAlertDialog(
                                      translate('Track.alert3'),
                                      translate('Track.alert4'),
                                      themeNotifier.isDark);
                                });
                              })),
                ],
              ),
            ),
          ),
        ),
      ),
    ]));
  }
}

class LGConnection {
  Future sendToLG(String kml, String projectname) async {
    if (kml.isNotEmpty) {
      return _createLocalFile(kml, projectname);
    }
    return Future.error('nogeodata');
  }

  _createLocalFile(String kml, String projectname) async {
    String localPath = await _localPath;
    File localFile = File('$localPath/$projectname.kml');
    localFile.writeAsString(kml);
    File localFile2 = File('$localPath/kmls.txt');
    localFile2.writeAsString(kml);
    return _uploadToLG('$localPath/$projectname.kml', projectname);
  }

  _uploadToLG(String localPath, String projectname) async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    LookAt flyto = LookAt(
      projectname == "Historic_Track"
          ? -17.885454
          : projectname == "Located_Events"
              ? -17.834886
              : projectname == "SO2_Emission"
                  ? -7.561565
                  : projectname == "Prehistoric_Track"
                      ? -17.885454
                      : projectname == "Lava_Flow"
                          ? -17.892286
                          : -17.895486,
      projectname == "Historic_Track"
          ? 28.556656
          : projectname == "Located_Events"
              ? 28.564986
              : projectname == "SO2_Emission"
                  ? 33.561245
                  : projectname == "Prehistoric_Track"
                      ? 28.556656
                      : projectname == "Lava_Flow"
                          ? 28.616354
                          : projectname == "Affected_Areas"
                              ? 28.616354
                              : projectname == "Situation"
                                  ? 28.597354
                                  : projectname == "Landscape"
                                      ? 28.616354
                                      : 28.610478,
      projectname == "Located_Events"
          ? '${61708.9978371 / int.parse(credencials['numberofrigs'])}'
          : projectname == "Lava_Flow"
              ? '${18208.9978371 / int.parse(credencials['numberofrigs'])}'
              : projectname == "Landscape"
                  ? '${65208.997837 / int.parse(credencials['numberofrigs'])}'
                  : projectname == "Affected_Areas"
                      ? '${18208.9978371 / int.parse(credencials['numberofrigs'])}'
                      : projectname == "Situation"
                          ? '${75208.9978371 / int.parse(credencials['numberofrigs'])}'
                          : projectname == "Historic_Track"
                              ? '${151708.997837 / int.parse(credencials['numberofrigs'])}'
                              : projectname == "SO2_Emission"
                                  ? '${10500001.9978 / int.parse(credencials['numberofrigs'])}'
                                  : projectname == "Prehistoric_Track"
                                      ? '${151708.997837 / int.parse(credencials['numberofrigs'])}'
                                      : '${91708.9978371 / int.parse(credencials['numberofrigs'])}',
      projectname == "Historic_Track"
          ? '41.82725143432617'
          : projectname == "SO2_Emission"
              ? '25'
              : projectname == "Prehistoric_Track"
                  ? '41.82725143432617'
                  : '45',
      projectname == "Historic_Track"
          ? ' 61.403038024902344'
          : projectname == "Prehistoric_Track"
              ? ' 61.403038024902344'
              : '0',
    );
    try {
      await client.connect();
      await client.execute('> /var/www/html/kmls.txt');

      // upload kml
      await client.connectSFTP();
      await client.sftpUpload(
        path: localPath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );

      // for (int k = 0; k < localimages.length; k++) {
      //   String imgPath = await _createLocalImage(
      //       localimages[k], "assets/icons/${localimages[k]}");
      //   await client.sftpUpload(path: imgPath, toPath: '/var/www/html');
      // }
      await client.execute(
          'echo "http://lg1:81/$projectname.kml" > /var/www/html/kmls.txt');

      return await client.execute(
          'echo "flytoview=${flyto.generateLinearString()}" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  _getCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ipAddress = preferences.getString('master_ip') ?? '';
    String password = preferences.getString('master_password') ?? '';
    String portNumber = preferences.getString('master_portNumber') ?? '';
    String username = preferences.getString('master_username') ?? '';
    String numberofrigs = preferences.getString('numberofrigs') ?? '';

    return {
      "ip": ipAddress,
      "pass": password,
      "port": portNumber,
      "username": username,
      "numberofrigs": numberofrigs
    };
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  buildOrbit(String content) async {
    dynamic credencials = await _getCredentials();

    String localPath = await _localPath;
    File localFile = File('$localPath/Orbit.kml');
    localFile.writeAsString(content);

    String filePath = '$localPath/Orbit.kml';

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      await client.connectSFTP();
      await client.sftpUpload(
        path: filePath,
        toPath: '/var/www/html',
        callback: (progress) {
          print('Sent $progress');
        },
      );
      return await client.execute(
          "echo '\nhttp://lg1:81/Orbit.kml' >> /var/www/html/kmls.txt");
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  startOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "playtour=Orbit" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  stopOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "exittour=true" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }

  cleanOrbit() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      return await client.execute('echo "" > /tmp/query.txt');
    } catch (e) {
      print('Could not connect to host LG');
      return Future.error(e);
    }
  }
}
