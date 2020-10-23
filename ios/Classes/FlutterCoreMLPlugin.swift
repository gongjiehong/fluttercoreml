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
            guard let typedData = arguments["imageData"] as? FlutterStandardTypedData,
                  let displayWidth = arguments["displayWidth"] as? CGFloat,
                  let displayHeight = arguments["displayHeight"] as? CGFloat else {
                result(FlutterError(code: "-1",
                                     message: "params invalid",
                                     details: "imageData, displayWidth, displayHeight can not read"))
                return
            }
            
            let imageData = typedData.data
            
            if let image = UIImage(data: imageData) {
                let faceDetector = FaceDetect()
                let rects = faceDetector.predictionFace(image,
                                                        displayWidth: displayWidth,
                                                        displayHeight: displayHeight)
                var resultArray = [String]()
                for rect in rects {
                    resultArray.append(String(format: "%f,%f,%f,%f",
                                              rect.origin.x,
                                              rect.origin.y,
                                              rect.width,
                                              rect.height))
                }
                result(resultArray)
            } else {
                result(FlutterError(code: "-2",
                                     message: "can not decode image data",
                                     details: "imageData can not convert to UIImage and read CGImage"))
            }
        } else {
            result(FlutterError(code: "-3",
                                 message: "arguments is not map",
                                 details: "arguments can not convert to map object"))
        }
        break
      case "labelDetect":
        if let arguments = call.arguments as? [String: Any] {
            guard let typedData = arguments["imageData"] as? FlutterStandardTypedData else {
                result(FlutterError(code: "-1",
                                    message: "params invalid",
                                    details: "imageData can not read"))
                return
            }
            
            let imageData = typedData.data
            
            if let image = UIImage(data: imageData) {
                let labelDetector = LabelDetect()
                let labels = labelDetector.detectLabel(image)
                result(labels)
            } else {
                result(FlutterError(code: "-2",
                                    message: "can not decode image data",
                                    details: "imageData can not convert to UIImage and read CGImage"))
            }
        } else {
            result(FlutterError(code: "-3",
                                message: "arguments is not map",
                                details: "arguments can not convert to map object"))
        }
        break
      default:
        break
      }
  }
}
