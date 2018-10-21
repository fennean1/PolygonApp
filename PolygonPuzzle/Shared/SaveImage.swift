//
//  SaveImage.swift
//  PolygonPuzzle
//
//  Created by Andrew Leland Fenner on 9/25/18.
//  Copyright © 2018 Andrew Fenner. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    class func imageWithLayer(layer: CAShapeLayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

// For creating pure renderings of the layer without touch functionality or nodes etc.
class PurePolygon: CAShapeLayer {
    
    public var myColor: CGColor!
    public var myBorderColor: CGColor!
    
    
    func drawPolygon(at points: [CGPoint]){
        
        // Calculate the color based on the number of nodes
        myColor = getColorFromNumberOfSides(n: points.count,opacity: 1.0)
        
        var tempPoints = points
        
        self.opacity = 1
        self.lineWidth = self.frame.width/40
        self.strokeColor = UIColor.white.cgColor
        
        if points.count >= 10 {
            self.strokeColor = OneColor.cgColor
        }
        
        self.fillColor = myColor
        
        let start = tempPoints[0]
        tempPoints.remove(at: 0)
        
        let path = UIBezierPath()
        
        path.move(to: start)
        
        for p in tempPoints {
            let addTo = CGPoint(x: p.x, y: p.y)
            path.addLine(to: addTo)
        }
        
        path.close()
        // Don't need this anymore I don't think - Yes I do!
        self.path = path.cgPath
    
    }
}



// IDEA: Might need a more primitive polygon layer. One that just takes vertices and draws itself.

func createThumbNailView(vertices: [CGPoint],originalContextDim: CGFloat,newContextDim: CGFloat) -> UIView {
    
    let thumbNail = UIView()
    thumbNail.frame.size = CGSize(width: newContextDim, height: newContextDim)
    
    let scale = newContextDim/originalContextDim
    let scaledVertices = vertices.map({(p: CGPoint)-> CGPoint in return CGPoint(x: p.x*scale, y: p.y*scale)})
    let offsetVertices = scaledVertices.map({(p: CGPoint) -> CGPoint in return addPoints(a: PointZero, b: p)})

    // Need to apply offset to points before drawing the polygon so it draws in the center...    
    let frameOfNewLayer = getFrame(of: offsetVertices)
    let widthOfNewLayer = frameOfNewLayer.width
    let heightOfNewLayer = frameOfNewLayer.height
    let polygonLayerOriginX = thumbNail.center.x - widthOfNewLayer/2
    let polygonLayerOriginY = thumbNail.center.y - heightOfNewLayer/2
    let polygonLayer = PurePolygon()
    polygonLayer.frame = frameOfNewLayer
    polygonLayer.frame.origin = CGPoint(x: polygonLayerOriginX, y: polygonLayerOriginY)
    polygonLayer.drawPolygon(at: offsetVertices)
    thumbNail.layer.insertSublayer(polygonLayer, at: 0)
    
    return thumbNail
}



func createPuzzlePallette(polygons: [DraggablePolygon]) -> UIView  {
    
    let n: Int = 3
    let pallette = UIView()
    
    let dim: CGFloat = 2000
    let h = 1.3*dim
    
    let thumbDim = dim/CGFloat(n)
    
    pallette.frame.size = CGSize(width: dim, height: h)
    pallette.backgroundColor = UIColor.white
    
    for (i,p) in polygons.enumerated() {
        let iX = i%n
        let iY = (i-i%n)/n
        let thumb = createThumbNailView(vertices: p.vertices(), originalContextDim: InitialPolygonDim, newContextDim: thumbDim)
        pallette.addSubview(thumb)
        thumb.frame.origin = CGPoint(x: CGFloat(iX)*thumbDim, y: CGFloat(iY)*thumbDim)
        
    }
    
    return pallette
    
}

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

func saveAllPolygonsToPhotos() {
    
    let pallete = createPuzzlePallette(polygons: AllPolygons)
    let palleteImg = UIImage(view: pallete)
    
    UIImageWriteToSavedPhotosAlbum(palleteImg, nil, nil, nil);
    
}


