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
    static let tileRatio = 16.0 / 9.0
    static let tileSize = CGSize(width: Int(Double(movieTrackHeight) * tileRatio), height: movieTrackHeight) // 16:9
    static let transitionSize = CGSize(width: 60, height: 90)
}

enum Direction {
    case left, right
    
    func isIncrease(offset: CGFloat) -> Bool {
        switch self {
        case .left: return offset < 0
        case .right: return offset > 0
        }
    }
}

extension UIGestureRecognizerState {
    var description: String {
        switch self {
        case .began: return "began"
        case .cancelled: return "cancelled"
        case .possible: return "possible"
        case .changed: return "changed"
        case .ended: return "ended"
        case .failed: return "failed"
        }
    }
}

private let panningWidth: CGFloat = 20

extension CGPoint {
    
    func insideLeftPanningArea(of rect: CGRect) -> Bool {
        return x < panningWidth
    }
    
    func insideRightPanningArea(of rect: CGRect) -> Bool {
        return x > rect.width - panningWidth
    }
    
    func insidePanningArea(of rect: CGRect) -> Bool {
        return insideLeftPanningArea(of: rect) || insideRightPanningArea(of: rect)
    }
    
}
