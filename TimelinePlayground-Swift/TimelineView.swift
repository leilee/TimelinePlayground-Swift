//
//  TimelineView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class TimelineView: UIScrollView {
    
    var pan: UIPanGestureRecognizer!
    var trackView: MovieTrackView!
    var draggingView: UIView?
    var panningView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let viewModel = MovieTrackViewModel(clipCount: 2)
        trackView = MovieTrackView(viewModel: viewModel)
        
        addSubview(trackView)
        var frame = trackView.frame
        frame.origin = CGPoint(x: 0, y: 100)
        trackView.frame = frame
        contentSize = trackView.frame.size
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        addGestureRecognizer(pinch)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
        addGestureRecognizer(longPress)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tap)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }

}

extension TimelineView: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == pan {
            return trackView.pannableView(at: gestureRecognizer.location(in: trackView)) != nil
        }
        return true
    }
    
}

// MARK: - Gesture Action

extension TimelineView {
    
    func pinchAction(sender: UIPinchGestureRecognizer) {
        print("\(#function), state: \(sender.state.description), scale: \(sender.scale), velocity: \(sender.velocity)")
        
        switch sender.state {
        case .began: trackView.beginScale()
        case .ended, .cancelled, .failed: trackView.endScale()
        case .changed:
            trackView.applyScale(sender.scale) { [unowned self] size in
                self.contentSize = size
            }
        default: break
        }
    }
    
    func longPressAction(sender: UILongPressGestureRecognizer) {
        let point = sender.location(in: self)
        let trackPoint = sender.location(in: trackView)
        print("\(#function), \(point), \(trackPoint)")
        
        switch sender.state {
        case .began:
            if shouldBeginDrag(with: sender) {
                beginDrag(trackView.draggableView(at: trackPoint)!, at: point)
            }
        case .ended, .cancelled, .failed: endDrag(at: point)
        case .changed: drag(to: point, animated: false)
        default: break
        }
    }
    
    func panAction(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began: beginPan(trackView.pannableView(at: sender.location(in: trackView))!, with: sender)
        case .ended, .cancelled, .failed: endPan()
        case .changed: pan(with: sender)
        default: break
        }
    }
    
    func tapAction(sender: UITapGestureRecognizer) {
        print("\(#function), \(sender)")
        if sender.state == .ended {
            if let v = trackView.tappableView(at: sender.location(in: trackView)) {
                trackView.applyTap(v)
            } else {
                trackView.clearAllTap()
            }
        }
    }
}

// MARK: - Drag

extension TimelineView {
    
    func shouldBeginDrag(with gesture: UILongPressGestureRecognizer) -> Bool {
        let point = gesture.location(in: trackView)
        return trackView.draggableView(at: point) != nil
    }
    
    func beginDrag(_ view: UIView, at point: CGPoint) {
        draggingView = view
        
        let frame = trackView.convert(view.frame, to: self)
        trackView.removeDraggableView(view)
        addSubview(view)
        view.frame = frame
        
        drag(to: point, animated: true)
    }
    
    func endDrag(at point: CGPoint) {
        guard let v = draggingView else {
            return
        }
        
        v.removeFromSuperview()
        trackView.addDraggableView(v)
        
        draggingView = nil
    }
    
    func drag(to point: CGPoint, animated: Bool) {
        guard let v = draggingView else {
            return
        }
        
        let duration = animated ? 0.25 : 0
        UIView.animate(withDuration: duration) { 
            v.center = point
        }
    }
}

// MARK: - Pan

extension TimelineView {
    
    func beginPan(_ view: UIView, with gesture: UIPanGestureRecognizer) {
        panningView = view
        trackView.beginPan(view, with: gesture)
    }
    
    func endPan() {
        panningView = nil
        trackView.endPan()
    }
    
    func pan(with gesture: UIPanGestureRecognizer) {
        trackView.applyPan(panningView!, with: gesture) { size in
            self.contentSize = size
        }
    }
}
