import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:provider/provider.dart';
import 'package:voltrac/codingapp/theme-storage.dart';
import 'package:voltrac/codingapp/mainpage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    final double shortestSide = MediaQuery.of(context)
        .size
        .shortestSide; // get the shortest side of device
    final bool useTabletLayout = shortestSide > 600.0; // check for tablet

    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) => SplashScreenView(
              duration: 5000,
              navigateRoute: First(),
              text: translate('title.name'),
              textType: TextType.TyperAnimatedText,
              textStyle: TextStyle(
                fontFamily: 'GoogleSans',
                fontSize: useTabletLayout ? 55 : 32,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
              imageSrc: "assets/icons/volcanoandlogo.png",
              backgroundColor: themeNotifier.isDark
                  ? Color.fromARGB(255, 16, 16, 16)
                  : Color.fromARGB(255, 30, 30, 30),
              imageSize: useTabletLayout ? 650 : 280,
              // loaderColor: const Color.fromARGB(255, 204, 204, 204),
            ));
  }
}
