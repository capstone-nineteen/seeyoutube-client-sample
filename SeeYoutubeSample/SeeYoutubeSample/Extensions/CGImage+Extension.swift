//
//  CGImage+Extension.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/26.
//

import CoreGraphics

extension CGImage {
    func croppingDetectionBondingBox(to boundingBox: CGRect) -> CGImage? {
        let width = boundingBox.width * CGFloat(self.width)
        let height = boundingBox.height * CGFloat(self.height)
        let x = boundingBox.origin.x * CGFloat(self.width)
        let y = (1 - boundingBox.origin.y - boundingBox.height) * CGFloat(self.height)
        
        return self.cropping(to: CGRect(x: x,
                                        y: y,
                                        width: width,
                                        height: height))
    }
}
