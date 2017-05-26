//
//  ViewController.swift
//  TimelinePlayground-Swift
//
//  Created by edison on 25/05/2017.
//  Copyright © 2017 edison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var trackView: MovieTrackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = MovieTrackViewModel(clipCount: 2)
        trackView = MovieTrackView(viewModel: viewModel)
        
        scrollView.addSubview(trackView)
        scrollView.contentSize = trackView.frame.size
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(sender:)))
        scrollView.addGestureRecognizer(pinch)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func pinchAction(sender: UIPinchGestureRecognizer) {
        print("\(#function), state: \(sender.state.description), scale: \(sender.scale), velocity: \(sender.velocity)")
        
        switch sender.state {
        case .began: trackView.beginScale()
        case .ended: trackView.endScale()
        case .changed:
            trackView.applyScale(sender.scale) { [unowned self] size in
                self.scrollView.contentSize = size
            }
        default: break
        }
    }
}

