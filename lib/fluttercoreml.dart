// You have generated a new plugin project without
// specifying the `--platforms` flag. A plugin project supports no platforms is generated.
// To add platforms, run `flutter create -t plugin --platforms <platforms> .` under the same
// directory. You can also find a detailed instruction on how to add platforms in the `pubspec.yaml` at https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

library fluttercoreml;

import 'dart:async';
import 'dart:ui';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

part 'src/face_detect.dart';
part 'src/image_label_detect.dart';

class FlutterCoreML {
  static const MethodChannel _channel = const MethodChannel('fluttercoreml');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static final FlutterCoreML instance = FlutterCoreML();

  Future<List<Rect>> faceDetect(
    Uint8List imageInMemory,
    double displayWidth,
    double displayHeight,
  ) async {
    if (Platform.isIOS) {
      try {
        List<dynamic> results = await _channel.invokeMethod(
          "faceDetect",
          {
            "imageData": imageInMemory,
            "displayWidth": displayWidth,
            "displayHeight": displayHeight,
          },
        );

        var returnResults = List<Rect>();

        for (var result in results) {
          var rectArray = result.split(",");
          returnResults.add(
            Rect.fromLTWH(
              double.parse(rectArray[0]),
              double.parse(rectArray[1]),
              double.parse(rectArray[2]),
              double.parse(
                rectArray[3],
              ),
            ),
          );
        }
        return returnResults;
      } on PlatformException catch (e) {
        print(e.toString());
        return List<Rect>();
      }
    } else {
      return List<Rect>();
    }
  }

  Future<List<String>> labelDetect(
    Uint8List imageInMemory,
  ) async {
    if (Platform.isIOS) {
      List<dynamic> results = await _channel.invokeMethod(
        "labelDetect",
        {
          "imageData": imageInMemory,
        },
      );

      var returnResults = List<String>();
      for (var item in results) {
        returnResults.add(item.toString());
      }

      return returnResults;
    } else {
      return List<String>();
    }
  }
}
