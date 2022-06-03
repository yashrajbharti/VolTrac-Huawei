import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_translate/flutter_translate.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ssh/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;
import 'package:webscrapperapp/codingapp/drawer.dart';
import 'package:webscrapperapp/codingapp/translate.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color _iconColor = Color.fromARGB(255, 74, 74, 74);
  bool isLoggedIn = false;
  bool obscurePassword = true;
  bool loaded = false;
  TextEditingController username = TextEditingController();
  TextEditingController ipAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController portNumber = TextEditingController();

  bool connectionStatus = false;

  connect() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('master_ip', ipAddress.text);
    await preferences.setString('master_username', username.text);
    await preferences.setString('master_password', password.text);
    await preferences.setString('master_portNumber', portNumber.text);

    SSHClient client = SSHClient(
      host: ipAddress.text,
      port: int.parse(portNumber.text),
      username: username.text,
      passwordOrKey: password.text,
    );

    try {
      await client.connect();
      showAlertDialog(translate("Settings.alert"),
          '${ipAddress.text} ' + translate("Settings.alert2"));
      setState(() {
        connectionStatus = true;
      });
      // open logos
      await client.disconnect();
    } catch (e) {
      showAlertDialog(translate("Settings.alert3"),
          '${ipAddress.text} ' + translate("Settings.alert4"));
      setState(() {
        connectionStatus = false;
      });
    }
  }

  checkConnectionStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('master_ip', ipAddress.text);
    await preferences.setString('master_password', password.text);
    await preferences.setString('master_portNumber', portNumber.text);

    SSHClient client = SSHClient(
      host: ipAddress.text,
      port: int.tryParse(portNumber.text),
      username: username.text,
      passwordOrKey: password.text,
    );

    try {
      await client.connect();
      setState(() {
        connectionStatus = true;
      });
      await client.disconnect();
    } catch (e) {
      showAlertDialog(translate("Settings.alert3"),
          '${ipAddress.text} ' + translate("Settings.alert4"));
      setState(() {
        connectionStatus = false;
      });
    }
  }

  showAlertDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 3),
          child: AlertDialog(
            backgroundColor: Color.fromARGB(255, 33, 33, 33),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 204, 204, 204),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Color.fromARGB(255, 125, 164, 243),
                    size: 32,
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
            content: Text(
              '$msg',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),
          ),
        );
      },
    );
  }

  init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    ipAddress.text = preferences.getString('master_ip') ?? '';
    username.text = preferences.getString('master_username') ?? '';
    password.text = preferences.getString('master_password') ?? '';
    portNumber.text = preferences.getString('master_portNumber') ?? '';

    await checkConnectionStatus();

    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) init();
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 204, 204, 204),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 50.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Drawers(),
                  ),
                );
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: 10),
                  child: Text(
                    translate("Settings.title"),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0, top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        translate("Settings.Status"),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        connectionStatus
                            ? translate("Settings.connect")
                            : translate("Settings.disconnect"),
                        style: TextStyle(fontSize: 20),
                      ),
                      connectionStatus
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            )
                          : Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 20,
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0.0),
                  child: TextFormField(
                    controller: username,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: translate("Settings.placeholder"),
                      labelText: translate("Settings.label"),
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: TextFormField(
                    controller: ipAddress,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: translate("Settings.placeholder2"),
                      labelText: translate("Settings.label2"),
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: TextFormField(
                    controller: portNumber,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: translate("Settings.placeholder3"),
                      labelText: translate("Settings.label3"),
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                    ),
                  ),
                ),
                TextFormField(
                  controller: password,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: translate("Settings.placeholder4"),
                    labelText: translate("Settings.label4"),
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 74, 74, 74)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye, color: _iconColor),
                      onPressed: () {
                        setState(
                          () {
                            obscurePassword = !obscurePassword;
                            if (_iconColor == Color.fromARGB(255, 74, 74, 74)) {
                              _iconColor = Color(0xFF3E87F5);
                            } else {
                              _iconColor = Color.fromARGB(255, 74, 74, 74);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      child: Wrap(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Text(translate("Settings.button"),
                              style: TextStyle(fontSize: 25)),
                        ],
                      ),
                      onPressed: () {
                        connect();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        shadowColor: Colors.transparent,
                        primary: Colors.white,
                        padding: EdgeInsets.all(15),
                        shape: StadiumBorder(),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 74, 74, 74),
                  thickness: 1,
                ),
                ListTile(
                  leading: Text(
                    translate('language.flag'),
                    style: TextStyle(fontSize: 20),
                  ),
                  title: Text(translate('language.selected_message', args: {
                    'language': translate(
                        'language.name.${localizationDelegate.currentLocale.languageCode}')
                  })),
                  trailing: IconButton(
                    onPressed: () => onActionSheetPress(context),
                    icon: const Icon(
                      Icons.translate_rounded,
                      size: 32,
                      color: Color.fromARGB(255, 74, 74, 74),
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 74, 74, 74),
                  thickness: 1,
                ),
              ],
            ),
          ),
        ));
  }
}
