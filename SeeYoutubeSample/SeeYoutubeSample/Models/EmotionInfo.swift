//
//  EmotionInfo.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/26.
//

import Foundation

struct EmotionInfo {
    enum EmotionPredictionState: CustomStringConvertible {
        case success
        case faceMissing
        case failedToCropFace
        case noPredictions
        case unknown
        
        var description: String {
            switch self {
                case .success: return "SUCCESS"
                case .faceMissing: return "FACE_MISSING"
                case .failedToCropFace: return "FAILED_TO_CROP_FACE"
                case .noPredictions: return "NO_PREDICTIONS"
                case .unknown: return "UNKNOWN"
            }
        }
    }
    
    let emotionPredictionState: EmotionPredictionState
    let predictionResult: [FaceExpressionPredictor.Prediction]
    
    var predictionDescription: String {
        return predictionResult.reduce("") { $0 + "\t\t\t\t\t\t  "
            + $1.classification.padding(toLength: 10, withPad: " ", startingAt: 0) + ": "
            + $1.confidencePercentage + " %\n"
        }
    }
}
