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
    
    var myContext = UIGraphicsGetCurrentContext()
    
    public var cutStart = CGPoint(x: 0,y: 0)
    
    public var cutEnd = CGPoint(x: 0,y: 0)
    {
        didSet {
            // Don't call set needs display if pan has ended.
            if myPan.state != .ended {
                self.setNeedsDisplay()
            }
        }
    }
    
    // point inside isn't recognized if cutting is false - there has to be a better way to do this. Oh, no because it has to pass touches...maybe bring in the view after cutting is clicked?
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // Only registers point if the user is not finished cutting.    
        return !FinishedCutting
    }

    // Draw is a single source of truth for our view. Everything drawn is a function of
    // the current app state.
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(4)
        
        if CuttingViewNeedsClearing {
           CuttingViewNeedsClearing = false
           context?.clear(self.bounds)
        }
        else if ValidCutHasBeenMade {
            // do nothing. We're not drawing anymore because a valid cut is currently on the board.
            print("Valid cut has been made")
        }
        else if FirstStrokeHasBeenMade {
                context?.move(to: cutStart)
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
    
    @objc func panHandler(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            print("Pan Began")
            if FirstStrokeHasBeenMade {
                print("First Stroke Has Been Made")
                // Don't reset the cut start, I want the old cut start.
            }
            else {
                print("Second Stroke Has Not Been Made")
                cutStart = pan.location(in: self)
            }
        }
    
        cutEnd = pan.location(in: self)
   
        if pan.state == .ended {
            
            // Need support for many strokes.
            if ValidCutHasBeenMade {
              // Do nothing
            }
            else if !FirstStrokeHasBeenMade {
                LineToCutWith = Line(_firstPoint: cutStart, _secondPoint: cutEnd)
            }
            else {
                LineToCutWith = Line(_firstPoint: (VertexOfTheCut?.location)!, _secondPoint: cutEnd)
            }
            
            // 1) I dont' like that I'm passing global variables to this.
            // 2) I don't like that it returns a boolean  - or do I?
            guard getIntersectionPoints(lines: LinesToCut, cuttingLine: LineToCutWith) else {return}
            print("I'm past the guard statement")
            
            // Does this contain the vertex? - Yes, getIntersectionPoints currently assigns a vertex.
            if IntersectionNodes.count <= 3 {
            
            UIView.animate(withDuration: 1, animations: {
                if let first = IntersectionNodes.first?.location {
                    markerOne.center = first
                }
                
                if let second = IntersectionNodes[1].location {
                    markerTwo.center = second
                }
                
                if FirstStrokeHasBeenMade {
                    if let third = IntersectionNodes.last?.location {
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
