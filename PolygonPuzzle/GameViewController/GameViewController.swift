//
//  ViewController.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/18/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import UIKit
import Foundation


// TODO:
// 1) Submit Cut Button (Only shows after line is draw and dissapears otherwise) - Might not need this.
// 2) Cut button generates all LinesToCut from current DraggablePolygon (see array)
// 3) Iterates through LineToCutWith in order to find a match.
// 4) Cancels the cut if there are more than two intersections

// TODO Later
// 1) Make intersection points near vertices default to the vertice
// 2) Track "Sister" nodes after the cut. (Index of Syster? Node class that extends CG Point? (Yea probably)

// Little number bounce up when polygon is touched.
// Numbers over 20 have a yellow border with 


class GameViewController: UIViewController {
    
    
    // Polygon is 80% of the frame width. (What about landscape mode? - Not Supporting Yet)
    var viewFrame: CGRect? = nil
    var polygonWidth: CGFloat? = nil
    var polygonHeight: CGFloat? = nil
    var polygonRadius: CGFloat? = nil
    var MyPolygons: [DraggablePolygon] = []

    let cuttingView = CuttingView()
    var parachute: Parachute!
    var points: [CGPoint] = []
    var detecting = true
    var polygons: [DraggablePolygon] = []
    var saveButton = UIButton()
    
    @objc func saveActivePolygon(sender: UIButton){
        // How do we check for duplicates here? - We don't? Oh we need support for extras. Polygon Needs "Polygon ID"
        
        SavedPolygons.append(ActivePolygon)
        
        parachute.setText(message: "Polygon Saved!")
        parachute.showParachute()
    
    }
    
    func showCancelButton(){
        view.bringSubview(toFront: undoButton)
        undoButton.alpha = 1
        undoButton.frame.styleUnderTopRight(container: view.frame)
    }
    
    func hideCancelButton(){
        UIView.animate(withDuration: 0.5, animations: {
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
    
    
    func addPolygonsToCurrentView() {
        for p in AllPolygons {
            print("polygon superview before",p.superview)
            view.addSubview(p)
            print("polygon superview after",p.superview)
        }
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
           // parachute.showParachute()
            print("not actively cutting when clicked")
            ActivelyCutting = true
            showCancelButton()
            CuttingViewNeedsClearing = false
            hideInactivePolygons()
        }
        // Ends the cut entirely.
        else if ActivelyCutting {
            print("Actively cutting when clicked")
            parachute.hideParachute()
            
            returnPolygonsToView()
            
            hideCancelButton()
            
            UIView.animate(withDuration: 1, animations:
            {
                markerOne.frame.styleHideMarker(container: self.view.frame)
                markerTwo.frame.styleHideMarker(container: self.view.frame)
                markerThree.frame.styleHideMarker(container: self.view.frame)
            })
            
            //cuttingView.setNeedsDisplay()

            // Can I replace this with "ValidCutHasBeenMade?
            guard StartOfCut != nil && EndOfCut != nil else {
                print("YO, GUARD FAILED!")
                print("ActivePolygonIndex",ActivePolygonIndex)
                print("Start and End of Cut have not been set!")
                resetCutting()
                ActivelyCutting = false
                print("cuttingViewNeedsClearing",CuttingViewNeedsClearing)
                print("cutting has been reset")
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
                let returnNode = Node(_location: newLocation, _sister: n.sister)
                return returnNode})
            
            // THE NODES ARE NOT IN THE CORRECT COORDINATE SYSTEM WHEN THIS OCCURS (now they are)
            topPolygon.drawTheLayer()
            bottomPolygon.drawTheLayer()
        
            print("About to remove active polygon from superview")
            ActivePolygon.removeFromSuperview()
            
            AllPolygons.remove(at: ActivePolygonIndex)
            print("AllPolygons after removal",AllPolygons)
            
            //print("top Polygon superview before",topPolygon.superview)
            self.view.addSubview(topPolygon)
            //print("top Polygon superview after",topPolygon.superview)
            self.view.addSubview(bottomPolygon)
            
            AllPolygons.append(topPolygon)
            AllPolygons.append(bottomPolygon)
            
            
            resetCutting()
            ActivelyCutting = false
            
            addPolygonsToCurrentView()
        
        }
    }
    
    @objc func undo(sender: UIButton) {
        resetCutting()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Began Is called")
        if !ActivelyCutting {
            view.bringSubview(toFront: ActivePolygon)
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  
        // ----------- init ----------------------
        
        AllPolygons = []
        ActivePolygonIndex = 0
    
        let initialPolygon = DraggablePolygon()
        polygonRadius = 0.4*view.frame.width
        
        // Gets the coordinates for a polygon based on "numberOfSides" and "radius"
        let verticesForInitialShape = getVerticesForType(numberOfSides: numberOfSides, radius: Double(polygonRadius!))
        
        // getNodes makes 0,0 the center of the polygon but the origin needs to be upper left hand corner.
        let verticesForInitialShape_inPolygon = verticesForInitialShape.map({p in addPoints(a: p, b: CGPoint(x: polygonRadius!, y: polygonRadius!))})
        
        initialPolygon.frame.styleInitialPolygonFrame(container: view.frame)
        initialPolygon.config(vertices: verticesForInitialShape_inPolygon)
        

        let backGround = UIImageView()
        
        // ------------ targets ---------------------
        

            cutOrCancelButton = UIButton()
            cutOrCancelButton.addTarget(self, action: #selector(cutOrCancel(sender:)), for: .touchUpInside)
       
        

            undoButton = UIButton()
            undoButton.addTarget(self, action: #selector(undo(sender:)), for: .touchUpInside)
    
        
        saveButton.addTarget(self, action: #selector(saveActivePolygon(sender:)), for: .touchUpInside)
        
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
        
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
        
        
    
        // -------------- Setting State ---------------

        view.tag = 0
        backGround.image = BackGround
        
        
        // -----  Ordering Views ------------
        
        view.bringSubview(toFront: backButton)
        view.bringSubview(toFront: cutOrCancelButton)
        view.bringSubview(toFront: undoButton)
        view.bringSubview(toFront: saveButton)
        
        
        
        // ----------------- Adding Styles ----------------------
        
        backGround.frame.styleFillContainer(container: view.frame)
        
        markerOne.frame.styleHideMarker(container: view.frame)
        markerTwo.frame.styleHideMarker(container: view.frame)
        markerThree.frame.styleHideMarker(container: view.frame)
        
        saveButton.frame.styleBottomLeft(container: view.frame)
        saveButton.setImage(SaveIconImage, for: .normal)
        cuttingView.frame.styleFillContainer(container: view.frame)
        
    
        cutOrCancelButton.frame.styleTopRight(container: view.frame)
        undoButton.frame.styleUnderTopRight(container: view.frame)
        
 
        // ----- Finishing Touches ---------------
        
        cutOrCancelButton.setImage(Scissors, for: .normal)
        undoButton.setImage(UndoImage, for: .normal)
        undoButton.alpha = 0 // Initially not visible.
        
        AllPolygons.append(initialPolygon)
        //MyPolygons = AllPolygons
        
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

