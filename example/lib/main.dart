import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:fluttercoreml/fluttercoreml.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {} on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  File imageFile;
  final ImagePicker _picker = ImagePicker();

  // 屏幕宽度减去左右间距，实际使用时根据实际宽度处理
  double displayWidth = 414.0 - 20.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10.0,
                ),
                child: imageFile != null ? Image.file(imageFile) : null,
              ),
              Center(
                child: IconButton(
                  icon: Icon(Icons.add_a_photo),
                  onPressed: () {
                    chooseImage();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> chooseImage() async {
    PickedFile pickedImage = await _picker.getImage(
      source: ImageSource.gallery,
    );

    File temp = File(pickedImage.path);
    final size = ImageSizeGetter.getSize(FileInput(temp));

    double imageWidth = size.width.toDouble();
    double imageHeight = size.height.toDouble();

    double displayHeight = imageHeight / (imageWidth / displayWidth);

    Uint8List imageData = await pickedImage.readAsBytes();

    var result = await FlutterCoreML().faceDetect(
      imageData,
      displayWidth,
      displayHeight,
    );
    print(result);

    setState(() {
      imageFile = temp;
    });
  }
}
