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
        
        print("inside containsPoint, point, self.y(x)",point,self.y(x: point.x))
        print("point.y-self.b",point.y - self.b,self.isHorizontal)
        // HELLO! What if...?
        if self.isHorizontal {
            if abs(point.y - self.b) < 2 {
                return true
            }
        }
        
        if self.isVertical {
            if abs(point.x - self.firstPoint!.x)<2{
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
        if (val < maxY!) && (val > minY!) {
            return true
        }
        else{
            return false
        }
    }
    
    func inRangeX(xVal: CGFloat)-> Bool {
        if (xVal < maxX!) && (xVal > minX!) {
            return true
        }
        else{
            return false
        }
    }
    
    func y(x: CGFloat)-> CGFloat {
        return m*x+b
    }
    
    func intersectionPoint(line: Line) -> CGPoint? {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var returnMe: CGPoint? = nil
        
        if line.isVertical == true && self.isVertical == true {
            print("BOTH VERTICAL")
            return nil
        }
        else if line.isHorizontal == true && self.isHorizontal == true {
            print("BOTH HORIZONTAL")
            return nil
        }
        else if line.isVertical {
            print("INPUT IS VERTICAL")
            x = line.firstPoint!.x
            y = self.y(x: x)
            if self.inRange(val: y){
                returnMe = CGPoint(x: x,y: y)
            }
            
        }
        else if self.isVertical {
            print("SELF IS VERTICAL")
            x = self.firstPoint!.x
            y = line.y(x: x)
            if line.inRange(val: y){
                returnMe = CGPoint(x: x,y: y)
            }
        }
        else if line.isHorizontal {
            print("INPUT HORIZONTAL")
            y = line.firstPoint!.y
            x = (line.b-self.b)/(self.m-line.m)
            if self.inRange(val: y) && line.inRangeX(xVal: x){
                returnMe = CGPoint(x: x,y: y)
            }
            
        }
        else if self.isHorizontal {
            print("SELF HORIZONTAL")
            y = self.firstPoint!.y
            x = (line.b-self.b)/(self.m-line.m)
            if line.inRange(val: y) && self.inRangeX(xVal: x) {
                returnMe = CGPoint(x: x,y: y)
            }
        }
        else {
            print("NORMAL CASE")
            x = (line.b-self.b)/(self.m-line.m)
            y = self.y(x: x)
            
            if self.inRange(val: y) && line.inRange(val: y)
            {
                print("REGULAR ASS MATCH FOUND!")
                returnMe = CGPoint(x: x,y: y)
            }
            else {
                print("returning nil from the final case")
                returnMe = nil
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
