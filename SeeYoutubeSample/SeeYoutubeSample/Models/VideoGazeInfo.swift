//
//  VideoGazeInfo.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/26.
//

import Foundation
import SeeSo

struct VideoGazeInfo {
    private let xInPlayerCoordinate: Double
    private let yInPlayerCoordinate: Double
    private let seesoGazeInfo: GazeInfo
    
    var x: Double { return self.xInPlayerCoordinate }
    var y: Double { return self.yInPlayerCoordinate }
    var timestamp: Double { return self.seesoGazeInfo.timestamp }
    var trackingState: TrackingState { return self.seesoGazeInfo.trackingState }
    var eyeMovementState: EyeMovementState { return self.seesoGazeInfo.eyeMovementState }
    var screenState: ScreenState { return self.seesoGazeInfo.screenState }
    
    var positionDescription: String {
        return "(\(String(format: "%.2f", self.x)), \(String(format: "%.2f", self.y)))"
    }
    
    init?(gazeInfo: GazeInfo?, playerOrigin: CGPoint) {
        guard let gazeInfo = gazeInfo else { return nil }
        self.xInPlayerCoordinate = gazeInfo.x - playerOrigin.x
        self.yInPlayerCoordinate = gazeInfo.y - playerOrigin.y
        self.seesoGazeInfo = gazeInfo
    }
}
