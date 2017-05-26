//
//  MovieClipView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 25/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class MovieClipView: UIView {
    
    let clip: MovieClip

    init(frame: CGRect, clip: MovieClip) {
        self.clip = clip
        
        super.init(frame: frame)
        
        let tileHeight = frame.height
        let tileWidth = tileHeight * Layout.tileRatio
        let tileCount = Int(ceil(frame.width / tileWidth))
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
