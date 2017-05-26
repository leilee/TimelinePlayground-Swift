//
//  MovieTrackViewModel.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import Foundation
import UIKit

struct MovieTrackViewModel {
    
    // TODO: transitions
    
    var movieClips: [MovieClip]
    
    init(clipCount: UInt) {
        movieClips = [MovieClip]()
        for _ in 0..<clipCount {
            movieClips.append(MovieClip())
        }
    }
}

extension MovieTrackViewModel {
    
    func maxContentWidth(with height: Int) -> Int {
        return 0
    }
    
    func minContentWidth(with height: Int) -> Int {
        return 0
    }
    
}
