//
//  Defines.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import Foundation
import UIKit

let screenBounds = UIScreen.main.bounds

struct Layout {
    static let movieTrackHeight = 90
    static let movieTrackHorizontalPadding = Int(screenBounds.width / 2)
    static let minMovieClipWidth = 90
    static let transitionSize = CGSize(width: 90, height: 90)
    static let tileRatio = CGFloat(16.0 / 9.0)
}
