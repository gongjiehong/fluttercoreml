import Flutter

public class FlutterCoreMLPlugin: NSObject, FlutterPlugin {
  /// Public register method for Flutter plugin registrar.
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "fluttercoreml",
                                       binaryMessenger: registrar.messenger())
    let instance = FlutterCoreMLPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  /// Public handler method for managing method channel calls.
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
      case "faceDetect":
        if let arguments = call.arguments as? [String: Any] {
            guard let imageData = arguments["imageData"] as? Data,
                  let displayWidth = arguments["displayWidth"] as? CGFloat,
                  let displayHeight = arguments["displayHeight"] as? CGFloat else {
                result([FlutterError(code: "-1",
                                     message: "params invalid",
                                     details: "imageData, displayWidth, displayHeight can not read")])
                return
            }
            
            if let image = UIImage(data: imageData) {
                let faceDetector = FaceDetect()
                let rects = faceDetector.predictionFace(image,
                                                        displayWidth: displayWidth,
                                                        displayHeight: displayHeight)
                result(rects)
            } else {
                result([FlutterError(code: "-2",
                                     message: "can not decode image data",
                                     details: "imageData can not convert to UIImage and read CGImage")])
            }
        } else {
            result([FlutterError(code: "-3",
                                 message: "arguments is not map",
                                 details: "arguments can not convert to map object")])
        }
        break
      case "labelDetect":
        break
      default:
        break
      }
  }
}
