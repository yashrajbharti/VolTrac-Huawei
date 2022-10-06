import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:voltrac/codingapp/theme-storage.dart';
import 'package:voltrac/codingapp/Tabs/Info.dart';
import 'package:voltrac/codingapp/Tabs/Track_Tab.dart';
import 'package:voltrac/codingapp/Tabs/Map_Tab.dart';

class Layout extends StatefulWidget {
  Layout({Key? key}) : super(key: key);

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useTabletLayout = shortestSide > 600.0; // check for tablet
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(useTabletLayout ? 50.0 : 36.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              actions: const <Widget>[],
              title: Container(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.82,
                  child: Consumer<ThemeModel>(
                    builder: (context, ThemeModel themeNotifier, child) =>
                        Container(
                      color: themeNotifier.isDark
                          ? Color.fromARGB(255, 30, 30, 30)
                          : Color.fromARGB(255, 149, 149, 149),
                      padding: EdgeInsets.symmetric(vertical: 50.0),
                      child: TabBar(
                        tabs: <Widget>[
                          Tab(
                              child: Transform.translate(
                                  offset: Offset(useTabletLayout ? 0.0 : 0.0,
                                      useTabletLayout ? 0.0 : 5.0),
                                  child: Text(
                                    translate('tabs.track'),
                                    style: TextStyle(
                                        fontSize: useTabletLayout ? 40 : 25),
                                  ))),
                          Tab(
                            child: Transform.translate(
                                offset: Offset(useTabletLayout ? 0.0 : 0.0,
                                    useTabletLayout ? 0.0 : 5.0),
                                child: Text(
                                  translate('tabs.map'),
                                  style: TextStyle(
                                      fontSize: useTabletLayout ? 40 : 25),
                                )),
                          ),
                          Tab(
                            child: Transform.translate(
                                offset: Offset(useTabletLayout ? 0.0 : 0.0,
                                    useTabletLayout ? 0.0 : 5.0),
                                child: Text(
                                  translate('tabs.info'),
                                  style: TextStyle(
                                      fontSize: useTabletLayout ? 40 : 25),
                                )),
                          ),
                        ],
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorWeight: useTabletLayout ? 5.0 : 15.0,
                        indicatorPadding: EdgeInsets.only(top: 5),
                      ),
                    ),
                  ),
                ),
              ),
            )),
        body: TabBarView(
          children: [
            SendtoLG(),
            MyMap(),
            VerticalCardPagerDemo(),
          ],
        ),
      ),
    );
  }
}
