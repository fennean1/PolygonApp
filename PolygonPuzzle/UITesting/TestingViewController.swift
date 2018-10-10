//
//  TestingViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/9/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

class TestingViewController: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        for f in FetchedPolygons {
            
            view.addSubview(f)
            f.frame.origin = f.originalOrigin
            
        }

        
        
    }
    
    
    
}
