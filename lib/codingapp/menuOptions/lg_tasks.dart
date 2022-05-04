import 'package:flutter/material.dart';
import 'package:webscrapperapp/codingapp/kml/kml.dart';
import 'package:webscrapperapp/codingapp/kml/kmlgenerator.dart';
import 'package:flutter/services.dart';
import 'package:webscrapperapp/codingapp/kml/LookAt.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:ssh/ssh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class LGtasks extends StatefulWidget {
  LGtasks({Key? key}) : super(key: key);

  @override
  State<LGtasks> createState() => _LGtasksState();
}

String kmltext = "";
String localpath = "";
bool isOpen = false;
String projectname = "a";

Future<String> _read() async {
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/kmls.txt');
    localpath = '${directory.path}/kmls.txt';
    kmltext = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return kmltext;
}

KML kml = KML(projectname, kmltext);

class _LGtasksState extends State<LGtasks> {
  showAlertDialog(String title, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$title'),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text('$msg'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    ElevatedButton(
                        child: const Text(
                          'Download KML!',
                          style: TextStyle(fontSize: 25),
                        ),
                        onPressed: () async {
                          var status = await Permission.storage.status;

                          if (status.isGranted) {
                            try {
                              await KMLGenerator.generateKML(kml.mount(), "a");
                              showAlertDialog('Success!',
                                  'You can find a KML containing the map data of the project in your Downloads folder');
                            } catch (e) {
                              print('error $e');
                              showAlertDialog('Oops!',
                                  'You have to enable storage managing permissions to download the project KML');
                            }
                          } else {
                            var isGranted =
                                await Permission.storage.request().isGranted;
                            if (isGranted) {
                              // download kml
                              try {
                                await KMLGenerator.generateKML(
                                    kml.mount(), "a");
                                showAlertDialog('Success!',
                                    'You can find a KML containing the map data of the project in your Downloads folder');
                              } catch (e) {
                                print('error $e');
                                showAlertDialog('Oops!',
                                    'You have to enable storage managing permissions to download the project KML');
                              }
                            } else {
                              showAlertDialog('Oops!',
                                  'You have to enable storage managing permissions to download the project KML');
                            }
                          }
                        }),
                    ElevatedButton(
                        child: const Text(
                          'Clean KML',
                          style: TextStyle(fontSize: 25),
                        ),
                        onPressed: () {
                          // send to LG
                          LGConnection().cleanVisualization().then((value) {
                            setState(() {
                              isOpen = false;
                            });
                          }).catchError((onError) {
                            print('oh no $onError');
                            showAlertDialog('Error launching!',
                                'An error occurred while trying to connect to LG');
                          });
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LGConnection {
  Future cleanVisualization() async {
    dynamic credencials = await _getCredentials();

    SSHClient client = SSHClient(
      host: '${credencials['ip']}',
      port: int.parse('${credencials['port']}'),
      username: '${credencials['username']}',
      passwordOrKey: '${credencials['pass']}',
    );

    try {
      await client.connect();
      stopOrbit();
      return await client.execute('> /var/www/html/kmls.txt');
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

    return {
      "ip": ipAddress,
      "pass": password,
      "port": portNumber,
      "username": username,
    };
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
}
