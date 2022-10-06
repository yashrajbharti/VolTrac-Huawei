import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:voltrac/codingapp/drawer.dart';
import 'package:voltrac/codingapp/layout.dart';
import 'package:voltrac/codingapp/theme.dart';
import 'package:provider/provider.dart';
import 'package:voltrac/codingapp/theme-storage.dart';
import 'package:feature_discovery/feature_discovery.dart';

class Mainpage extends StatefulWidget {
  Mainpage({Key? key}) : super(key: key);

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useTabletLayout = shortestSide > 600.0; // check for tablet
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(useTabletLayout ? 100.0 : 50),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) => Container(
                  color: themeNotifier.isDark
                      ? Color.fromARGB(255, 16, 16, 16)
                      : Color.fromARGB(255, 204, 204, 204),
                  child: Padding(
                    padding: EdgeInsets.only(top: useTabletLayout ? 30 : 0),

                    // here the desired height
                    child: AppBar(
                      elevation: 0,
                      title: Padding(
                        // change left :
                        padding: EdgeInsets.only(
                            left: useTabletLayout ? 120 : 90, top: 6),
                        child: Text(
                          translate('title.name'),
                          style: TextStyle(
                            fontSize: useTabletLayout ? 48 : 25,
                            color: themeNotifier.isDark
                                ? Color.fromARGB(255, 204, 204, 204)
                                : Color.fromARGB(255, 16, 16, 16),
                          ),
                        ),
                      ),
                      actions: [
                        Builder(
                          builder: (context) => Padding(
                              // change left :
                              padding: const EdgeInsets.only(right: 30),
                              child: DescribedFeatureOverlay(
                                  featureId:
                                      'feature', // Unique id that identifies this overlay.
                                  tapTarget: Transform.scale(
                                      scale: useTabletLayout ? 1.0 : 0.7,
                                      child: Image.asset(
                                        themeNotifier.isDark
                                            ? 'assets/menu-white.png'
                                            : 'assets/menu.png',
                                        height: 36,
                                      )), // The widget that will be displayed as the tap target.
                                  overflowMode: OverflowMode.extendBackground,
                                  title: Text(
                                    translate("tour.app"),
                                    style: TextStyle(
                                        fontSize: useTabletLayout ? 24 : 15),
                                  ),
                                  description: Text(translate("tour.desc"),
                                      style: TextStyle(
                                        fontSize: useTabletLayout ? 16 : 12,
                                      )),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  targetColor: themeNotifier.isDark
                                      ? Color.fromARGB(255, 30, 30, 30)
                                      : Colors.white,
                                  textColor: themeNotifier.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  child: Transform.scale(
                                      scale: useTabletLayout ? 1.0 : 0.7,
                                      child: IconButton(
                                          icon: Image.asset(themeNotifier.isDark
                                              ? 'assets/menu-white.png'
                                              : 'assets/menu.png'),
                                          iconSize: 120,
                                          onPressed: () {
                                            Scaffold.of(context)
                                                .openEndDrawer();
                                          })))),
                        )
                      ],
                    ),
                  ),
                )),
      ),
      endDrawer: FeatureDiscovery(child: Drawers()),
      body: Layout(),
    );
  }

  @override
  void initState() {
    // ...
    SchedulerBinding.instance?.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          // Feature ids for every feature that you want to showcase in order.
          'feature',
        },
      );
    });
    super.initState();
  }
}

class First extends StatelessWidget {
  First({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) => FeatureDiscovery(
            child: MaterialApp(
                home: Mainpage(),
                theme: themeNotifier.isDark ? isDarkTheme : isLightTheme)));
  }
}
