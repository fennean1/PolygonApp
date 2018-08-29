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
    
    func drawPolygon(at _nodes: [Node]){
    
        // Calculate the color based on the number of nodes
        myColor = getColorFromNumberOfSides(n: _nodes.count,opacity: 1.0)
        
        var tempNodes = _nodes

        self.opacity = 1
        self.lineWidth = 1
        //shape.lineJoin = kCALineJoinMiter
        self.strokeColor = UIColor.black.cgColor
        self.fillColor = myColor    
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: tempNodes[0].location.x,y: tempNodes[0].location.y))
        tempNodes.remove(at: 0)
        
        for n in tempNodes {
            let addTo = CGPoint(x: n.location.x, y: n.location.y)
            path.addLine(to: addTo)
        }
        
        path.close()
        // Don't need this anymore I don't think.
        self.path = path.cgPath
        
    }
    
}



class DraggablePolygon: UIView {
    
    // Public because we will initialize this from outsisde the class.
    public var nodes: [Node]?
    
    var polygonLayer = PolygonLayer()
    
    
    var colorForNumber: CGColor = UIColor.clear.cgColor
    
    // Sometimes we need to get the array of points from the nodes.
    func vertices() -> [CGPoint] {
        return convertNodesToPoints(_nodes: nodes!)
    }
    
    var lines: [Line] = []

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        super.point(inside: point, with: event)
        if let p = polygonLayer.path {
            if p.contains(point) {
                ActivePolygonIndex = AllPolygons.index(of: self)!
                applyShadows()
                viewWithTag(0)?.bringSubview(toFront: ActivePolygon)
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
    
    //
    func config(vertices: [CGPoint]){
        self.nodes = vertices.map({v in Node(_location: v, _sister: nil)})
        self.drawTheLayer()
    }
    
    @objc func panhandle(_ sender: UIPanGestureRecognizer)
    {
        
        let translation = sender.translation(in: sender.view)
        
        if let view = sender.view
        {
            view.center = CGPoint(x: (view.center.x + translation.x),
                                  y: view.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: sender.view)
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
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.frame = frame
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panhandle))
        pan.cancelsTouchesInView = false
        self.frame = frame
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
        self.layer.shadowColor = colorForNumber

    }
    
}


