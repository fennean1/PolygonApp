//
//  LandingViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/23/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//


// ----------- Action Items --------------


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
    var segueToPuzzleViewController = UIButton()
    var backGround = UIImageView()

    var screenWidth: CGFloat = 0
    
    
    var backButton = UIButton()
    
    
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
    
    @objc func segueToPuzzleViewController(sender: UIButton){
        print("segue to PuzzleViewController")
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PuzzleViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    @objc func goBack(sender: UIButton) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "EntryPointViewController")
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
        
        
        InitialPolygonDim = 0.8*view.frame.width
        ViewControllerFrame = view.frame

        backGround.image = BackGround
        screenWidth = view.frame.width
        let r = screenWidth/3

        segueToPuzzleViewController.setImage(PuzzleIcon, for: .normal)
        segueToDesignViewController.setImage(PalleteIcon, for: .normal)
        
        // Add Views
        
        view.addSubview(segueToDesignViewController)
        view.addSubview(backGround)
   
        // Style
        
        backGround.frame.styleFillContainer(container: view.frame)
        segueToDesignViewController.frame.size = CGSize(width: r/2, height: r/2)
        segueToDesignViewController.center = view.center
        segueToPuzzleViewController.frame.styleBottomRight(container: view.frame)
        
        // State
        
        self.initShapeButtons(r: r)
        
        for button in shapeButtons {
            button.addTarget(self, action: #selector(segueGameViewController(sender:)), for: .touchUpInside)
        }
        
        segueToDesignViewController.addTarget(self, action: #selector(segueToDesignViewController(sender:)), for: .touchUpInside)
        segueToPuzzleViewController.addTarget(self, action: #selector(segueToPuzzleViewController(sender:)), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
        view.bringSubview(toFront: segueToPuzzleViewController)
        

        
        view.addSubview(backButton)
        backButton.frame.styleTopLeft(container: view.frame)
        backButton.setImage(BackImage, for: .normal)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}

