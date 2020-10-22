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
      return _channel.invokeMethod(
        "faceDetect",
        {
          "imageData": imageInMemory,
          "displayWidth": displayWidth,
          "displayHeight": displayHeight,
        },
      );
    } else {
      return List<Rect>();
    }
  }

  Future<List<String>> labelDetect(
    Int8List imageInMemory,
    int displayWidth,
    int displayHeight,
  ) async {
    if (Platform.isIOS) {
      return _channel.invokeListMethod(
        "labelDetect",
      );
    } else {
      return List<String>();
    }
  }
}
