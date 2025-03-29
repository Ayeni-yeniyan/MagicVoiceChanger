// framework

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// packages
// import 'package:flutter_file_manager/flutter_file_manager.dart';
// import 'package:magic_voice/voiceChanger.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:voice_changer_plugin/voice_changer_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Voice Changer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MagicVoiceChanger(),
    );
  }
}

class MagicVoiceChanger extends StatefulWidget {
  @override
  _MagicVoiceChangerState createState() => _MagicVoiceChangerState();
}

class _MagicVoiceChangerState extends State<MagicVoiceChanger> {
  int t = 0;
  var diTxt = "Press play button to confirm?";

  changeVoice(String path, int type) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (snapshot) {
          return AlertDialog(
            content: Text(diTxt),
            elevation: 12,
            actions: <Widget>[
              ElevatedButton(
                child: Text('Play'),
                onPressed: () {
                  try {
                    VoiceChangerPlugin.change(path, type).then((v) {
                      Navigator.pop(context);
                    }).catchError((err) {
                      print(err);
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),

              // ElevatedButton(
              //   child: Text('close'),
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          );
        });
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magic Voice Changer'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  child: Text('normal'),
                  onPressed: () {
                    setState(() {
                      t = 0;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('lorie'),
                  onPressed: () {
                    setState(() {
                      t = 1;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('terror'),
                  onPressed: () {
                    setState(() {
                      t = 2;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('uncle'),
                  onPressed: () {
                    setState(() {
                      t = 3;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('funny'),
                  onPressed: () {
                    setState(() {
                      t = 4;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('vacant'),
                  onPressed: () {
                    setState(() {
                      t = 5;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getAudioFiles(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('click to start');
                  case ConnectionState.waiting:
                    return Text('Awaiting for Result');
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('snapshot Error : ${snapshot.error}');
                    if (snapshot.data != null) {
                      print(snapshot.data.length);
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          if (p
                              .extension(snapshot.data[i].absolute.path)
                              .replaceFirst('.', '')
                              .endsWith('mp3')) {
                            return Card(
                              child: ListTile(
                                onTap: () {
                                  changeVoice(
                                      snapshot.data[i].absolute.path, t);
                                },
                                title: Text(snapshot.data[i].absolute.path),
                                subtitle: Text(
                                    "Extention: ${p.extension(snapshot.data[i].absolute.path).replaceFirst('.', '')}"),
                              ),
                            );
                          } else {
                            return Center(child: Text('NO MP3 Found'));
                          }
                        },
                      );
                    } else {
                      return Center(child: Text('Nothing'));
                    }
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _getAudioFiles() async {
    // var root = await getExternalStorageDirectory();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
      allowedExtensions: ['mp3'],
    );
    // var files = await FilePicker(root: root).filesTree(extensions: ["mp3"]);
    // return files;
    return result;
  }
}
