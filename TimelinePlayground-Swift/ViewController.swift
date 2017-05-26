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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = MovieTrackViewModel(clipCount: 2)
        let trackView = MovieTrackView(viewModel: viewModel)
        
        scrollView.addSubview(trackView)
        scrollView.contentSize = trackView.frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

