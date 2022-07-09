import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_translate/flutter_translate.dart';
import 'package:webscrapperapp/codingapp/mainpage.dart';
import 'package:webscrapperapp/codingapp/menuOptions/help.dart';
import 'package:webscrapperapp/codingapp/menuOptions/lg_tasks.dart';
import 'package:webscrapperapp/codingapp/menuOptions/custom_builder.dart';
import 'package:webscrapperapp/codingapp/menuOptions/settings.dart';
import 'package:webscrapperapp/codingapp/menuOptions/about.dart';

class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 1.0,
      child: Drawer(
        child: Container(
          color: isDarkTheme
              ? Color.fromARGB(255, 16, 16, 16)
              : Color.fromARGB(255, 204, 204, 204),
          child: ListView(
            padding: const EdgeInsets.only(left: 100),
            children: [
              DrawerHeader(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                      child: Text(
                        translate("drawer.menu"),
                        style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                            fontSize: 46),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 36, 65),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shadowColor: Colors.transparent,
                              primary: isDarkTheme
                                  ? Color.fromARGB(255, 16, 16, 16)
                                  : Color.fromARGB(255, 204, 204, 204),
                              padding: EdgeInsets.all(15)),
                          child: Icon(
                            Icons.clear_rounded,
                            color: isDarkTheme
                                ? Color.fromARGB(255, 204, 204, 204)
                                : Color.fromARGB(255, 84, 84, 84),
                            size: 60,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => First(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  translate("drawer.help"),
                  style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 40),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => HelpScreen(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                title: Text(
                  translate("drawer.about"),
                  style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 40),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => AboutScreen(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                title: Text(
                  translate("drawer.custom"),
                  style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 40),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CustomBuilder(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                title: Text(
                  translate("drawer.task"),
                  style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 40),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LGtasks(),
                  ),
                ),
              ),
              SizedBox(height: 24),
              ListTile(
                title: Text(
                  translate("drawer.settings"),
                  style: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                      fontSize: 40),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Settings(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 100),
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
