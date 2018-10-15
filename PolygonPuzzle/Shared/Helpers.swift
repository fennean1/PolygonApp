//
//  Helpers.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/21/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit




extension CGRect {
    mutating func scaleBy(scale: CGFloat) {

        // Get current values
        let currW = self.width
        let currH = self.height
        let currX = self.minX
        let currY = self.minY

        // Scale new values
        let newX = currX*scale
        let newY = currY*scale
        let newW = currW*scale
        let newH = currH*scale
        
        self = CGRect(x: newX, y: newY, width: newW, height: newH)
        
    }
}


func unitVectors(from points: [CGPoint]) -> [CGPoint]{
    var uVectors: [CGPoint] = []
    
    for p in points  {
        let pLength = distance(a: PointZero, b: p)
        let dx = p.x/pLength
        let dy = p.y/pLength
        uVectors.append((CGPoint(x: dx, y: dy)))
    }
    return uVectors
}

func getColorFromNumberOfSides(n: Int,opacity: CGFloat) -> CGColor{
    
    let m = n%10
    
    switch m {
    case 0:
        return UIColor(red: 1.00, green:0.80, blue:0.00, alpha: opacity).cgColor
    case 1:
        return UIColor(red:0.96, green:0.90, blue:0.00, alpha: 1.0).cgColor
    case 2:
        return UIColor(red:0.78, green:0.82, blue:0.10, alpha: opacity).cgColor
    case 3:
        return UIColor(red:0.07, green:0.58, blue:0.25, alpha: opacity).cgColor
    case 4:
        return UIColor(red:0.11, green:0.69, blue:0.93, alpha: opacity).cgColor
    case 5:
        return UIColor(red:0.02, green:0.13, blue:0.53, alpha: opacity).cgColor
    case 6:
        return UIColor(red:0.62, green:0.39, blue:0.70, alpha: opacity).cgColor
    case 7:
        return UIColor(red:0.92, green:0.09, blue:0.55, alpha: opacity).cgColor
    case 8:
        return UIColor(red:0.82, green:0.08, blue:0.19, alpha: opacity).cgColor
    case 9:
        return UIColor(red:0.95, green:0.40, blue:0.18, alpha: opacity).cgColor
    default:
        return UIColor.black.cgColor
    }
}




// Finds duplicates in an array based on an arbitrary criteria
extension Array {
    
    func filterDuplicates(includeElement: (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        
        // Empty array that we'll populate with unique elements.
        var results = [Element]()
        
        forEach { (element) in
            // Check to see if element is already in the array by removing everything that's not equal to the element.
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            // Append to the results array if it has no matches in our existing array.d
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

// Removes duplicate nodes if they are m
func removeDuplicateNodes(nodes: [Node]) -> [Node] {

    
    // Function that gives the criteria for duplicates
    func duplicateCriteria(pointA: CGPoint, pointB: CGPoint) -> Bool
    {
        // Points are duplicates if the distance between them is non zero and less than one pixel.
        
        let d = distance(a: pointA, b: pointB)
        
        return abs(d) < 0.05
        
    }
    
    let filteredArray = nodes.filterDuplicates(includeElement: {duplicateCriteria(pointA: $0.location, pointB: $1.location)})
    
    print("NODES REMOVED:",nodes.count-filteredArray.count)
    
    return filteredArray
    
    
}


// Computes the origin for a polygon defined by an array of points (In the superview coordinate system)
func frame(of points: [CGPoint])-> CGRect {
    let xValues = points.map({p in p.x})
    let yValues = points.map({p in p.y})
    let xMin = xValues.min()
    let yMin = yValues.min()
    let xMax = xValues.max()
    let yMax = yValues.max()
    let h = yMax! - yMin!
    let w = xMax! - xMin!

    return CGRect(x: xMin!, y: yMin!, width: w, height: h)
}

func size(of points: [CGPoint]) -> CGSize {
    let xValues = points.map({p in p.x})
    let yValues = points.map({p in p.y})
    let xMin = xValues.min()
    let yMin = yValues.min()
    let xMax = xValues.max()
    let yMax = yValues.max()
    let h = yMax! - yMin!
    let w = xMax! - xMin!
    
    return CGSize(width: w, height: h)
    
}



// Takes an array of points and creates and array of lines. 
func makeLinesFromPoints(points: [CGPoint])-> [Line] {
    
    var returnTheseLines: [Line] = []
    
    let n = points.count
    
    for (i,p) in points.enumerated() {
        let j =  (i+1) % n
        let newLine = Line(_firstPoint: p, _secondPoint: points[j])
        returnTheseLines.append(newLine)
    }
    
    return returnTheseLines
}


// Applies an offset to an array of points (for transforming coordinate systems)
func mapPointsWithOffset(offSet: CGPoint,points: [CGPoint])-> [CGPoint]{
    return points.map({p in addPoints(a: p, b: offSet)})
}

// Extracts the points from an array of nodes.
func convertNodesToPoints(_nodes: [Node]) -> [CGPoint]{
    return _nodes.map({n in n.location})
}


// Defines an operation that adds two points together
func addPoints(a: CGPoint,b: CGPoint) -> CGPoint {
    
    let ax = a.x
    let ay = a.y
    
    let bx = b.x
    let by = b.y
    
    return CGPoint(x: ax+bx,y: ay+by)
    
}


// Defines an operation that adds two points together
func subtractPoints(a: CGPoint,b: CGPoint) -> CGPoint {
    
    let ax = a.x
    let ay = a.y
    
    let bx = b.x
    let by = b.y
    
    return CGPoint(x: ax-bx,y: ay-by)
}

// Defines an operation that adds two points together
func subtractBminusA(a: CGPoint,b: CGPoint) -> CGPoint {
    
    let ax = a.x
    let ay = a.y
    
    let bx = b.x
    let by = b.y
    
    return CGPoint(x: bx-ax,y: by-ay)
}


func distance(a: CGPoint,b: CGPoint) -> CGFloat {
    
    let x1 = a.x
    let y1 = a.y
    let x2 = b.x
    let y2 = b.y
    
    let deltaXSquared = pow(Double(x2-x1),2)
    let deltaYSquared = pow(Double(y2-y1),2)

    let rSquared  = deltaXSquared+deltaYSquared
    
    let d = sqrt(rSquared)
    
    return CGFloat(d)
}

func midPoint(a: CGPoint,b: CGPoint) -> CGPoint {

    let midX = (b.x+a.x)/2
    let midY = (b.y+a.y)/2
    
    return CGPoint(x: midX, y: midY)
}

func pointsEqual(first: CGPoint,second: CGPoint) -> Bool {
    if distance(a: first, b: second) < 1 {
        return true
    }
    else {
        return false
    }
}

