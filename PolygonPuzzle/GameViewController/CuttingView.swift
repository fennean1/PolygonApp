//
//  CuttingView.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/7/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


// Need this for drawing over the view.
class CuttingView: UIView {
    
    var myPan: UIPanGestureRecognizer!
    
    public var cutStart = CGPoint(x: 0,y: 0)
    
    public var cutEnd = CGPoint(x: 0,y:0)
    {
        didSet {
            if myPan.state != .ended {
                self.setNeedsDisplay()
            }
        }
    }
    
    // point inside isn't recognized if cutting is false - there has to be a better way to do this. Oh, no because it has to pass touches...maybe bring in the view after cutting is clicked?
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return Cutting
    }
    
    func clear(){
        let context = UIGraphicsGetCurrentContext()
        context?.clear(self.bounds)
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(4)
        
        if Cutting {
            
            if FirstStrokeHasBeenMade {
                context?.move(to: cutStart)
                // HELLO! This fails when there is no interior point.
                context?.addLine(to: IntersectionNodes[1].location)
                context?.addLine(to: cutEnd)
                context?.strokePath()
            }
            else if !FirstStrokeHasBeenMade {
                context?.move(to: cutStart)
                context?.addLine(to: cutEnd)
                context?.strokePath()
            }
        }
        // Do I need this?
        else {
            context?.clear(self.bounds)
        }
    }
    
    @objc func panHandler(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            if FirstStrokeHasBeenMade {
                // Don't reset the cut start, I want the old cut start.
            }
            else {
                cutStart = pan.location(in: self)
            }
        }
    
        cutEnd = pan.location(in: self)
   
        if pan.state == .ended {
            
            if !FirstStrokeHasBeenMade {
                LineToCutWith = Line(_firstPoint: cutStart, _secondPoint: cutEnd)
            }
            else {
                LineToCutWith = Line(_firstPoint: (VertexOfTheCut?.location)!, _secondPoint: cutEnd)
            }
            
            getIntersectionPoints(lines: LinesToCut, cuttingLine: LineToCutWith)
        
            
            if IntersectionNodes.count <= 3 {
            
            UIView.animate(withDuration: 1, animations: {
                if let first = IntersectionNodes.first?.location {
                    markerOne.center = first
                }
                
                if let second = IntersectionNodes[1].location {
                    markerTwo.center = second
                }
                
                if FirstStrokeHasBeenMade {
                    if let third = IntersectionNodes[2].location {
                        markerThree.center = third
                    }
                }
            })
            }
            
            // Set stroke state
            if !FirstStrokeHasBeenMade {
                FirstStrokeHasBeenMade = true
            }
            else if FirstStrokeHasBeenMade {
                SecondStrokeHasBeenMade = true
            }
            
         }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        myPan = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        
        self.addGestureRecognizer(myPan)
        
        
    }
    
    
}
