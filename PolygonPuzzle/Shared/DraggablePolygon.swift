//
//  DraggablePolygon.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/18/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

class PolygonLayer: CAShapeLayer {
    
    public var myColor: CGColor!
    public var myBorderColor: CGColor!
    var myNodes: [Node] = []
    var colorOverride = false
    
    func flip() {
        let theNewPath = UIBezierPath()
        let d = self.frame.height
        print("height of polygon when flipping",d)
        
        var tempNodes = myNodes
        
        theNewPath.move(to: CGPoint(x: tempNodes[0].location.x,y: d - tempNodes[0].location.y))
        myNodes[0].location = CGPoint(x: tempNodes[0].location.x,y: d - tempNodes[0].location.y)
        tempNodes.remove(at: 0)
        
        for (i,n) in tempNodes.enumerated() {
            let addTo = CGPoint(x: n.location.x, y: d -  n.location.y)
            myNodes[i+1].location = CGPoint(x: n.location.x, y: d -  n.location.y)
            theNewPath.addLine(to: addTo)
        }
        
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "path")
        animation.toValue = theNewPath.cgPath
        animation.duration = 1
        
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut) // animation curve is Ease Out
        animation.fillMode = kCAFillModeBoth // keep to value after finishing
        animation.isRemovedOnCompletion = false
        
        // Callback function
        CATransaction.setCompletionBlock {
            self.drawPolygon(at: self.myNodes)
        }
        
        self.add(animation, forKey: animation.keyPath)
        
        CATransaction.commit()
        
     
    
    }
    
    func drawPolygon(at _nodes: [Node]){
        myNodes = _nodes
        self.lineWidth = 0
        
        
        // Calculate the color based on the number of nodes
        if colorOverride == false {
            self.opacity = 1
            self.lineWidth = 1
            self.strokeColor = UIColor.black.cgColor
            myColor = getColorFromNumberOfSides(n: _nodes.count,opacity: 1.0)
            if _nodes.count >= 10 {
                self.lineWidth = self.frame.width/50
                self.strokeColor = colorForOne.cgColor
            }
        }
        
        var tempNodes = _nodes
        
        self.fillColor = myColor    
    
        let thePath = UIBezierPath()
        
        thePath.move(to: CGPoint(x: tempNodes[0].location.x,y: tempNodes[0].location.y))
        tempNodes.remove(at: 0)
        
        for n in tempNodes {
            let addTo = CGPoint(x: n.location.x, y: n.location.y)
            thePath.addLine(to: addTo)
        }
        
        thePath.close()
        
        self.path = thePath.cgPath
        
    }
    
}



class DraggablePolygon: UIView {
    
    // Automatically checks to see if puzzle is solved and then puts it together. False until we load them into the Solver View Controller.
    var AutoCheck = false
    
    // Not a good place for didSet because nodes get transformed (coordinate systems etc. alot)
    public var nodes: [Node]?
    
    // If a polygon is just a saved polgyon - does it need an original origin? Well, it might inherit  from the piece that get saved.
    var originalOrigin = PointZero
    var originalDim: CGFloat = InitialPolygonDim
    var cancelDragging = false
    
    var pan: UIPanGestureRecognizer!
    
    var polygonLayer = PolygonLayer()
    
    var vertexImage: [UIImageView] = []
    
    var lines: [Line] = []
    
    // Each polygon belongs to an array of polygons.
    var membership: [DraggablePolygon] = []
    
    // Looks like this get set later.
    var colorForNumber: CGColor = UIColor.clear.cgColor
    
    // Sometimes we need to get the array of points from the nodes.
    func vertices() -> [CGPoint] {
        return convertNodesToPoints(_nodes: nodes!)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("point inside",point)
        super.point(inside: point, with: event)
        if let p = polygonLayer.path {
            if p.contains(point) {
                
                // Return false if dragging is canceled.
                if cancelDragging {
                    return false
                }

                // HELLO!
                ActivePolygonIndex = AllPolygons.index(of: self)!
                applyShadows()
                self.layer.shadowPath = p
                self.layer.shadowRadius = 15
                self.layer.shadowOpacity = 0.8
                self.layer.shadowOffset = CGSize(width: 0, height: 1.0)
                self.layer.shadowColor = polygonLayer.myColor
                return true
            }
            else
            {
                return false
            }
        }
        else {
                return false
        }
    }
    
    // Helps us initialize our polygon
    func config(vertices: [CGPoint]){
        // Woaaaa - sister is nil here!
        self.nodes = vertices.map({v in Node(_location: v, _sister: nil)})
        self.drawTheLayer()
    }
    
    @objc func panhandle(_ sender: UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: self.superview)
        
        if let view = sender.view {
            view.center = CGPoint(x: (view.center.x + translation.x),
                                  y: view.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: sender.view)
        }
        
        if sender.state == .ended {
            if AutoCheck == true {
                putAllPolygonsTogether()
            }
        }
    }
    
    func drawTheLayer() {
        // Nodes might not have been set yet
        if let _nodes = self.nodes {
            polygonLayer.frame = self.bounds
            polygonLayer.drawPolygon(at: _nodes)
            self.layer.insertSublayer(polygonLayer, at: 0)
        }
    }


    // Inits
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        pan = UIPanGestureRecognizer(target: self, action: #selector(panhandle))
        pan.cancelsTouchesInView = false
        self.frame = frame
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
        //self.backgroundColor = UIColor.blue
        self.layer.shadowColor = colorForNumber
    }
    
}


