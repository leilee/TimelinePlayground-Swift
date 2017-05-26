//
//  MovieClipView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 25/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class MovieClipView: UIView {
    
    override var frame: CGRect {
        didSet {
            print("didSetFrame: \(oldValue) -> \(frame)")
            
            if shouldReloadTile(oldFrame: oldValue, frame: frame) {
                reloadTile()
            }
            
            if selected {
                reloadSelectionBorder()
            }
        }
    }
    
    var selected = false {
        didSet {
            selected ? applySelectionStyle() : applyUnselectionStyle()
        }
    }
    
    let clip: MovieClip
    let borderImageView: UIImageView
    var tileViews = [TileView]()

    init(frame: CGRect, clip: MovieClip) {
        self.clip = clip
        borderImageView = UIImageView(image: #imageLiteral(resourceName: "clip_selection"))
        
        super.init(frame: frame)
        
        clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        addGestureRecognizer(tap)
        
        reloadTile()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieClipView {
    
    func tapAction(sender: UITapGestureRecognizer) {
        print("\(#function), state: \(sender.state.description)")
        selected = !selected
    }
    
    func applySelectionStyle() {
        borderImageView.frame = CGRect(origin: .zero, size: frame.size)
        addSubview(borderImageView)
    }
    
    func applyUnselectionStyle() {
        borderImageView.removeFromSuperview()
    }
    
    func reloadSelectionBorder() {
        bringSubview(toFront: borderImageView)
        borderImageView.frame = CGRect(origin: .zero, size: frame.size)
    }
}

extension MovieClipView {
    
    func reloadTile() {
        let tileHeight = frame.height
        let tileWidth = tileHeight * CGFloat(Layout.tileRatio)
        let tileCount = self.tileCount(frame: frame)
        let currentTileCount = tileViews.count
        
        if (tileCount > currentTileCount) {
            for _ in 0..<tileCount - currentTileCount {
                let rect = CGRect(origin: .zero, size: CGSize(width: tileWidth, height: tileHeight))
                let tileView = TileView(frame: rect)
                addSubview(tileView)
                tileViews.append(tileView)
            }
        } else {
            for _ in 0..<currentTileCount - tileCount {
                tileViews.removeLast().removeFromSuperview()
            }
        }
        
        // set frame
        var offsetX: CGFloat = 0.0
        for tileView in tileViews {
            tileView.frame = CGRect(x: offsetX, y: 0.0, width: tileWidth, height: tileHeight)
            offsetX += tileWidth
        }
        
        // set image
        tileViews.first?.image = clip.firstThumbnail
        if tileViews.count > 1 {
            tileViews.last?.image = clip.lastThumbnail
            for i in 1..<tileViews.count - 1 {
                let percentage = Double(i) / Double(tileViews.count)
                tileViews[i].image = clip.thumbnail(for: percentage)
            }
        }
    }
    
    func shouldReloadTile(oldFrame: CGRect, frame: CGRect) -> Bool {
        return tileCount(frame: oldFrame) != tileCount(frame: frame)
    }
    
    func tileCount(frame: CGRect) -> Int {
        let tileHeight = frame.height
        let tileWidth = tileHeight * CGFloat(Layout.tileRatio)
        return Int(ceil(frame.width / tileWidth))
    }
}
