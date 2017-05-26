//
//  MovieTrackView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class MovieTrackView: UIView {
    
    enum DisplayMode {
        case minimum, maximum
        
        func trackWidth(viewModel: MovieTrackViewModel) -> Int {
            switch self {
            case .minimum:
                return viewModel.minContentWidth()
            case .maximum:
                return viewModel.maxContentWidth()
            }
        }
        
        func clipWidth(clip: MovieClip) -> Int {
            switch self {
            case .minimum:
                return Layout.minMovieClipWidth
            case .maximum:
                return  clip.frameNumber * Int(Layout.tileSize.width)
            }
        }
    }
    
    let mode = DisplayMode.maximum
    
    let viewModel: MovieTrackViewModel
    var clipViews = [MovieClipView]()
    var transitionViews = [TransitionView]()
    
    // TODO: frame 应该由哪个模块负责计算
    
    init(viewModel: MovieTrackViewModel) {
        self.viewModel = viewModel
        
        let frame = CGRect(x: 0, y: 0, width: mode.trackWidth(viewModel: viewModel), height: Layout.movieTrackHeight)
        
        super.init(frame: frame)
        
        var offsetX = Layout.movieTrackHorizontalPadding
        
        for movieClip in viewModel.movieClips {
            let clipFrame = CGRect(x: offsetX, y: 0, width: mode.clipWidth(clip: movieClip), height: Layout.movieTrackHeight)
            let clipView = MovieClipView(frame: clipFrame, clip: movieClip)
            clipViews.append(clipView)
            addSubview(clipView)
            
            offsetX += mode.clipWidth(clip: movieClip)
            
            let transitionFrame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: Layout.transitionSize)
            let transitionView = TransitionView(frame: transitionFrame)
            transitionViews.append(transitionView)
            addSubview(transitionView)
            
            offsetX += Int(Layout.transitionSize.width)
        }
        
        let lastTransitionView = transitionViews.popLast()
        lastTransitionView?.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MovieTrackView {
    
    func applyScale(_ scale: CGFloat) {
        
    }
}
