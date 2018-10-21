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
 
 
 0) Start and End can't be the same point*
 
 1) Must be able to delete saved puzzle
 
 1) Bug where an endpoint is inside of the polygon but it still tried to clip to node. Might need a function that tells me
 if a point is on the border of the polygon. UPDATE: This appears to be resolved but keep an eye on it.
 
 2) Need support for when a cut occurs along a single edge (i.e. trying to cut parallel to an edge)
 
 3) Note: When a straight line is formed by the vertex and the endpoints
 
 4) Back Button needs to be active when cutting and also successfully reset when exited.
 
 5) Back button needs to save current cutting state for that view - need a different cutting state for each time the vc has been entered.
 
 6) Need to handle situation where the vertex & endpoints form a straight line. - Check the angle formed by the vertex and end points and if i'ts 180, revert to a straight line cut.
 
 7) Triangle is not centered.
 
 8) Handle case where StartOfCut = EndOfCut
 
 9) Border color has to match color for tens place
 
 10) Should be able to flip polygons in design view. - Polygons need to store whether or not their flipped and also the angle
 
 11) Should be able to save tanagram as wireframe to phone.
 
 12) Watch out for the issue where the cutting line hangs around - really not sure why this happens.
 
 13) When two points are extremely close, remove one of them.
 
 14) When the puzzle is put together we need to make sure that the rotation is also zero. A piece could have an origin in the right spot
 but it's rotated the wrong way.
 
 */

// ------------- Concerns ----------------

/*
 
 Currently using "remove duplicate nodes" to fix  - not sure if this is safer or more dangerous.
 
 UPDATE: No issues yet.
 
 */


import Foundation
import UIKit
import Darwin


class EntryPointViewController: UIViewController {
    
    var shapeButtons: [ShapeButton] = []
    var segueToDesignViewController = UIButton()
    var segueToPuzzleViewController = UIButton()
    var backGround = UIImageView()
    
    var optionSolve = OptionButton()
    var optionCreate = OptionButton()
    var optionDesign = OptionButton()
    
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
    
    @objc func segueToPuzzleViewController(sender: UIButton){
        print("segue to PuzzleViewController")
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "PuzzleViewController")
        
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
        

        view.addSubview(optionSolve)
        optionSolve.frame.styleOptionButton(order: 1, container: view.frame)
        
        
        
        // Init
        
        
        
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
        view.addSubview(segueToPuzzleViewController)
        
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
        
        view.bringSubview(toFront: segueToDesignViewController)
        view.bringSubview(toFront: segueToPuzzleViewController)
        
        
        /*
         if firstLoad() {
         loadRawPuzzlesToCoreData()
         }
         */
        
        if let p = fetchAllPuzzles() {
            FetchedPuzzles = p
            puzzleCollectionViewDataSource = initPuzzleCollectionViewDataSource(puzzles: p,dim: 250)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
}

