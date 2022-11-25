//
//  Bundle+eExtension.swift
//  SeeYoutubeSample
//
//  Created by 최수정 on 2022/11/25.
//

import Foundation

extension Bundle {
    var SEESO_LICENSE_KEY: String? {
        guard let file = self.path(forResource: "LicenseKey", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["SEESO_LICENSE_KEY"] as? String else { return nil }
        return key
    }
}
