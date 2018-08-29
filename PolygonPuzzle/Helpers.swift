//
//  Helpers.swift
//  PolygonPuzzle
//
//  Created by Andrew Fenner on 7/21/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit


let niceColor = UIColor(red: 50, green: 20, blue: 30, alpha: 1.0)
// #139341
let colorForThree = UIColor(red:0.07, green:0.58, blue:0.25, alpha:1.0)
//#1DAFEC
let colorForFour = UIColor(red:0.11, green:0.69, blue:0.93, alpha:1.0)
// #042286
let colorForFive = UIColor(red:0.02, green:0.13, blue:0.53, alpha:1.0)
// #9D63B2
let colorForSix = UIColor(red:0.62, green:0.39, blue:0.70, alpha:1.0)
// #9D63B2
let colorForSeven = UIColor(red:0.92, green:0.09, blue:0.55, alpha:1.0)
// #D11431
let colorForEight = UIColor(red:0.82, green:0.08, blue:0.19, alpha:1.0)
// #F1662F
let colorForNine = UIColor(red:0.95, green:0.40, blue:0.18, alpha:1.0)


func getColorFromNumberOfSides(n: Int,opacity: CGFloat) -> CGColor{
    
    switch n {
    case 3:
        return UIColor(red:0.07, green:0.58, blue:0.25, alpha:1.0).cgColor
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


// Computes the origin for a polygon defined by an array of points
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

func pointsEqual(first: CGPoint,second: CGPoint) -> Bool {
    if distance(a: first, b: second) < 1{
        return true
    }
    else {
        return false
    }
}

