//
//  ViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/18/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import UIKit
import Foundation

/*
    1) Some kind of initialization or non reinitialization issue
    2) A problem the vertex being used to classify points as either above or below.
    3) FIRST and SECOND nodes AREN"T ALWAYS "IN" or "OUT" in the same respect. Need a better way to differentiacte because they different now...called it.
 */


var testingVertex: CGPoint!

class PuzzleEditor: UIViewController {
    
    
    // Polygon is 80% of the frame width. (What about landscape mode? - Not Supporting Yet)
    var viewFrame: CGRect? = nil
    
    // What are these?
    var polygonWidth: CGFloat? = nil
    var polygonHeight: CGFloat? = nil
    var polygonRadius: CGFloat? = nil
    
    var backButton = UIButton()
    
    // Number that pops up when polygon is touched.
    var animatedNumber: NumberFrame!
    var numberDim: CGFloat = 0

    let cuttingView = CuttingView()
    var polygons: [DraggablePolygon] = []
    var saveButton = UIButton()
    var printButton = UIButton()
    
    @objc func printPuzzle(sender: UIButton) {
        saveAllPolygonsToPhotos()
        savePuzzleToCoreData(polygons: AllPolygons, name: "MyFirstPuzzle")
        parachute.setText(message: "Puzzle Saved To Photos")
        parachute.showParachute()
    }
    
    func validateName(name: String) -> Bool {
        for p in FetchedPuzzles {
            if p.name == name {
                return false
            } else {
                return true
            }
        }
        
        return true
        
    }
    
    @objc func savePuzzle(sender: UIButton) {
            
            let alert = UIAlertController(title: "New Puzzle",
                                          message: "Name Your Puzzle",
                                          preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save",
                                           style: .default,
                                           handler: { (action:UIAlertAction) -> Void in
                                            
                                            let puzzleName = alert.textFields!.first?.text

                                            
                                            // Check to see if the name doesn't exist
                                            if self.validateName(name: puzzleName!) {
                    
                                                savePuzzleToCoreData(polygons: AllPolygons, name: puzzleName!)
                                        
                                            }
                                                // If it does, prompt to enter another name.
                                            else
                                            {
                                                let oopsalert = UIAlertController(title: "Oops!",
                                                                                  message: "That name is already taken",
                                                                                  preferredStyle: .alert)
                                                
                                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction) -> Void in self.present(alert,
                                                                                                                                                                     animated: true,
                                                                                                                                                                     completion: nil)})
                                                
                                                oopsalert.addAction(okAction)
                                                
                                                self.present(oopsalert,
                                                             animated: true,
                                                             completion: nil)
                                                
                                                
                                            }
                                            
                                            
            })
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default) { (action: UIAlertAction) -> Void in
            }
            
            alert.addTextField {
                (textField: UITextField) -> Void in}
            
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            
            alert.view.setNeedsLayout()
            
            present(alert, animated: true,
                    completion: nil)
        
        
        
    }
    
    @objc func savePolygon(sender: UIButton){
        // How do we check for duplicates here? - We don't? Oh we need support for extras. Polygon Needs "Polygon ID"
        
        savePuzzleToCoreData(polygons: AllPolygons, name: "Cool Puzzle")

        SavedPolygons.append(ActivePolygon)
        
        print("validating all sisters",validateAllSisters())
        
        printAllSisters()
        
        if validateAllSisters() {
            parachute.setText(message: "Polygon Saved.")
        } else
        {
            parachute.setText(message: "Polygon Saved.")
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
        VerticesOfCut = []
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
            
            // Can I replace this with "ValidCutHasBeenMade? - I think so and it would make more sense.
            guard StartOfCut != nil && EndOfCut != nil else {
                print("GUARD FAILED!")
                resetCutting()
                ActivelyCutting = false
                return
            }
            
            // REALLY IMPORTANT FEW LINES!
            let origin = ActivePolygon.frame.origin
            let nodes = ActivePolygon.nodes
            let originalOrigin = ActivePolygon.originalOrigin
            
    
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
            let topPolygonFrameOrigin = topPolygonFrame.origin
            let bottomPolygonFrame = frame(of: bottomPolygon.vertices())
            let bottomPolygonFrameOrigin = bottomPolygonFrame.origin
            
 
            // Computing the original origins for the new polygons.
            // Psuedo code: newOriginalOrigin = newOrigin-currentOrigin+originalOrigin
            
            let offsetFromCurrentOriginTopPolygon = subtractPoints(a: topPolygonFrameOrigin, b: origin)
            let originalOriginForTopPolygon = addPoints(a: offsetFromCurrentOriginTopPolygon, b: originalOrigin)
            let offsetFromCurrentOriginBottomPolygon = subtractPoints(a: bottomPolygonFrameOrigin, b: origin)
            let originalOriginForBottomPolygon = addPoints(a: offsetFromCurrentOriginBottomPolygon, b: originalOrigin)
            
            topPolygon.originalOrigin = originalOriginForTopPolygon
            bottomPolygon.originalOrigin = originalOriginForBottomPolygon
            
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
            
            // Why am I recomputing this?
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
    
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !ActivelyCutting {
            view.bringSubview(toFront: ActivePolygon)
            animatedNumber.render(n: ActivePolygon.nodes!.count)
            UIView.animate(withDuration: 0.5, animations: {
                self.animatedNumber.center = CGPoint(x: self.view.center.x, y:  2*self.numberDim)})
        }
    }
    
    // FIX THE Y COORDINATE!
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations: {self.animatedNumber.center = CGPoint(x: self.view.center.x, y: -self.view.frame.width/7 )})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        /* Sprinkle in our animated number.
        animatedNumber = NumberFrame(n: 6, dim: view.frame.width/6)
        view.addSubview(animatedNumber)
        view.bringSubview(toFront: animatedNumber)
        animatedNumber.render(n: 0)
        animatedNumber.center = CGPoint(x: view.center.x, y: -2*numberDim)
 
 */
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pol = FetchedPolygons {
            AllPolygons = pol
        }
        
        testingVertex = view.center
        VerticesOfCut = []
        
        // ----------- init ----------------------
        
        AllPolygons = []
        ActivePolygonIndex = 0
    

        let initialPolygon = DraggablePolygon()
        polygonRadius = 0.4*view.frame.width
        
        // What is number dim...
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
        view.addSubview(backButton)
        
        
    
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
        
        backButton.frame.styleTopLeft(container: view.frame)
        
 
        // ----- Finishing Touches ---------------
        
        cutOrCancelButton.setImage(Scissors, for: .normal)
        undoButton.setImage(UndoImage, for: .normal)
        backButton.setImage(BackImage, for: .normal)
        undoButton.alpha = 0 // Initially not visible.
        
        AllPolygons.append(initialPolygon)
        
        // Gotta reset this when we start over. (this will be depracated)
        SisterIndex = 0
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        parachute = Parachute(frame: self.view.frame)
        parachute.setText(message: "Hello Again!")
        view.addSubview(parachute)
        view.bringSubview(toFront: parachute)
        
        // Sprinkle in our animated number.
        animatedNumber = NumberFrame(n: 6, dim: view.frame.width/6)
        view.addSubview(animatedNumber)
        view.bringSubview(toFront: animatedNumber)
        animatedNumber.render(n: 0)
        animatedNumber.center = CGPoint(x: view.center.x, y: -2*numberDim)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
}

