//
//  WatchingInfo.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/26.
//

import Foundation
import SeeSo

struct WatchingInfo: CustomStringConvertible {
    var playTime: Float = 0
    var gazeInfo: VideoGazeInfo?
    var emotionInfo: EmotionInfo?
    
    var description: String {
        return """
        --------------------------------------
        
        | Play Time |
            \(String(format: "%.2d", Int(playTime/60))):\(String(format: "%.2d", Int(playTime)%60)).\(Int(round(playTime*100))%100) sec
        | Gaze Info |
            Poisition           : \(gazeInfo?.positionDescription ?? "None")
            Tracking State      : \(gazeInfo?.trackingState.description ?? "None")
            Eye Movement State  : \(gazeInfo?.eyeMovementState.description ?? "None")
            Screen State        : \(gazeInfo?.screenState.description ?? "None")
        | Emotion Info |
            Prediction State    : \(emotionInfo?.emotionPredictionState.description ?? "None")
            Prediction Result   :
        \(emotionInfo?.predictionDescription ?? "\tNone")
        --------------------------------------
        """
    }
    
    mutating func updateGazeInfo(with gazeInfo: VideoGazeInfo?) {
        self.gazeInfo = gazeInfo
    }
    
    mutating func updateEmotionInfo(with emotionInfo: EmotionInfo?) {
        self.emotionInfo = emotionInfo
    }
    
    mutating func updatePlayTime(with playTime: Float) {
        self.playTime = playTime
    }
}
