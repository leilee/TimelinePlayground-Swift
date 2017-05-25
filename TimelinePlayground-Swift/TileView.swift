//
//  TileView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 25/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class TileView: UIView {

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    private var imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        super.init(frame: frame)
        addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
