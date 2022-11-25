//
//  FaceExpressionPredictor.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/25.
//

import Foundation
import Vision

class FaceExpressionPredictor {
    static func createFaceExpressionClassifier() -> VNCoreMLModel {
        guard let miniXception = try? MiniXception(configuration: MLModelConfiguration()),
              let miniXceptionVisionModel = try? VNCoreMLModel(for: miniXception.model) else {
            fatalError("Failed to create a MiniXception")
        }
        
        return miniXceptionVisionModel
    }
    
    static let faceExpressionClassifier = createFaceExpressionClassifier()
    
    struct Prediction {
        let classification: String
        let confidencePercentage: String
        
        var predictionResultString: String {
            return classification + ": " + confidencePercentage + "%"
        }
    }
    
    typealias FaceExpressionPredictionHandler = (_ predications: [Prediction]?) -> Void
    
    private func createFaceExpressionClassificationRequest(predictionHandler: @escaping FaceExpressionPredictionHandler) -> VNImageBasedRequest {
        let faceExpressionClassificationRequest = VNCoreMLRequest(model: Self.faceExpressionClassifier) { (request, error) in
            var predictions: [Prediction]? = nil
            
            defer {
                predictionHandler(predictions)
            }
            
            if let error = error {
                print("Vision image classification error...\n\n\(error.localizedDescription)")
                return
            }
            
            if request.results == nil {
                print("Vision request had no resuls")
                return
            }
            
            guard let observations = request.results as? [VNClassificationObservation] else {
                print("VNRequest produced the wrong result type: \(type(of: request.results))")
                return
            }
            
            predictions = observations.map { observation in
                Prediction(classification: observation.identifier,
                           confidencePercentage: observation.confidencePercentageString)
            }
        }
        
        faceExpressionClassificationRequest.imageCropAndScaleOption = .centerCrop
        return faceExpressionClassificationRequest
    }
    
    func makePredictions(for photo: CGImage, completionHandler: @escaping FaceExpressionPredictionHandler) throws {
        let faceExpressionClassificaitonRequest = createFaceExpressionClassificationRequest(predictionHandler: completionHandler)
        
        let handler = VNImageRequestHandler(cgImage: photo)
        let requests: [VNRequest] = [faceExpressionClassificaitonRequest]
        
        try handler.perform(requests)
    }
}
