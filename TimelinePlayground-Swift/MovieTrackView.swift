//
//  MovieTrackView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

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

class MovieTrackView: UIView {
    
    let mode = DisplayMode.minimum
    
    let viewModel: MovieTrackViewModel
    var clipViews = [MovieClipView]()
    var transitionViews = [TransitionView]()
    var referenceClipFrames = [CGRect]()
    var dragFrame = CGRect.zero
    
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

// MARK: - Scale

extension MovieTrackView {
    
    func beginScale() {
        referenceClipFrames = clipViews.map { $0.frame }
    }
    
    func endScale() {
        referenceClipFrames.removeAll()
    }
    
    typealias ScaleCompletion = (CGSize) -> Void
    
    func applyScale(_ scale: CGFloat, completion: ScaleCompletion? = nil) {
        if scale > 1 && reachedMaxScale {
            return
        }
        
        if scale < 1 && reachedMinScale {
            return
        }
        
        guard clipViews.count == referenceClipFrames.count else {
            assertionFailure("clip view count & frame count mismatch")
            return
        }
        
        let minScaledWidth = CGFloat(Layout.minMovieClipWidth)
        var offsetX = CGFloat(Layout.movieTrackHorizontalPadding)
        var contentWidth = CGFloat(2 * Layout.movieTrackHorizontalPadding)
        
        // reset clipViews & transitionViews frame
        for i in 0..<clipViews.count {
            let clipView = clipViews[i]
            let referenceFrame = referenceClipFrames[i]
            let maxScaledWidth = CGFloat(viewModel.movieClips[i].frameNumber) * Layout.tileSize.width
            let clipFrame = CGRect(
                origin: CGPoint(x: offsetX, y: 0),
                size: scaleSize(size: referenceFrame.size, scale: scale, upperLimitWidth: maxScaledWidth, lowerLimitWidth: minScaledWidth))
            clipView.frame = clipFrame
            
            offsetX += clipFrame.width
            contentWidth += clipFrame.width
            
            if i != clipViews.count - 1 {
                let transitionView = transitionViews[i]
                let transitionFrame = CGRect(origin: CGPoint(x: offsetX, y: 0), size: transitionView.frame.size)
                transitionView.frame = transitionFrame
                
                offsetX += transitionFrame.width
                contentWidth += transitionFrame.width
            }
        }
        
        // reset trackView frame
        frame = CGRect(origin: frame.origin, size: CGSize(width: contentWidth, height: frame.height))
        
        completion?(frame.size)
    }
    
    func scaleSize(size: CGSize, scale: CGFloat, upperLimitWidth: CGFloat, lowerLimitWidth: CGFloat) -> CGSize {
        var scaledWidth = size.width * scale
        scaledWidth = max(scaledWidth, lowerLimitWidth)
        scaledWidth = min(scaledWidth, upperLimitWidth)
        
        return CGSize(width: scaledWidth, height: size.height)
    }
    
    var reachedMaxScale: Bool {
        return Int(frame.width) >= viewModel.maxContentWidth()
    }
    
    var reachedMinScale: Bool {
        return Int(frame.width) <= viewModel.minContentWidth()
    }
}

// MARK: - Drag

extension MovieTrackView {
    
    // TODO: protocol draggable
    
    func draggableView(at point: CGPoint) -> UIView? {
        let viewsAtPoint = clipViews.filter { $0.frame.contains(point) }
        
        if viewsAtPoint.count > 1 {
            assertionFailure("attempt to get 0 or 1 view at point \(point), but get \(viewsAtPoint.count)")
            return nil
        }
        
        return viewsAtPoint.first
    }
    
    func removeDraggableView(_ view: UIView) {
        dragFrame = view.frame
        view.removeFromSuperview()
    }
    
    func addDraggableView(_ view: UIView) {
        addSubview(view)
        view.frame = dragFrame
    }
}

// MARK: - Tap

extension MovieTrackView {
    
    // TODO: protocol tappable
    
    func tappableView(at point: CGPoint) -> UIView? {
        let viewsAtPoint = clipViews.filter { $0.frame.contains(point) }
        
        if viewsAtPoint.count > 1 {
            assertionFailure("attempt to get 0 or 1 view at point \(point), but get \(viewsAtPoint.count)")
            return nil
        }
        
        return viewsAtPoint.first
    }
    
    func applyTap(_ view: UIView) {
        clearAllTap()
        (view as! MovieClipView).selected = true
    }
    
    func clearAllTap() {
        clipViews.forEach { $0.selected = false }
    }
    
}
