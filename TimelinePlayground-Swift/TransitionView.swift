//
//  TransitionView.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 26/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class TransitionView: UIView {

    private var transitionButton: UIButton
    
    override init(frame: CGRect) {
        transitionButton = UIButton(type: .custom)
        
        super.init(frame: frame)
        
        transitionButton.frame = frame
        transitionButton.setImage(#imageLiteral(resourceName: "transition_icon"), for: .normal)
        self.addSubview(transitionButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
