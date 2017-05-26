//
//  MovieTrackView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class MovieTrackView: UIView {
    
    let viewModel: MovieTrackViewModel
    var clipViews = [MovieClipView]()
    var transitionViews = [TransitionView]()
    
    // TODO: frame 应该由哪个模块负责计算
    
    init(viewModel: MovieTrackViewModel) {
        self.viewModel = viewModel
        
        let frame = CGRect(x: 0, y: 0, width: viewModel.minContentWidth(with: Layout.movieTrackHeight), height: Layout.movieTrackHeight)
        
        super.init(frame: frame)
        
        var offsetX = Layout.movieTrackHorizontalPadding
        
        for movieClip in viewModel.movieClips {
            let clipFrame = CGRect(x: offsetX, y: 0, width: Layout.minMovieClipWidth, height: Layout.movieTrackHeight)
            let clipView = MovieClipView(frame: clipFrame, clip: movieClip)
            clipViews.append(clipView)
            addSubview(clipView)
            
            offsetX += Layout.minMovieClipWidth
            
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
