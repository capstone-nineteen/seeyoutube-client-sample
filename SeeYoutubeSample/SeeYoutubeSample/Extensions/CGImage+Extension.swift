//
//  CGImage+Extension.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/26.
//

import CoreGraphics

extension CGImage {
    func croppingDetectionBondingBox(to boundingBox: CGRect) -> CGImage? {
        let width = boundingBox.height * CGFloat(self.width)
        let height = boundingBox.width * CGFloat(self.height)
        let x = (1 - boundingBox.origin.y - boundingBox.height) * CGFloat(self.width)
        let y = boundingBox.origin.x * CGFloat(self.height)
        
        return self.cropping(to: CGRect(x: CGFloat(self.width) - (x+width),
                                        y: CGFloat(self.height) - (y+height),
                                        width: width,
                                        height: height))
    }
}
