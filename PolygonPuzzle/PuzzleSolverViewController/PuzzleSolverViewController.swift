//
//  TestingViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 10/9/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

func putAllPolygonsTogether() {
    
    if validatePuzzle(polygons: AllPolygons) {
    
    let x = ViewControllerFrame.width/2 - InitialPolygonDim/2
    let y = ViewControllerFrame.height/2 - InitialPolygonDim/2
    let computedOrigin = CGPoint(x: x, y: y)
    assemblePolygons(at: computedOrigin)
    
    }
}

func assemblePolygons(at point: CGPoint) {
    
    UIView.animate(withDuration: 1, animations: {
        for p in AllPolygons {
            p.frame.origin = addPoints(a: point, b: p.originalOrigin)
        }
    })
}

class PuzzleSolver: UIViewController {
    
    let backButton = UIButton()
    
    @objc func goBack(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PuzzleViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.bringSubview(toFront: ActivePolygon)
            //animatedNumber.render(n: ActivePolygon.nodes!.count)
            //UIView.animate(withDuration: 0.5, animations: {
            //self.animatedNumber.center = CGPoint(x: self.view.center.x, y:  2*self.numberDim)})

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let backGround = UIImageView()
            view.addSubview(backGround)
            backGround.image = BackGround
            backGround.frame.styleFillContainer(container: view.frame)
            view.sendSubview(toBack: backGround)
        
            view.addSubview(backButton)
        
            backButton.frame.styleTopLeft(container: view.frame)
            backButton.setImage(BackImage, for: .normal)
        
            backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
        for p in AllPolygons {
            view.addSubview(p)
            p.AutoCheck = true
            p.center = view.center
        }
    }
}
