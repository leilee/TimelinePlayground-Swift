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
        }
    }
    
    let clip: MovieClip

    init(frame: CGRect, clip: MovieClip) {
        self.clip = clip
        
        super.init(frame: frame)
        
        clipsToBounds = true
        
        reloadTile()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieClipView {
    
    func reloadTile() {
        let tileHeight = frame.height
        let tileWidth = tileHeight * CGFloat(Layout.tileRatio)
        let tileCount = self.tileCount(frame: frame)
        var offsetX: CGFloat = 0.0
        var tileViews = [TileView]()
        
        for _ in 0..<tileCount {
            let rect = CGRect(x: offsetX, y: 0.0, width: tileWidth, height: tileHeight)
            let tileView = TileView(frame: rect)
            addSubview(tileView)
            tileViews.append(tileView)
            offsetX += tileWidth
        }
        
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
