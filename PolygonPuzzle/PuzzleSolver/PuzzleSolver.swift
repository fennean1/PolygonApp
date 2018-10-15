//
//  TestingViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/9/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

class PuzzleSolver: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let backGround = UIImageView()
            view.addSubview(backGround)
            backGround.image = BackGround
            backGround.frame.styleFillContainer(container: view.frame)
            view.sendSubview(toBack: backGround)
        
        
        
        for p in AllPolygons {
            view.addSubview(p)
            p.center = view.center
        }
    
        
        
        
    }
    
    
    
}
