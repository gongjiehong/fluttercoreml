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
  List<Rect> faceRects = List<Rect>();
  List<String> imageLabels = List<String>();
  final ImagePicker _picker = ImagePicker();

  // 屏幕宽度减去左右间距，实际使用时根据实际宽度处理
  double displayWidth = 414.0 - 20.0;

  @override
  Widget build(BuildContext context) {
    var children = List<Widget>();
    if (imageFile != null) {
      children.add(
        Container(
          width: displayWidth,
          padding: EdgeInsets.only(
            left: 0.0,
            right: 0.0,
            top: 0.0,
          ),
          child: Image.file(
            imageFile,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }

    if (faceRects.length > 0) {
      for (var rect in faceRects) {
        children.add(
          Padding(
            padding: EdgeInsets.only(
              left: rect.left,
              top: rect.top,
            ),
            child: Container(
              alignment: Alignment.topLeft,
              color: Colors.blue.withAlpha(155),
              width: rect.width,
              height: rect.height,
            ),
          ),
        );
      }
    }

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
                child: Container(
                  height: 500,
                  child: Stack(
                    children: children,
                  ),
                ),
              ),
              Center(
                child: Text(imageLabels.join(",")),
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
      maxHeight: 600.0,
      maxWidth: 600.0,
    );

    File temp = File(pickedImage.path);
    final size = ImageSizeGetter.getSize(FileInput(temp));

    double imageWidth = size.width.toDouble();
    double imageHeight = size.height.toDouble();

    double displayHeight = imageHeight / (imageWidth / displayWidth);

    print(
        "imageWidth = $imageWidth, imageHeight = $imageHeight, displayWidth = $displayWidth, displayHeight = $displayHeight");

    Uint8List imageData = await pickedImage.readAsBytes();

    var result = await FlutterCoreML.instance.faceDetect(
      imageData,
      displayWidth,
      displayHeight,
    );

    var labels = await FlutterCoreML.instance.labelDetect(imageData);
    imageLabels = labels;
    print(labels);

    print(result);

    setState(() {
      imageFile = temp;
      faceRects = result;
    });
  }
}
