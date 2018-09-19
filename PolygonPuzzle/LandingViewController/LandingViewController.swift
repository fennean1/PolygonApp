//
//  LandingViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/23/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//


// ----------- Action Items --------------

/*
 
 
NEXT) Make it so that the button views get added again
NEXT) Shrink the undo button and make it animate!
 
 
 1) Bug where an endpoint is inside of the polygon but it still tried to clip to node. Might need a function that tells me
 if a point is on the border of the polygon
 
 2) Need to be able to cancel any cut.
 
 3) Hitting the cut button at any time will exit without failure.
 
 4) Characters on landing screen as well as on cutting view.
 
 5) Third dot goes away after cut.
 
 6) Disallow cutting after second cut has been made.
 
 7) Puzzle needs to detect when it's put together. (Sister nodes)
 
 8) Need support for when a cut crosses a gap. How?
 
 9) Note: When a straight line is formed by the vertex and the endpoints
 
 10) Back Button needs to be active when cutting and also successfully reset when exited.
 
 11) Back button needs to save current cutting state for that view - need a different cutting state for each time the vc has been entered. 
 
 */

// ------------- Concerns ----------------

/*
 
 1) VertexOfCut variable is a nuissance - not quite. Letting start and end points be seperate from vertex but will add a vertex array when we do multiple zigs.
 
 2) Currently using "remove duplicate nodes" to fix  - not sure if this is safer or more dangerous
 
 */


 // NEXT: WRITE CODE TO RETAIN PUZZLES UPON EXIT AND ENTRANCE

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


class LandingViewController: UIViewController {
    
    var shapeButtons: [ShapeButton] = []
    var segueToDesignViewController = UIButton()
    var backGround = UIImageView()

    var screenWidth: CGFloat = 0
    
    
    @objc func segueGameViewController(sender: ShapeButton){
        print("segue to GameViewController")
        numberOfSides = sender.n
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "GameViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    @objc func segueToDesignViewController(sender: UIButton){
        print("segue to DesignViewController")

        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "DesignViewController")
        
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
        
        print("LandingViewController,viewDidLoad")
        
        // Init
        
        backGround.image = BackGround
        screenWidth = view.frame.width
        let r = screenWidth/3

        segueToDesignViewController.setImage(DesignButtonImage, for: .normal)
        
        // Add Views
        
        view.addSubview(segueToDesignViewController)
        view.addSubview(backGround)
        
        // Style
        
        backGround.frame.styleFillContainer(container: view.frame)
        segueToDesignViewController.frame.size = CGSize(width: r/2, height: r/2)
        segueToDesignViewController.center = view.center
        
        // State
        
        
        self.initShapeButtons(r: r)
        
        for button in shapeButtons {
            button.addTarget(self, action: #selector(segueGameViewController(sender:)), for: .touchUpInside)
        }
        
        segueToDesignViewController.addTarget(self, action: #selector(segueToDesignViewController(sender:)), for: .touchUpInside)
        
        view.bringSubview(toFront: segueToDesignViewController)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}

