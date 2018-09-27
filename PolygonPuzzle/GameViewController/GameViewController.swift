//
//  ViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/18/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import UIKit
import Foundation


var currentPuzzle: PuzzleStruct!

var InitialPolygonDim: CGFloat!

class GameViewController: UIViewController {
    
    
    // Polygon is 80% of the frame width. (What about landscape mode? - Not Supporting Yet)
    var viewFrame: CGRect? = nil
    var polygonWidth: CGFloat? = nil
    var polygonHeight: CGFloat? = nil
    var polygonRadius: CGFloat? = nil

    // I really don't need this custom init.
    var animatedNumber = NumberFrame(n: 6, dim: 100)
    var numberDim: CGFloat = 0

    let cuttingView = CuttingView()
    var parachute: Parachute!
    var polygons: [DraggablePolygon] = []
    var saveButton = UIButton()
    var printButton = UIButton()
    
    @objc func printPuzzle(sender: UIButton) {
        saveAllPolygonsToPhotos()
        parachute.setText(message: "Puzzle Saved To Photos")
        parachute.showParachute()
    }
    
    @objc func savePuzzle(sender: UIButton){
        // How do we check for duplicates here? - We don't? Oh we need support for extras. Polygon Needs "Polygon ID"

        SavedPolygons.append(ActivePolygon)
        
        print("validating all sisters",validateAllSisters())
        
        printAllSisters()
        
        if validateAllSisters() {
            parachute.setText(message: "Puzzle Solved, Polygon Saved.")
        } else
        {
            parachute.setText(message: "Puzzle Not Solved, Polygon Saved.")
        }

        parachute.showParachute()
    }
    
    func showUndoButton(){
        view.bringSubview(toFront: undoButton)

        
        UIView.animate(withDuration: 0.5, animations: {undoButton.frame.styleUnderTopRight(container: self.view.frame)
            undoButton.alpha = 1
        })
    }
    
    func hideUndoButton(){
        UIView.animate(withDuration: 0.5, animations: {
            undoButton.frame.styleTopRight(container: self.view.frame)
            undoButton.alpha = 0})
    }
    
    // This doesn't end ActivelyCutting.
    func resetCutting(){
        ValidCutHasBeenMade = false
        StartOfCut = nil
        EndOfCut = nil
        VertexOfTheCut = nil
        CuttingViewNeedsClearing = true
        cuttingView.setNeedsDisplay()
        markerOne.frame.styleHideMarker(container: view.frame)
        markerTwo.frame.styleHideMarker(container: view.frame)
        markerThree.frame.styleHideMarker(container: view.frame)
    }
    

    @IBOutlet weak var backButton: UIButton!

    
    @objc func goBack(sender: UIButton) {
        print("Back Clicked")
        
        print("All Polygon count after resetting inside goBack",AllPolygons.count)
        
        ActivelyCutting = false
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "LandingViewController")
        self.show(vc as! UIViewController, sender: vc)
        
    }
    
    
    @objc func cutOrCancel(sender: UIButton){
        
        print("How many times was cut or cancel called?")
        
        // Needs to be in front of the "invisible" cutting view
        view.bringSubview(toFront: cuttingView)
        view.bringSubview(toFront: cutOrCancelButton)
        view.bringSubview(toFront: undoButton)
        view.bringSubview(toFront: markerOne)
        view.bringSubview(toFront: markerTwo)
        view.bringSubview(toFront: markerThree)
        view.bringSubview(toFront: parachute)
        // There will now be many markers... need "addMarkerToNodes(nodes: [Node])" function
        
        /* Need to get the polygon origin so we can convert its points to
         the coordinates of the containing view */
        let polygonOrigin = AllPolygons[ActivePolygonIndex].frame.origin
        print("polygonOrigin",polygonOrigin)
        
        // Get coordinates in the main view.
        let nodesForLines = mapPointsWithOffset(offSet: polygonOrigin, points: AllPolygons[ActivePolygonIndex].vertices())
        LinesToCut = makeLinesFromPoints(points: nodesForLines)

        // NEED TO CHECK IF VALID CUT HAS BEEN MADE TO DETERMINE WHETHER A CLICK CANCELS EVERYTHING
        
        // Go add the line on dragEnded to change the image to a check mark when valid cut has been made (maybe use did set on ValidCutHasBeenMade?
        
        if !ActivelyCutting {
            ActivelyCutting = true
            showUndoButton()
            CuttingViewNeedsClearing = false
            hideInactivePolygons()
        }
        // Ends the cut entirely.
        else if ActivelyCutting {
   
            returnPolygonsToView()
            
            hideUndoButton()
            
            UIView.animate(withDuration: 1, animations:
            {
                markerOne.frame.styleHideMarker(container: self.view.frame)
                markerTwo.frame.styleHideMarker(container: self.view.frame)
                markerThree.frame.styleHideMarker(container: self.view.frame)
            })
            
            //cuttingView.setNeedsDisplay()

            // Can I replace this with "ValidCutHasBeenMade? - I think so and it would make more sense.
            guard StartOfCut != nil && EndOfCut != nil else {
                print("GUARD FAILED!")
                resetCutting()
                ActivelyCutting = false
                return
            }
            
            let origin = ActivePolygon.frame.origin
            let nodes = ActivePolygon.nodes
            
            // This converts the nodes to the main coordinate system - need to write a function for this.
            let transformedNodes = nodes?.map( {(n: Node) -> Node in
                let newLocation = addPoints(a: n.location, b: origin)
                n.location = newLocation
                return n})
        
            var newNodes: ([Node],[Node])!
            
            // We check to see if we need to make a dual cut by looking at the Vertex.
            if let _ = VertexOfTheCut {
              newNodes = splitNodesWithDualCut(nodes: transformedNodes!)
            } else {
              newNodes = splitNodesWithSingleCut(nodes: transformedNodes!)
            }
            
            let topNodes = newNodes.0
            let bottomNodes = newNodes.1
            
            let topPolygon = DraggablePolygon()
            let bottomPolygon = DraggablePolygon()
            
            topPolygon.nodes = topNodes
            bottomPolygon.nodes = bottomNodes
            
            // This is a wonderful and useful function.
            let topPolygonFrame = frame(of: topPolygon.vertices())
            let bottomPolygonFrame = frame(of: bottomPolygon.vertices())
            
            topPolygon.frame = topPolygonFrame
            bottomPolygon.frame = bottomPolygonFrame
            
            // Map back to the  view's coordinate system.
            topPolygon.nodes = topNodes.map( {(n: Node) -> Node in
                let newLocation = subtractPoints(a: n.location, b: topPolygonFrame.origin)
                let returnNode = Node(_location: newLocation, _sister: n.sister)
                return returnNode})
            
            // Map back to the  view's coordinate system.
            bottomPolygon.nodes = bottomNodes.map({(n: Node) -> Node in
                let newLocation = subtractPoints(a: n.location, b: bottomPolygonFrame.origin)
                n.location = newLocation
                return n})
            
            // THE NODES ARE NOT IN THE CORRECT COORDINATE SYSTEM WHEN THIS OCCURS (now they are)
            topPolygon.drawTheLayer()
            bottomPolygon.drawTheLayer()
        
            ActivePolygon.removeFromSuperview()
            
            let currentPolygonIndex = AllPolygons.index(of: ActivePolygon)
            
            print("index of active polygon",index)
            print("active polygon index",ActivePolygonIndex)
            
            AllPolygons.remove(at: currentPolygonIndex!)
            //print("AllPolygons after removal",AllPolygons)
            
            //print("top Polygon superview before",topPolygon.superview)
            self.view.addSubview(topPolygon)
            //print("top Polygon superview after",topPolygon.superview)
            self.view.addSubview(bottomPolygon)
            
            AllPolygons.append(topPolygon)
            AllPolygons.append(bottomPolygon)
            
            resetCutting()
            ActivelyCutting = false
        
        }
    }
    
    @objc func undo(sender: UIButton) {
        resetCutting()
    }
    
    // Sweeeeeet
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !ActivelyCutting {
            view.bringSubview(toFront: ActivePolygon)
            animatedNumber.render(n: ActivePolygon.nodes!.count)
            UIView.animate(withDuration: 0.5, animations: {
                self.animatedNumber.center = CGPoint(x: self.view.center.x, y: self.view.frame.height - 2*self.numberDim)})
 
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {self.animatedNumber.frame.styleHideBottomMiddle(container: self.view.frame)})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // ----------- init ----------------------
        
        AllPolygons = []
        ActivePolygonIndex = 0
    
        let initialPolygon = DraggablePolygon()
        polygonRadius = 0.4*view.frame.width
        numberDim = view.frame.width/8
        
        // Gets the coordinates for a polygon based on "numberOfSides" and "radius"
        let verticesForInitialShape = getVerticesForType(numberOfSides: numberOfSides, radius: Double(polygonRadius!))
        
        // getNodes makes 0,0 the center of the polygon but the origin needs to be upper left hand corner.
        let verticesForInitialShape_inPolygon = verticesForInitialShape.map({p in addPoints(a: p, b: CGPoint(x: polygonRadius!, y: polygonRadius!))})
        
        initialPolygon.frame.styleInitialPolygonFrame(container: view.frame)
        // Right now, config only gets called when the polygon is first initialized. That's why it gets a sister index because all the vertices will have the same index in the beginning.
        initialPolygon.config(vertices: verticesForInitialShape_inPolygon)
        

        let backGround = UIImageView()
        
        // ------------ targets ---------------------
        

        cutOrCancelButton = UIButton()
        cutOrCancelButton.addTarget(self, action: #selector(cutOrCancel(sender:)), for: .touchUpInside)
       
        

        undoButton = UIButton()
        undoButton.addTarget(self, action: #selector(undo(sender:)), for: .touchUpInside)
    
        
        saveButton.addTarget(self, action: #selector(savePuzzle(sender:)), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
        printButton.addTarget(self, action: #selector(printPuzzle(sender:)), for: .touchUpInside)
        
        // ---------- Adding The Views -----------
        
        view.addSubview(saveButton)
        view.addSubview(undoButton)
        view.addSubview(cutOrCancelButton)
        view.addSubview(backGround)
        view.addSubview(markerOne)
        view.addSubview(markerTwo)
        view.addSubview(markerThree)
        view.addSubview(initialPolygon)
        view.addSubview(cuttingView)
        view.addSubview(printButton)
        
        
    
        // -------------- Setting State ---------------

        view.tag = 0
        backGround.image = BackGround
        
        
        // -----  Ordering Views ------------
        
        view.bringSubview(toFront: backButton)
        view.bringSubview(toFront: cutOrCancelButton)
        view.bringSubview(toFront: undoButton)
        view.bringSubview(toFront: saveButton)
        view.bringSubview(toFront: printButton)
        
        
        
        // ----------------- Adding Styles ----------------------
        
        backGround.frame.styleFillContainer(container: view.frame)
        
        markerOne.frame.styleHideMarker(container: view.frame)
        markerTwo.frame.styleHideMarker(container: view.frame)
        markerThree.frame.styleHideMarker(container: view.frame)
        
        saveButton.frame.styleBottomLeft(container: view.frame)
        saveButton.setImage(SaveIconImage, for: .normal)
        cuttingView.frame.styleFillContainer(container: view.frame)
        
    
        cutOrCancelButton.frame.styleTopRight(container: view.frame)
        undoButton.frame.styleTopRight(container: view.frame)
        undoButton.alpha = 0
        
        printButton.frame.styleBottomRight(container: view.frame)
        printButton.setImage(PrintIcon, for: .normal)
        
 
        // ----- Finishing Touches ---------------
        
        cutOrCancelButton.setImage(Scissors, for: .normal)
        undoButton.setImage(UndoImage, for: .normal)
        undoButton.alpha = 0 // Initially not visible.
        
        AllPolygons.append(initialPolygon)
        
        
        // Sprinkle in our animated number.
        view.addSubview(animatedNumber)
        view.bringSubview(toFront: animatedNumber)
        animatedNumber.render(n: 0)
        animatedNumber.center = CGPoint(x: view.center.x, y: view.frame.height+numberDim)
        
        // Gotta reset this when we start over.
        SisterIndex = 0
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        parachute = Parachute(frame: self.view.frame)
        parachute.setText(message: "Hello Again!")
        view.addSubview(parachute)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

