//
//  MovieClipView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 25/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class MovieClipView: UIView {
    
    enum Layout {
        static let ratio = CGFloat(16.0 / 9.0)
    }
    
    let clip: MovieClip

    init(frame: CGRect, clip: MovieClip) {
        self.clip = clip
        
        super.init(frame: frame)
        
        let tileHeight = frame.height
        let tileWidth = tileHeight * Layout.ratio
        let tileCount = Int(ceil(frame.width / tileWidth))
        var offsetX: CGFloat = 0.0
        
        for i in 0..<tileCount {
            let rect = CGRect(x: offsetX, y: 0.0, width: tileWidth, height: tileHeight)
            let tileView = TileView(frame: rect)
            let percentage = Double(i) / Double(tileCount)
            tileView.image = clip.thumbnail(for: percentage)
            addSubview(tileView)
            offsetX += tileWidth
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
