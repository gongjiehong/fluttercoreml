import CoreML
import Vision
import Foundation

class FaceDetect {
    func predictionFace(_ image: UIImage, displayWidth: CGFloat, displayHeight: CGFloat) -> [CGRect] {
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -displayHeight)
        let translate = CGAffineTransform.identity.scaledBy(x: displayWidth, y: displayHeight)
        var returnResults = [CGRect]()
        if let cgImage = image.cgImage  {
            let handler = VNImageRequestHandler(cgImage: cgImage)
            let detectRequest = VNDetectFaceRectanglesRequest { (request, error) in
                if let detectResults = request.results {
                    for item in detectResults {
                        if let faceObservation = item as? VNFaceObservation {
                            let finalRect = faceObservation.boundingBox.applying(translate).applying(transform)
                            returnResults.append(finalRect)
                        }
                    }
                } else {
                }
            }
            
            do {
                try handler.perform([detectRequest])
            } catch {
            }
        }
        return returnResults
    }
}

