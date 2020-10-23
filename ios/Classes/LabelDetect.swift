import Vision
import Flutter
import CoreML


class LabelDetect {
    func detectLabel(_ image: UIImage) -> [String] {
        var resultArray = [String]()
        do {
            let model = try VNCoreMLModel(for: MobileNetV2().model)
            let vnRequest = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else {
                    return
                }
                for result in results {
                    print(result.identifier, result.confidence)
                    if result.confidence > 0.1 {
                        resultArray.append(result.identifier)
                    }
                }
            }
            vnRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
            if let cgImage = image.cgImage  {
                let handler = VNImageRequestHandler(cgImage: cgImage)
                try handler.perform([vnRequest])
            }
        } catch {
            print(error)
        }
        return resultArray
    }
}
