//
//  Vectors.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 8/29/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit
import Darwin

enum VectorPosition {
    case first
    case second
    case third
    case fourth
    case posY
    case negY
    case posX
    case negX
    case unknown
}

func getVectorPosition(dx: CGFloat, dy: CGFloat) -> VectorPosition {
    
    if dy == 0 {
        if dx > 0 {
            return VectorPosition.posX
        }
        else if dx < 0 {
            return VectorPosition.negX
        }
    }
    else if dx == 0 {
        if dy > 0 {
            print("on positive y")
            return VectorPosition.posY
        }
        else if dy < 0 {
            print("on negative y")
            return VectorPosition.negY
        }
    }
    else if dx > 0 && dy > 0 {
        return VectorPosition.first
    }
    else if dx > 0 && dy < 0 {
        return VectorPosition.fourth
    }
    else if dx < 0 && dy > 0 {
        return VectorPosition.second
    }
    else if dx < 0 && dy < 0 {
        return VectorPosition.third
    }
    else {
        print("This vector has an unknown position")
        return VectorPosition.unknown
    }
    return VectorPosition.unknown
}


class vector {
    
    var dx: CGFloat = 0
    var dy: CGFloat = 0
    
    var length: CGFloat = 0
    
    var theta: Double {
        
        let rawAngle = atan(Double(dy/dx))
        var adjustedAngle = rawAngle
        
        let vectorPosition = getVectorPosition(dx: dx,dy: dy)
        
        switch vectorPosition {
        case .second:
                adjustedAngle = rawAngle + Double.pi
        case .third:
                adjustedAngle = rawAngle + Double.pi
        case .fourth:
                adjustedAngle = rawAngle + 2*Double.pi
        case .negX:
                adjustedAngle = rawAngle + Double.pi
        case .negY:
                adjustedAngle = rawAngle + Double.pi
        default:
            let _ = adjustedAngle
        }
        
        return adjustedAngle
    }
    
    init(start: CGPoint,end: CGPoint){
        let startToEnd = subtractBminusA(a: start, b: end)
        dx = startToEnd.x
        dy = startToEnd.y
        length = distance(a: start, b: end)
    }
    
}
