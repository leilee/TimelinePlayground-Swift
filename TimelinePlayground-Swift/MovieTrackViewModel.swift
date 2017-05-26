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
    
    func maxContentWidth() -> Int {
        let tileWidth = Int(Layout.tileSize.width)
        let totalClipWidth = movieClips.reduce(0) { $0 + $1.frameNumber * tileWidth }
        let totalTransitionWidth = Int(Layout.transitionSize.width) * (movieClips.count - 1)
        return Layout.movieTrackHorizontalPadding * 2 + totalClipWidth + totalTransitionWidth
    }
    
    func minContentWidth() -> Int {
        return Layout.movieTrackHorizontalPadding * 2 +
            Layout.minMovieClipWidth * movieClips.count +
            Int(Layout.transitionSize.width) * (movieClips.count - 1)
        
    }
    
}
