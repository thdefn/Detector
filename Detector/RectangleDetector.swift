//
//  RectangleDetector.swift
//  Detector
//
//  Created by 송원선 on 2022/01/15.
//

import Foundation
import CoreImage

class RectangleDetector{
    var detector: CIDetector = {
        let context = CIContext(options: [kCIContextUseSi : Any]?)
    }()
}
