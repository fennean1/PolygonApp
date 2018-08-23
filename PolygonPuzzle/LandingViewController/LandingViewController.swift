//
//  LandingViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/23/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit
import Darwin

var numberOfSides = 3

class ShapeButton: UIButton {
    
    var n = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cx = frame.origin.x
        let cy = frame.origin.y
        self.center = CGPoint(x: cx, y: cy)
        self.frame.size = frame.size
        
        
    }
    
}

class ShapeMenu: UIView {
    
    
    
    
    
    func drawMe(){
        print("Draw called")
    }
    
    
    
    
}



class LandingViewController: UIViewController {
    
    var shapeButtons: [ShapeButton] = []
    var screenWidth: CGFloat = 0
    
    
    @objc func segueViewController(sender: ShapeButton){
        
        numberOfSides = sender.n
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    func initShapeButtons(r: CGFloat){
        
        print("Called to init shape buttons")
        
        let theta = 2*Double.pi/7
        
        // There are seven different shapes.
        for i in 0...6{
            
            let currentAngle = theta*Double(i) - Double.pi/2
            
            let _x = CGFloat(Double(r)*cos(currentAngle))
            let _y = CGFloat(Double(r)*sin(currentAngle))
            
            let newShapeButtonFrame = CGRect(x: _x+view.frame.width/2, y: _y+view.frame.height/2, width: r/2, height: r/2)
            
            let newShapeButton = ShapeButton(frame: newShapeButtonFrame)
            newShapeButton.n = i+3
            self.view.addSubview(newShapeButton)
            shapeButtons.append(newShapeButton)
            newShapeButton.setBackgroundImage(ShapesArray[i], for: .normal)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGround = UIImageView()
        view.addSubview(backGround)
        backGround.frame.styleFillContainer(container: view.frame)
        backGround.image = BackGround
  
        
        // Do any additional setup after loading the view, typically from a nib.
 
        print("view")
        
        screenWidth = view.frame.width
        
        let r = screenWidth/3
        
        self.initShapeButtons(r: r)
        
        for button in shapeButtons {
            button.addTarget(self, action: #selector(segueViewController(sender:)), for: .touchUpInside)
        }
        
 
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    
    
    
}

