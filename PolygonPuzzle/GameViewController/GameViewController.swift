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


let markerOne = UIImageView(image: Marker)
let markerTwo = UIImageView(image: Marker)
let markerThree = UIImageView(image: Marker)

var cutOrCancelButton: UIButton!
var undoButton: UIButton!

class GameViewController: UIViewController {
    
    // Polygon is 80% of the frame width. (What about landscape mode? - Not Supporting Yet)
    var viewFrame: CGRect? = nil
    var polygonWidth: CGFloat? = nil
    var polygonHeight: CGFloat? = nil
    var polygonRadius: CGFloat? = nil

    let cuttingView = CuttingView()

    var points: [CGPoint] = []
    var detecting = true
    var polygons: [DraggablePolygon] = []
    
    func showCancelButton(){
        view.bringSubview(toFront: undoButton)
        undoButton.alpha = 1
        undoButton.frame.styleUnderTopRight(container: view.frame)
    }
    
    func hideCancelButton(){
        UIView.animate(withDuration: 0.5, animations: {
            undoButton.alpha = 0})
    }
    
    func resetCutting(){
        IntersectionNodes = []
        ValidCutHasBeenMade = false
        StartOfCut?.location = nil
        EndOfCut?.location = nil
        VertexOfTheCut?.location = nil
        CuttingViewNeedsClearing = true
        FirstStrokeHasBeenMade = false
        SecondStrokeHasBeenMade = false
        cuttingView.setNeedsDisplay()
        markerOne.frame.styleHideMarker(container: view.frame)
        markerTwo.frame.styleHideMarker(container: view.frame)
        markerThree.frame.styleHideMarker(container: view.frame)
    }
    


    @IBOutlet weak var backButton: UIButton!

    @objc func cutOrCancel(sender: UIButton){
     
        print("cut clicked")
        // Needs to be in front of the "invisible" cutting view
        view.bringSubview(toFront: cuttingView)
        view.bringSubview(toFront: cutOrCancelButton)
        view.bringSubview(toFront: undoButton)
        view.bringSubview(toFront: markerOne)
        view.bringSubview(toFront: markerTwo)
        view.bringSubview(toFront: markerThree)
        // There will now be many markers... need "addMarkerToNodes(nodes: [Node])" function
        
        /* Need to get the polygon origin so we can convert its points to
         the coordinates of the containing view */
        let polygonOrigin = AllPolygons[ActivePolygonIndex].frame.origin
        
        // Get coordinates in the main view.
        let nodesForLines = mapPointsWithOffset(offSet: polygonOrigin, points: AllPolygons[ActivePolygonIndex].vertices())
        LinesToCut = makeLinesFromPoints(points: nodesForLines)

        // NEED TO CHECK IF VALID CUT HAS BEEN MADE TO DETERMINE WHETHER A CLICK CANCELS EVERYTHING
        
        // Go add the line on dragEnded to change the image to a check mark when valid cut has been made (maybe use did set on ValidCutHasBeenMade?
        
        if FinishedCutting {
            FinishedCutting = false
            
            showCancelButton()
            CuttingViewNeedsClearing = false
            cutOrCancelButton.setImage(CancelImage, for: .normal)
            print("not Cutting when clicked")
            IntersectionNodes = []
            hideInactivePolygons()
        }
        // Ends the cut entirely.
        else if !FinishedCutting {
            
            // Reset State Variables
            ValidCutHasBeenMade = false
            FinishedCutting = true
            FirstStrokeHasBeenMade = false
            SecondStrokeHasBeenMade = false
            CuttingViewNeedsClearing = true
            
            hideCancelButton()
            cutOrCancelButton.setImage(UIImage(named: "scissors-clipart"), for: .normal)
            returnPolygonsToView()
            
            UIView.animate(withDuration: 1, animations: {
                markerOne.frame.styleHideMarker(container: self.view.frame)
                markerTwo.frame.styleHideMarker(container: self.view.frame)
                markerThree.frame.styleHideMarker(container: self.view.frame)
            })
            
            cuttingView.setNeedsDisplay()
            
            guard IntersectionNodes.count == 3 || IntersectionNodes.count == 2 else {
                print("Failed guard for IntersectionNodes")
                return
            }
            
            print("passed guard for IntersectionNodes")
            
            let ActivePolygon = AllPolygons[ActivePolygonIndex]
            let origin = ActivePolygon.frame.origin
            let nodes = ActivePolygon.nodes
            // This converts the nodes to the main coordinate system - need to write a function for this.
            let transformedNodes = nodes?.map( {(n: Node) -> Node in
                let newLocation = addPoints(a: n.location, b: origin)
                n.location = newLocation
                return n})
            
            var newNodes: ([Node],[Node])!
            
            if IntersectionNodes.count == 2 {
                newNodes = splitNodesWithSingleCut(cutNodes: IntersectionNodes, nodes: transformedNodes!)
            } else if IntersectionNodes.count == 3 {
                newNodes = splitNodesWithDualCut(cutNodes: IntersectionNodes, nodes: transformedNodes!)
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
            
            view.addSubview(topPolygon)
            view.addSubview(bottomPolygon)
            
            ActivePolygon.removeFromSuperview()
            
            AllPolygons.remove(at: ActivePolygonIndex)
            
            AllPolygons += [topPolygon,bottomPolygon]
            
        }
        
        
    }
    
    @objc func undo(sender: UIButton) {
        
        resetCutting()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        if FinishedCutting {
            print("touchesBegan but also not Cutting")
            view.bringSubview(toFront: ActivePolygon)
        }
    }
    
    @objc func goBack(sender: UIButton) {
        
        print("segue to LandingViewController")
        
        AllPolygons = []
        VertexOfTheCut = nil
        FirstStrokeHasBeenMade = false
        SecondStrokeHasBeenMade = false
        CuttingViewNeedsClearing = true
        ActivePolygonIndex = 0
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "LandingViewController")
        
        self.show(vc as! UIViewController, sender: vc)
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let _ = cutOrCancelButton {
            // Do nothing, button already set up.
            print("cut or cancel button already set up")
        } else {
            cutOrCancelButton = UIButton()
            view.addSubview(cutOrCancelButton)
            cutOrCancelButton.addTarget(self, action: #selector(cutOrCancel(sender:)), for: .touchUpInside)
            
            
        }
        
        if let _ = undoButton {
            // Do nothing, button already set up.
            print("undo button already set up")
        } else {
            undoButton = UIButton()
            view.addSubview(undoButton)
            undoButton.addTarget(self, action: #selector(undo(sender:)), for: .touchUpInside)
            
        }
        

        CuttingViewNeedsClearing = false
        ValidCutHasBeenMade = false
        
        view.tag = 0
    
        let backGround = UIImageView()
        view.addSubview(backGround)
        backGround.frame.styleFillContainer(container: view.frame)
        backGround.image = BackGround
        
        // Polygon is 80% of the frame width. (What about landscape mode?)
        polygonWidth = 0.8*view.frame.width
        polygonHeight = polygonWidth
        polygonRadius = polygonHeight!/2
        
        
        // Gets the coordinates for a polygon based on "numberOfSides" and "radius"
       let verticesForInitialShape = getVerticesForType(numberOfSides: numberOfSides, radius: Double(polygonRadius!))
 
        // getNodes makes 0,0 the center of the polygon but the origin needs to be upper left hand corner.
        let verticesForInitialShape_inPolygon = verticesForInitialShape.map({p in addPoints(a: p, b: CGPoint(x: polygonRadius!, y: polygonRadius!))})
        
        let initialPolygon = DraggablePolygon()
        
        var polygonFrame: CGRect {
            let x = 0.10*view.frame.width
            let y =  0.5*(view.frame.height-polygonHeight!)
            let w = polygonWidth!
            let h = polygonHeight!
            return CGRect(x: x, y: y, width: w, height: h)
        }
        
        initialPolygon.frame = polygonFrame
        initialPolygon.config(vertices: verticesForInitialShape_inPolygon)
        
        view.addSubview(initialPolygon)
        
        cuttingView.frame.styleFillContainer(container: view.frame)
        view.addSubview(cuttingView)

        view.bringSubview(toFront: cutOrCancelButton)
        view.bringSubview(toFront: backButton)
        
        view.bringSubview(toFront: cutOrCancelButton)
        view.bringSubview(toFront: undoButton)
        
        view.addSubview(markerOne)
        view.addSubview(markerTwo)
        view.addSubview(markerThree)
        
        markerOne.frame.styleHideMarker(container: view.frame)
        markerTwo.frame.styleHideMarker(container: view.frame)
        markerThree.frame.styleHideMarker(container: view.frame)
        
        cutOrCancelButton.frame.styleTopRight(container: view.frame)
        undoButton.frame.styleUnderTopRight(container: view.frame)
 
        cutOrCancelButton.setImage(Scissors, for: .normal)
        undoButton.setImage(UndoImage, for: .normal)
        undoButton.alpha = 0 // Initially not visible.
        
        
        AllPolygons.append(initialPolygon)
 
        backButton.addTarget(self, action: #selector(goBack(sender:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }


}

