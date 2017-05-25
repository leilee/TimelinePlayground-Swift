//
//  MovieClip.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 25/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import Foundation
import UIKit

struct MovieClip {
    let duration: TimeInterval
    let frameNumber: Int
    
    init() {
        frameNumber = 10
        duration = Double(arc4random()) / Double(RAND_MAX) * 4 + 1
    }
    
    func thumbnail(at moment: TimeInterval) -> UIImage {
        let ratio = moment / duration
        let index = Int(ratio * 10) % 10 + 1
        return UIImage(named: "\(index)")!
    }
    
    func thumbnail(for percentage: Double) -> UIImage {
        let index = Int(percentage * 10) % 10 + 1
        return UIImage(named: "\(index)")!
    }
}
