//
//  Line.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 8/13/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit



class Line {
    
    var firstPoint: CGPoint?
    var secondPoint: CGPoint?
    var maxY: CGFloat?
    var minY: CGFloat?
    var maxX: CGFloat?
    var minX: CGFloat?
    var isVertical = false
    var isHorizontal = false
    
    var m = CGFloat(0)
    var b = CGFloat(0)
    
    func containsPoint(point: CGPoint) -> Bool {
        
        // HELLO! What if...?
        if self.isHorizontal {
            if abs(point.y - self.b) < 2 {
                return true
            }
        }
        
        if self.isVertical {
            if abs(point.x - self.firstPoint!.x) < 2 {
                if self.inRange(val: point.y){
                    return true
                }
            }
        }
        
        
        if abs(self.y(x: point.x) - point.y) < 2 {
            if self.inRange(val: point.y) {
                if self.inRangeX(xVal: point.x){
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            return false
        }

    }
    
    func inRange(val: CGFloat!)-> Bool {
        if (val <= maxY!) && (val >= minY!) {
            return true
        }
        else{
            return false
        }
    }
    
    func inRangeX(xVal: CGFloat)-> Bool {
        if (xVal <= maxX!) && (xVal >= minX!) {
            return true
        }
        else{
            return false
        }
    }
    
    func y(x: CGFloat)-> CGFloat {
        return m*x+b
    }
    
    // Takes another line and returns the intersection point.
    func intersectionPoint(line: Line) -> CGPoint? {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var returnMe: CGPoint? = nil
        
        if line.isVertical == true && self.isVertical == true {
            return nil
        }
        else if line.isHorizontal == true && self.isHorizontal == true {
            return nil
        }
        else if line.isVertical {
            x = line.firstPoint!.x
            y = self.y(x: x)
            if self.inRange(val: y) && line.inRange(val: y){
                returnMe = CGPoint(x: x,y: y)
            }
        }
        else if self.isVertical {
            x = self.firstPoint!.x
            y = line.y(x: x)
            if line.inRange(val: y) && self.inRange(val: y){
                returnMe = CGPoint(x: x,y: y)
            }
        }
        else if line.isHorizontal {
            y = line.firstPoint!.y
            x = (line.b-self.b)/(self.m-line.m)
            if self.inRange(val: y) && line.inRangeX(xVal: x){
                returnMe = CGPoint(x: x,y: y)
            }
            
        }
        else if self.isHorizontal {
            y = self.firstPoint!.y
            x = (line.b-self.b)/(self.m-line.m)
            if line.inRange(val: y) && self.inRangeX(xVal: x) {
                returnMe = CGPoint(x: x,y: y)
            }
        }
        else {
            x = (line.b-self.b)/(self.m-line.m)
            y = self.y(x: x)
            
            if self.inRange(val: y) && line.inRange(val: y)
            {
                returnMe = CGPoint(x: x,y: y)
            }
            else {
                print("returning nil from the final case")
                returnMe = nil
            }
            
        }
        
        if returnMe != nil {
            if distance(a: returnMe!, b: self.firstPoint!) < 10 {
                returnMe = self.firstPoint
            }
            else if distance(a: returnMe!, b: self.secondPoint!) < 10 {
                returnMe = self.secondPoint
            }
        }
        
        return returnMe
        
    }
    
    func printme(){
        print("m",self.m,"b",self.b)
    }
    
    init(_firstPoint: CGPoint,_secondPoint: CGPoint){
        
        firstPoint = _firstPoint
        secondPoint = _secondPoint
        
        let x1 = firstPoint?.x
        let y1 = firstPoint?.y
        let x2 = secondPoint?.x
        let y2 = secondPoint?.y
        
        maxY = max(y1!,y2!)
        minY = min(y1!,y2!)
        maxX = max(x1!,x2!)
        minX = min(x1!,x2!)
        
        if abs(x2!-x1!) < 1 {
            isVertical = true
        }
        
        if abs(y2!-y1!) < 1 {
            isHorizontal = true
            m = 0
            b = y1!
        }
        
        if !isVertical && !isHorizontal {
            m = (y2!-y1!)/(x2!-x1!)
            b = y1! - m*x1!
        }
        
        
    }
}
