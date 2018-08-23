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
    
    public var cutStart = CGPoint(x: 0,y: 0)
    
    public var cutEnd = CGPoint(x: 0,y:0)
    {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // point inside isn't recognized if cutting is false - there has to be a better way to do this. Oh, no because it has to pass touches...maybe bring in the view after cutting is clicked?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return Cutting
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.yellow.cgColor)
        context?.setLineWidth(4)
        
        if Cutting {
            
            context?.move(to: cutStart)
            context?.addLine(to: cutEnd)
            
            
            context?.strokePath()
        }
        else {
            context?.clear(self.bounds)
        }
        
        
    }
    
    var translation = CGPoint(x: 0, y: 0)
    
    
    @objc func panHandler(pan: UIPanGestureRecognizer){
        
        if pan.state == .began {
            cutStart = pan.location(in: self)
        
        }
    
        translation = pan.translation(in: self)
        
        cutEnd = addPoints(a: cutStart, b: translation)
        
        // Not sure if I need to do this
        translation = CGPoint(x: 0, y: 0)
        
        if pan.state == .ended {
            
            LineToCutWith = Line(_firstPoint: cutStart, _secondPoint: cutEnd)
            
            // Cut points may not exist so we have to check if we can unwrap it.
            if let cutPoints = getCutPoints(lines: LinesToCut, cuttingLine: LineToCutWith){
                IntersectionNodes = cutPoints
            
                UIView.animate(withDuration: 1, animations: {
                    markerOne.center = IntersectionNodes[0].location
                    markerTwo.center = IntersectionNodes[1].location
                })
                
            }
    
        }
        
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        
        self.addGestureRecognizer(panRecognizer)
        
        
    }
    
    
}
